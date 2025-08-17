# NPM Bulk Installer

🚀 Cross-platform scripts to automatically find and install npm packages across multiple projects in a directory tree.

## Features

- 🔍 **Recursive Search**: Automatically finds all `package.json` files in subdirectories
- 🚫 **Smart Filtering**: Skips `node_modules` directories to avoid redundant installations
- 🎨 **Colored Output**: Clear visual feedback with color-coded success/error messages
- 📝 **Detailed Logging**: Comprehensive log file with timestamps and error details
- 📊 **Progress Tracking**: Real-time progress display with counters
- ✅ **Batch Operations**: Process hundreds of projects in a single run
- 🔄 **Error Recovery**: Continues processing even if some installations fail

## 🎯 Available Scripts

| Platform | Script | Description |
|----------|--------|-------------|
| Windows (PowerShell) | `npm-installer.ps1` | Full-featured PowerShell script with colored output |
| Windows (Batch) | `npm-installer.bat` | Classic batch script for older Windows systems |
| Linux/Mac | `npm-installer.sh` | Bash script for Unix-like systems |

## Installation

1. Clone this repository:
```bash
git clone https://github.com/ersinkoc/npm-bulk-installer.git
cd npm-bulk-installer
```

2. Ensure PowerShell execution policy allows running scripts:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Usage

### 🪟 Windows (PowerShell)

Run in the current directory:
```powershell
.\npm-installer.ps1
```

### 🪟 Windows (Batch)

Run in the current directory:
```cmd
npm-installer.bat
```

Specify target directory and log file:
```cmd
npm-installer.bat "C:\Projects" "my-log.txt"
```

### 🐧 Linux/Mac (Bash)

First, make the script executable:
```bash
chmod +x npm-installer.sh
```

Run in the current directory:
```bash
./npm-installer.sh
```

Specify target directory and log file:
```bash
./npm-installer.sh /home/user/projects my-log.txt
```

### Advanced Usage (PowerShell)

Specify a target directory:
```powershell
.\npm-installer.ps1 -StartPath "C:\Projects"
```

Custom log file name:
```powershell
.\npm-installer.ps1 -LogFile "installation-log.txt"
```

Skip confirmation prompt:
```powershell
.\npm-installer.ps1 -SkipConfirmation
```

Combine parameters:
```powershell
.\npm-installer.ps1 -StartPath "C:\Projects" -LogFile "my-log.txt" -SkipConfirmation
```

## Parameters

### PowerShell Script

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `-StartPath` | String | Current directory | Root directory to start searching for package.json files |
| `-LogFile` | String | `npm-install-log.txt` | Name of the log file to create |
| `-SkipConfirmation` | Switch | `$false` | Skip the confirmation prompt before starting installations |

### Batch & Bash Scripts

| Parameter | Position | Default | Description |
|-----------|----------|---------|-------------|
| Path | 1st | Current directory | Root directory to search |
| Log file | 2nd | `npm-install-log.txt` | Log file name |

## Output

The script provides:

1. **Console Output**: Real-time colored feedback showing:
   - Found package.json files
   - Installation progress
   - Success/failure status for each project
   - Final summary statistics

2. **Log File**: Detailed text log containing:
   - Timestamp for each operation
   - Directory paths
   - npm output (including warnings and errors)
   - Exit codes for failed installations

## Example Output

```
========================================
    NPM Package Installer (Simple)
========================================
Start directory: C:\Projects
Log file: C:\Projects\npm-install-log.txt

Searching for package.json files...
Found 25 package.json files

Directories to process:
  [1] frontend-app
  [2] backend-api
  [3] shared-components
  ...

Starting npm install operations...
========================================

[1/25] frontend-app
  Running npm install...
  [OK] Success!

[2/25] backend-api
  Running npm install...
  [OK] Success!

========================================
         SUMMARY
========================================
Total packages: 25
Successful: 23
Failed: 2

Failed directories:
  - old-project
  - deprecated-service

Log file saved to: C:\Projects\npm-install-log.txt
```

## Use Cases

- **Monorepo Management**: Install dependencies for all packages in a monorepo
- **Project Migration**: Quickly set up dependencies after cloning multiple repositories
- **CI/CD Pipelines**: Automate dependency installation in build processes
- **Development Environment Setup**: Initialize a new development machine with multiple projects
- **Dependency Updates**: Bulk update dependencies across multiple projects

## Requirements

### All Platforms
- Node.js and npm installed and available in PATH
- Appropriate permissions to write files and install npm packages

### Platform-Specific
- **Windows (PowerShell)**: PowerShell 5.1 or higher
- **Windows (Batch)**: Windows XP or higher
- **Linux/Mac**: Bash 4.0 or higher

## Troubleshooting

### Script won't run
- Check PowerShell execution policy: `Get-ExecutionPolicy`
- Run as Administrator if needed
- Ensure the script file is not blocked: `Unblock-File .\npm-installer.ps1`

### npm install failures
- Check the log file for detailed error messages
- Ensure npm is properly installed: `npm --version`
- Verify package.json files are valid JSON
- Check for network connectivity issues
- Ensure sufficient disk space

### Performance issues
- The script processes directories sequentially to avoid overwhelming system resources
- For very large numbers of projects, consider running in batches
- Close unnecessary applications to free up system resources

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Add support for more package managers (yarn, pnpm)
- Improve error handling
- Add more features
- Fix bugs

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

## 🌟 Star History

If you find this tool useful, please consider giving it a star ⭐

## Acknowledgments

- Built for developers who manage multiple Node.js projects
- Inspired by the need to streamline dependency management
- Special thanks to the open source community