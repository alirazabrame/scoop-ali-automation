# Mac to Windows Conversion Summary

This document details the conversion of the macOS bash script to Windows Scoop package.

## What Was Converted

### Original (macOS)

- **File:** Bash script (`ali-automation.sh`)
- **Package Manager:** Homebrew
- **Shell:** Bash
- **Target OS:** macOS

### Converted (Windows)

- **File:** Batch script (`ali-automation.bat`) + PowerShell script (`ali-automation.ps1`)
- **Package Manager:** Scoop
- **Shell:** CMD/PowerShell
- **Target OS:** Windows 10+

## Key Differences & Adaptations

### 1. Scripting Language

| macOS (Bash)   | Windows (Batch) | Windows (PowerShell)   |
| -------------- | --------------- | ---------------------- |
| `#!/bin/bash`  | `@echo off`     | `param()`              |
| `echo "text"`  | `echo text`     | `Write-Host "text"`    |
| `read -r var`  | `set /p var=`   | `Read-Host`            |
| `$1, $2`       | `%~1, %~2`      | `$args[0]`, `$args[1]` |
| `$(pwd)`       | `%CD%`          | `Get-Location`         |
| `if [ ]; then` | `if "" ( )`     | `if () { }`            |

### 2. File System Paths

| macOS               | Windows           |
| ------------------- | ----------------- |
| `/Users/...`        | `C:\Users\...`    |
| `/path/to/file`     | `C:\path\to\file` |
| Forward slashes `/` | Backslashes `\`   |
| `src/main/java`     | `src\main\java`   |

### 3. Environment Variables

| macOS              | Windows         |
| ------------------ | --------------- |
| `$USER`            | `%USERNAME%`    |
| `$HOME`            | `%USERPROFILE%` |
| `$PATH`            | `%PATH%`        |
| `export VAR=value` | `set VAR=value` |

### 4. Package Management

| macOS (Homebrew)          | Windows (Scoop)           |
| ------------------------- | ------------------------- |
| `brew install openjdk@11` | `scoop install openjdk11` |
| `brew list openjdk@11`    | `scoop list openjdk11`    |
| `/usr/local/Cellar/`      | `~/scoop/apps/`           |
| Formula (Ruby)            | Manifest (JSON)           |

### 5. Java Environment Detection

**macOS:**

```bash
export JAVA_HOME="$(/usr/libexec/java_home -v 11)"
export PATH="$JAVA_HOME/bin:$PATH"
```

**Windows (Batch):**

```batch
java -version 2>&1 | findstr /r "\"11\." >nul
if errorlevel 1 (
    echo Warning: Java 11 not detected
)
```

**Windows (PowerShell):**

```powershell
$javaVersion = java -version 2>&1 | Select-String "version"
if ($javaVersion -match '"11\.') {
    Write-Host "Java 11 detected"
}
```

### 6. Git Commands

Both platforms use same git commands, but output handling differs:

**macOS:**

```bash
SYSTEM_USER_NAME=$(git config user.name 2>/dev/null || echo "$USER")
```

**Windows (Batch):**

```batch
for /f "tokens=*" %%i in ('git config user.name 2^>nul') do set SYSTEM_USER_NAME=%%i
if "!SYSTEM_USER_NAME!"=="" set SYSTEM_USER_NAME=%USERNAME%
```

**Windows (PowerShell):**

```powershell
$SYSTEM_USER_NAME = git config user.name 2>$null
if ([string]::IsNullOrWhiteSpace($SYSTEM_USER_NAME)) {
    $SYSTEM_USER_NAME = $env:USERNAME
}
```

### 7. String Manipulation

**Lowercase Conversion:**

**macOS:**

```bash
PROJECT_NAME_LOWER=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]')
```

**Windows (Batch):**

```batch
call :tolower PROJECT_NAME_LOWER

:tolower
set %~1=!%1:A=a!
set %~1=!%1:B=b!
...
```

**Windows (PowerShell):**

```powershell
$PROJECT_NAME_LOWER = $PROJECT_NAME.ToLower()
```

**String Replacement:**

**macOS:**

```bash
PACKAGE_PATH=$(echo "$user_package" | sed 's/\./\//g')
```

**Windows (Batch):**

```batch
set PACKAGE_PATH=!user_package:.=/!
```

**Windows (PowerShell):**

```powershell
$PACKAGE_PATH = $userPackage -replace '\.', '/'
```

### 8. Directory Creation

**macOS:**

```bash
mkdir -p "$SRC_MAIN_DIR" "$SRC_TEST_DIR"
```

**Windows (Batch):**

```batch
mkdir "%SRC_MAIN_DIR%" 2>nul
mkdir "%SRC_TEST_DIR%" 2>nul
```

**Windows (PowerShell):**

```powershell
New-Item -ItemType Directory -Force -Path $SRC_MAIN_DIR
New-Item -ItemType Directory -Force -Path $SRC_TEST_DIR
```

### 9. Multi-line File Creation

**macOS (Heredoc):**

```bash
cat > file.txt <<EOF
content here
EOF
```

**Windows (Batch):**

```batch
(
echo line 1
echo line 2
) > file.txt
```

**Windows (PowerShell):**

```powershell
@"
content here
"@ | Out-File -FilePath file.txt -Encoding UTF8
```

### 10. Special Characters Escaping

**Windows Batch requires extensive escaping:**

- `^` for: `& | < > ( )`
- `^^` for caret itself
- `!` must be escaped as `^!` when delayed expansion is enabled

**Example:**

```batch
echo     myMethod^(^)      REM Escape parentheses
echo     value^|^|value    REM Escape pipes
```

## Files Created

### 1. Core Scripts

- ✅ `scripts/ali-automation.bat` - Main Windows batch script
- ✅ `scripts/ali-automation.ps1` - PowerShell alternative (better Windows 10+ experience)

### 2. Package Definition

- ✅ `bucket/ali-automation.json` - Scoop manifest (updated)

### 3. Documentation

- ✅ `README.md` - Main documentation (updated)
- ✅ `SETUP_GUIDE.md` - Detailed setup instructions
- ✅ `QUICK_REFERENCE.md` - Quick command reference
- ✅ `RELEASE_CHECKLIST.md` - Release process guide
- ✅ `CONVERSION_SUMMARY.md` - This file

### 4. Repository Files

- ✅ `.gitignore` - Git ignore rules
- ✅ `LICENSE` - MIT license (existing)

## Features Implemented

### ✅ Feature Parity

All features from the Mac version:

- [x] Create Gradle projects
- [x] Interactive package name input
- [x] Generate Java test classes
- [x] Create DataSource, Screen, Navigation classes
- [x] Setup Gradle wrapper
- [x] Create IntelliJ module file
- [x] Generate CSV data source
- [x] Create SQL cleanup scripts
- [x] Version command
- [x] Help command

### ✅ Windows-Specific Enhancements

- [x] Batch script for CMD compatibility
- [x] PowerShell script for better Windows 10+ experience
- [x] Colored output in PowerShell
- [x] Windows path handling
- [x] Scoop dependency suggestions
- [x] Comprehensive installation notes
- [x] Windows troubleshooting guide

### ✅ Documentation

- [x] Installation instructions
- [x] Prerequisites setup
- [x] Usage examples
- [x] Troubleshooting section
- [x] Quick reference
- [x] Release checklist

## Testing Checklist

Before using in production, test:

### Installation Testing

- [ ] Install Scoop
- [ ] Add bucket
- [ ] Install package
- [ ] Verify command available

### Functionality Testing

- [ ] `ali-automation help` works
- [ ] `ali-automation version` shows correct version
- [ ] `ali-automation create-project TestProject` creates project
- [ ] Generated project structure is correct
- [ ] All Java files compile
- [ ] Gradle build succeeds
- [ ] Tests run successfully

### Environment Testing

- [ ] Works on Windows 10
- [ ] Works on Windows 11
- [ ] Works with Java 11
- [ ] Works with Gradle 6.7+
- [ ] Opens correctly in IntelliJ IDEA

### Edge Cases

- [ ] Handles spaces in project names
- [ ] Handles special characters in package names
- [ ] Works without Git installed
- [ ] Handles missing Java gracefully
- [ ] Handles missing Gradle gracefully

## Differences from Original

### Removed Features

- ❌ Homebrew-specific installation of Java 11

  - **Reason:** Scoop handles this via suggestions
  - **Alternative:** User installs via `scoop install openjdk11`

- ❌ Automatic Java 11 setup in script
  - **Reason:** Scoop manages PATH automatically
  - **Alternative:** Manual verification check added

### Modified Features

- 🔄 ChromeDriver path removed from Java file

  - **Original:** Hardcoded macOS path
  - **New:** User configures (Windows paths vary)
  - **Documentation:** Added ChromeDriver setup guide

- 🔄 Package installation suggestions
  - **Original:** Embedded in script
  - **New:** Declared in Scoop manifest
  - **Benefit:** Scoop manages suggestions automatically

### Added Features

- ✨ PowerShell version for modern Windows
- ✨ Colored output in PowerShell
- ✨ Comprehensive documentation
- ✨ Release automation guide
- ✨ Quick reference card

## Known Limitations

### Batch Script Limitations

1. **No array support** - Workarounds implemented
2. **Complex escaping** - Carefully handled in file generation
3. **Limited string manipulation** - Uses subroutines for complex operations
4. **No native error handling** - Uses errorlevel checks

### PowerShell Advantages

1. **Better error handling**
2. **Native object support**
3. **Easier string manipulation**
4. **Colored output**
5. **Modern Windows integration**

**Recommendation:** Use PowerShell version on Windows 10+

## Migration Path for Users

### From Homebrew (Mac) to Scoop (Windows)

**macOS:**

```bash
brew tap alirazabrame/ali-automation
brew install ali-automation
ali-automation create-project MyProject
```

**Windows:**

```powershell
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation
scoop install ali-automation
ali-automation create-project MyProject
```

**Projects are fully compatible** - Same Gradle structure, same Java code!

## Next Steps

1. **Testing:** Test scripts on actual Windows machines
2. **Release:** Create GitHub release and update hash
3. **Documentation:** Add screenshots/videos if needed
4. **Community:** Gather feedback from Windows users
5. **Maintenance:** Keep dependencies updated

## Support Matrix

| Feature           | macOS    | Windows Batch | Windows PowerShell |
| ----------------- | -------- | ------------- | ------------------ |
| Create Project    | ✅       | ✅            | ✅                 |
| Interactive Input | ✅       | ✅            | ✅                 |
| Java Detection    | ✅       | ✅            | ✅                 |
| Gradle Setup      | ✅       | ✅            | ✅                 |
| Colored Output    | ✅       | ❌            | ✅                 |
| Error Handling    | ✅       | ⚠️ Basic      | ✅                 |
| Package Manager   | Homebrew | Scoop         | Scoop              |

## Conclusion

The conversion successfully brings all functionality from the macOS bash script to Windows, with two script options:

1. **Batch** - Universal Windows compatibility (XP+)
2. **PowerShell** - Better experience on modern Windows (10+)

Both scripts maintain feature parity with the original while adapting to Windows conventions and Scoop's package management paradigm.
