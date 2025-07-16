const vscode = require("vscode");

class CSharpImportAllUsingsCodeActionProvider {
  provideCodeActions(document, range, context, token) {
    if (document.languageId !== 'csharp') return [];

    const action = new vscode.CodeAction(
      'Import missing references in the file',
      vscode.CodeActionKind.QuickFix
    );

    action.command = {
      command: 'importAllUsings.run',
      title: 'Import missing references in the file'
    };

    action.isPreferred = true;

    return [action];
  }
}

// Global variable to track if Import All is running
let isImportAllRunning = false;

async function importAllMissingUsings() {
  if (isImportAllRunning) {
    vscode.window.showWarningMessage("Import All is already running. Please wait for it to complete.");
    return;
  }

  const editor = vscode.window.activeTextEditor;
  if (!editor || editor.document.languageId !== "csharp") {
    vscode.window.showWarningMessage("Please open a C# file to use Import All Missing Usings");
    return;
  }

  isImportAllRunning = true;
  const startTime = Date.now();
  const maxDuration = 10; // 10 seconds timeout (reduced)

  // Check if auto-save is enabled (for logging only)
  const autoSave = vscode.workspace.getConfiguration('files').get('autoSave');
  const formatOnSave = vscode.workspace.getConfiguration('editor').get('formatOnSave');
  const codeActionsOnSave = vscode.workspace.getConfiguration('editor').get('codeActionsOnSave');
  const csharpOrganizeImports = vscode.workspace.getConfiguration('csharp').get('organizeImportsOnFormat');
  
  console.log(`Auto-save: ${autoSave}`);
  console.log(`Format on save: ${formatOnSave}`);
  console.log(`Code actions on save:`, codeActionsOnSave);
  console.log(`C# organize imports: ${csharpOrganizeImports}`);

  try {
    const doc = editor.document;
    const initialText = doc.getText();
    const initialUsingCount = (initialText.match(/^using\s+/gm) || []).length;
    console.log(`Initial using statements: ${initialUsingCount}`);

    // Show progress with a status bar message
    const statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left);
    statusBarItem.text = "$(sync~spin) Collecting missing using statements...";
    statusBarItem.show();

    try {
      // Get all missing namespace diagnostics
      const diagnostics = vscode.languages.getDiagnostics(doc.uri);
      const missingNamespaceErrors = diagnostics.filter(diagnostic =>
        diagnostic.code === 'CS0246' ||
        diagnostic.code === 'cs0246' ||
        /could not be found|missing a using directive|are you missing a using directive/i.test(diagnostic.message)
      );

      console.log(`Found ${missingNamespaceErrors.length} missing namespace errors`);

      if (missingNamespaceErrors.length === 0) {
        console.log('No missing namespace errors found');
        vscode.window.showInformationMessage("ℹ️ No missing using statements found");
        return;
      }

      // Collect all unique using statements to add
      const usingStatementsToAdd = new Set();
      statusBarItem.text = `$(sync~spin) Analyzing ${missingNamespaceErrors.length} errors...`;

      for (let errorIndex = 0; errorIndex < missingNamespaceErrors.length; errorIndex++) {
        const diagnostic = missingNamespaceErrors[errorIndex];
        const range = diagnostic.range;
        
        console.log(`Analyzing error ${errorIndex + 1}/${missingNamespaceErrors.length}: ${diagnostic.message} at line ${range.start.line}`);

        try {
          const codeActions = await vscode.commands.executeCommand(
            "vscode.executeCodeActionProvider",
            doc.uri,
            range,
            vscode.CodeActionKind.QuickFix.value
          );

          console.log(`Found ${codeActions?.length || 0} code actions for this error`);

          // Find the first using statement action for this error
          for (const action of codeActions || []) {
            const title = action.title || '';
            // Match titles that look like C# using statements: "using SomeNamespace;"
            const isUsingFix = /^using\s+[\w\.]+\s*;?\s*$/i.test(title);

            if (isUsingFix) {
              console.log(`Found using action: "${title}"`);
              
              // Extract the namespace from the title
              const namespaceMatch = title.match(/^using\s+([\w\.]+)\s*;?\s*$/i);
              if (namespaceMatch) {
                const namespace = namespaceMatch[1];
                usingStatementsToAdd.add(namespace);
                console.log(`Added namespace to collection: ${namespace}`);
                break; // Only take the first using action for this error
              }
            }
          }
        } catch (err) {
          console.warn(`Error getting code actions for diagnostic:`, err);
        }
      }

      console.log(`Collected ${usingStatementsToAdd.size} unique using statements to add:`, Array.from(usingStatementsToAdd));

      if (usingStatementsToAdd.size === 0) {
        console.log('No using statements could be extracted from code actions');
        vscode.window.showInformationMessage("ℹ️ No using statement fixes could be determined");
        return;
      }

      // Apply all using statements in a single edit
      statusBarItem.text = `$(sync~spin) Adding ${usingStatementsToAdd.size} using statements...`;
      
      const edit = new vscode.WorkspaceEdit();
      const document = editor.document;
      
      // Find the best position to insert using statements (after existing ones)
      let insertPosition = new vscode.Position(0, 0);
      
      // Look for existing using statements and insert after them
      for (let i = 0; i < document.lineCount; i++) {
        const line = document.lineAt(i);
        if (line.text.trim().startsWith('using ')) {
          insertPosition = new vscode.Position(i + 1, 0);
        } else if (line.text.trim() && !line.text.trim().startsWith('//')) {
          // Stop at the first non-using, non-comment line
          break;
        }
      }

      // Get existing using statements to avoid duplicates
      const existingUsings = new Set();
      const text = document.getText();
      const existingUsingMatches = text.match(/^using\s+([\w\.]+)\s*;/gm) || [];
      existingUsingMatches.forEach(match => {
        const namespaceMatch = match.match(/^using\s+([\w\.]+)\s*;/);
        if (namespaceMatch) {
          existingUsings.add(namespaceMatch[1]);
        }
      });

      // Filter out namespaces that already exist
      const newUsings = Array.from(usingStatementsToAdd).filter(ns => !existingUsings.has(ns));
      
      if (newUsings.length === 0) {
        console.log('All required using statements already exist');
        vscode.window.showInformationMessage("ℹ️ All required using statements already exist");
        return;
      }

      // Sort the new using statements alphabetically
      newUsings.sort();
      
      // Create the text to insert
      const usingStatementsText = newUsings.map(ns => `using ${ns};\n`).join('');
      
      console.log(`Inserting at position ${insertPosition.line}:${insertPosition.character}:`);
      console.log(usingStatementsText);
      
      edit.insert(document.uri, insertPosition, usingStatementsText);
      
      // Apply the single edit with all using statements
      const success = await vscode.workspace.applyEdit(edit);
      
      if (success) {
        console.log(`Successfully added ${newUsings.length} using statements`);
        
        // Save the document
        if (editor.document.isDirty) {
          console.log('Saving document...');
          await editor.document.save();
        }
        
        vscode.window.showInformationMessage(`✅ Added ${newUsings.length} missing using statement${newUsings.length > 1 ? 's' : ''}`);
      } else {
        console.error('Failed to apply edit');
        vscode.window.showErrorMessage('Failed to add using statements');
      }

    } finally {
      // Always clean up the status bar
      statusBarItem.dispose();
      isImportAllRunning = false;
    }
  } catch (error) {
    vscode.window.showErrorMessage(`Error applying fixes: ${error.message}`);
    console.error('ImportAll Error:', error);
    isImportAllRunning = false;
  }
}

function activate(context) {
  context.subscriptions.push(
    vscode.commands.registerCommand("importAllUsings.run", importAllMissingUsings)
  );

  context.subscriptions.push(
    vscode.languages.registerCodeActionsProvider(
      'csharp',
      new CSharpImportAllUsingsCodeActionProvider(),
      { providedCodeActionKinds: [vscode.CodeActionKind.QuickFix] }
    )
  );
}

function deactivate() {}

module.exports = {
  activate,
  deactivate
};
