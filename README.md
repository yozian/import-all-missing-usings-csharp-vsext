# Import All Missing Usings C#

A powerful VS Code extension that automatically adds all missing `using` statements in C# files with a single command. No more manually adding namespaces one by one!

![Demo](https://github.com/yozian/import-all-missing-usings-csharp-vsext/blob/master/demo.gif?raw=true)

## ✨ Features

- **One-Click Fix**: Automatically detects and adds ALL missing `using` statements in a single operation
- **Smart Detection**: Scans for CS0246 errors and other "missing namespace" diagnostics
- **Duplicate Prevention**: Avoids adding existing `using` statements
- **Alphabetical Sorting**: Keeps your `using` statements organized
- **Fast Performance**: Collects all fixes and applies them in a single edit operation
- **Progress Feedback**: Shows real-time status updates during processing
- **Multiple Access Methods**: Available via Quick Fix, Command Palette, Context Menu, and Keyboard Shortcut

## 🚀 Usage

### Method 1: Quick Fix (Recommended)
1. Open a `.cs` file with missing namespace errors
2. Look for the lightbulb (💡) icon that appears when there are errors
3. Click it or press `Ctrl+.` (Cmd+. on Mac)
4. Select **"Import missing references in the file"**

### Method 2: Command Palette
1. Open a `.cs` file with missing namespace errors
2. Press `Ctrl+Shift+P` (Cmd+Shift+P on Mac) to open the command palette
3. Type "Import missing" and select **"C#: Import missing references in the file"**

### Method 3: Context Menu
1. Right-click anywhere in a `.cs` file
2. Select **"Import missing references in the file"** from the context menu

### Method 4: Keyboard Shortcut
1. Open a `.cs` file with missing namespace errors
2. Press `Alt+F Alt+U` to instantly fix all missing usings

## 📋 Example

**Before:**
```csharp
namespace MyApp
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var list = new List<string>(); // CS0246: Missing System.Collections.Generic
            Console.WriteLine("Hello!");    // CS0246: Missing System
            var json = JsonSerializer.Serialize(list); // CS0246: Missing System.Text.Json
        }
    }
}
```

**After (with one click):**
```csharp
using System;
using System.Collections.Generic;
using System.Text.Json;

namespace MyApp
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var list = new List<string>(); // ✅ Fixed!
            Console.WriteLine("Hello!");    // ✅ Fixed!
            var json = JsonSerializer.Serialize(list); // ✅ Fixed!
        }
    }
}
```

## ⚙️ Requirements

- **VS Code**: Version 1.85.0 or higher
- **C# Extension**: The official C# extension (ms-dotnettools.csharp) must be installed and active
- **.NET SDK**: A compatible .NET SDK for your project
- **OmniSharp**: Must be running (automatically started by the C# extension)

## 🔧 How It Works

1. **Scans** the current C# file for CS0246 and related "missing namespace" errors
2. **Analyzes** available code actions from the C# language server
3. **Extracts** namespace names from "using XYZ;" quick fixes
4. **Filters** out duplicates and existing using statements
5. **Applies** all missing using statements in a single edit operation
6. **Saves** the document automatically

## 🎯 Supported Error Types

- `CS0246`: The type or namespace name could not be found
- Generic "missing using directive" messages
- "Are you missing a using directive" suggestions

## 🚨 Troubleshooting

### Extension doesn't appear in Quick Fix menu
- Ensure you have CS0246 errors in your file
- Make sure the C# extension is installed and OmniSharp is running
- Check that your file is saved with a `.cs` extension

### No using statements are added
- Verify that the C# language server suggests "using" fixes for your errors
- Some types may not have available namespace fixes
- Check the Output panel (View → Output → "Import All Missing Usings C#") for diagnostic logs

### OmniSharp not working
- Restart OmniSharp: `Ctrl+Shift+P` → "OmniSharp: Restart OmniSharp"
- Check that you have a valid .NET project file (`.csproj`, `.sln`)
- Ensure your .NET SDK is properly installed

### Keyboard shortcut not working
- The default shortcut is `Alt+F Alt+U` (press Alt+F, release, then press Alt+U)
- You can customize this in VS Code settings under File → Preferences → Keyboard Shortcuts
- Search for "Import missing references" to find and modify the shortcut

## 📊 Performance

- **Fast**: Processes all missing namespaces in a single pass
- **Efficient**: No iterative loops or document watching delays
- **Reliable**: Uses the same code actions as manual Quick Fixes

## 🔄 Version History

### 0.0.1
- Initial release
- Single-pass namespace collection and application
- Smart duplicate detection
- Progress status bar integration

## 🤝 Contributing

Found a bug or have a feature request? Please open an issue on the [GitHub repository](https://github.com/yozian/import-all-missing-usings-csharp-vsext).

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Enjoy coding with fewer manual namespace imports!** 🎉

*Note: All code in this project is generated by AI.*
