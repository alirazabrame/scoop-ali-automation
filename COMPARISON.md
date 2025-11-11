# macOS vs Windows: Side-by-Side Comparison

## Installation

### macOS (Homebrew)

```bash
# Install Homebrew (if needed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add tap and install
brew tap alirazabrame/ali-automation
brew install ali-automation

# Install dependencies
brew install openjdk@11
brew install gradle
```

### Windows (Scoop)

```powershell
# Install Scoop (if needed)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex

# Add bucket and install
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation
scoop install ali-automation

# Install dependencies
scoop bucket add java
scoop install openjdk11 gradle
```

## Usage

Both platforms use **identical commands**:

```bash
# Create project
ali-automation create-project MyProject

# Show version
ali-automation version

# Show help
ali-automation help
```

## Generated Project

**100% compatible** across platforms! The exact same project structure:

```
MyProject/
├── build.gradle
├── settings.gradle
├── gradlew                  # macOS/Linux
├── gradlew.bat              # Windows
├── MyProject.iml
├── src/
│   ├── main/
│   │   ├── java/
│   │   └── resources/
│   └── test/
│       ├── java/
│       │   └── com/i2c/automation/myproject/
│       │       ├── MyProject.java
│       │       ├── MyProjectDataSource.java
│       │       ├── MyProjectScreen.java
│       │       └── Navigation.java
│       └── resources/
├── datasource/
│   └── MyProject_DataSource.csv
└── cleanup/
    └── MyProject_CleanUp.sql
```

## Building & Running

### macOS

```bash
cd MyProject
./gradlew build        # Note: ./ prefix
./gradlew test
```

### Windows (CMD)

```batch
cd MyProject
.\gradlew.bat build    # Note: .\ prefix and .bat extension
.\gradlew.bat test
```

### Windows (PowerShell)

```powershell
cd MyProject
.\gradlew build        # PowerShell can omit .bat
.\gradlew test
```

## IntelliJ IDEA

**Same process on both platforms:**

1. File → Open
2. Select project folder
3. Wait for Gradle sync
4. File → Project Structure → Set Java 11 SDK

## ChromeDriver Setup

### macOS

```bash
# Using Homebrew
brew install chromedriver

# Or download and place in PATH
export PATH="/path/to/chromedriver:$PATH"
```

### Windows

```powershell
# Download from https://chromedriver.chromium.org/
# Add to PATH or specify in code:
# System.setProperty("webdriver.chrome.driver", "C:\\path\\to\\chromedriver.exe");
```

## Environment Variables

| Feature        | macOS   | Windows                               |
| -------------- | ------- | ------------------------------------- |
| User           | `$USER` | `%USERNAME%` or `$env:USERNAME`       |
| Home           | `$HOME` | `%USERPROFILE%` or `$env:USERPROFILE` |
| Path separator | `:`     | `;`                                   |
| Dir separator  | `/`     | `\`                                   |

## File Paths in Code

**Both platforms use forward slashes in Java:**

```java
// This works on BOTH macOS and Windows
new FileReader("datasource/MyProject_DataSource.csv")
new FileReader("src/test/resources/config.properties")
```

Java automatically handles path conversions!

## Git Commands

**Identical on both platforms:**

```bash
git config user.name
git config user.email
git init
git add .
git commit -m "message"
```

## Package Manager Commands

### Homebrew (macOS)

| Command                 | Description        |
| ----------------------- | ------------------ |
| `brew search <name>`    | Search for package |
| `brew install <name>`   | Install package    |
| `brew uninstall <name>` | Remove package     |
| `brew update`           | Update Homebrew    |
| `brew upgrade <name>`   | Update package     |
| `brew list`             | List installed     |
| `brew info <name>`      | Package info       |

### Scoop (Windows)

| Command                  | Description        |
| ------------------------ | ------------------ |
| `scoop search <name>`    | Search for package |
| `scoop install <name>`   | Install package    |
| `scoop uninstall <name>` | Remove package     |
| `scoop update`           | Update Scoop       |
| `scoop update <name>`    | Update package     |
| `scoop list`             | List installed     |
| `scoop info <name>`      | Package info       |

**Very similar!**

## Terminal/Shell

| macOS                | Windows                  |
| -------------------- | ------------------------ |
| Terminal.app         | Command Prompt (cmd.exe) |
| iTerm2               | Windows Terminal         |
| Bash (default)       | PowerShell (recommended) |
| zsh (modern default) | PowerShell 7 (modern)    |

## Key Differences

### 1. Script Implementation

| Aspect    | macOS         | Windows                 |
| --------- | ------------- | ----------------------- |
| Language  | Bash          | Batch + PowerShell      |
| Extension | `.sh`         | `.bat` + `.ps1`         |
| Shebang   | `#!/bin/bash` | `@echo off` / `param()` |
| Variables | `$VAR`        | `%VAR%` or `$VAR`       |

### 2. Line Endings

| Platform | Format        | Git Config            |
| -------- | ------------- | --------------------- |
| macOS    | LF (`\n`)     | `core.autocrlf=input` |
| Windows  | CRLF (`\r\n`) | `core.autocrlf=true`  |

**Git handles this automatically!**

### 3. Permissions

| macOS                | Windows               |
| -------------------- | --------------------- |
| `chmod +x script.sh` | Not needed for `.bat` |
| `./script.sh`        | `script.bat`          |
| Execute bit required | Execute bit not used  |

## Cross-Platform Gradle Commands

These work **identically** on both:

```bash
# macOS: ./gradlew
# Windows: .\gradlew or .\gradlew.bat

gradlew clean
gradlew build
gradlew test
gradlew tasks
gradlew dependencies
gradlew --version
gradlew wrapper --gradle-version 6.7
```

## Java Commands

**Identical syntax:**

```bash
java -version
java -jar myapp.jar
javac MyClass.java
```

## Development Workflow Comparison

### macOS

```bash
# 1. Install
brew install ali-automation openjdk@11 gradle

# 2. Create project
ali-automation create-project TestApp

# 3. Build
cd TestApp
./gradlew build

# 4. Open in IntelliJ
open -a "IntelliJ IDEA" .
```

### Windows

```powershell
# 1. Install
scoop install ali-automation openjdk11 gradle

# 2. Create project
ali-automation create-project TestApp

# 3. Build
cd TestApp
.\gradlew build

# 4. Open in IntelliJ
start idea64.exe .
```

## Update Process

### macOS

```bash
# Update ali-automation
brew update
brew upgrade ali-automation

# Update dependencies
brew upgrade openjdk@11
brew upgrade gradle
```

### Windows

```powershell
# Update ali-automation
scoop update
scoop update ali-automation

# Update dependencies
scoop update openjdk11
scoop update gradle
```

## Uninstallation

### macOS

```bash
brew uninstall ali-automation
brew untap alirazabrame/ali-automation
```

### Windows

```powershell
scoop uninstall ali-automation
scoop bucket rm ali-automation
```

## Testing Commands

**Identical on both platforms:**

```bash
# Run all tests
gradlew test

# Run specific test
gradlew test --tests "*MyTest*"

# Generate test report
gradlew allureReport

# View report
gradlew allureServe

# Clean before test
gradlew clean test
```

## IDE Support

| Feature       | macOS | Windows | Status       |
| ------------- | ----- | ------- | ------------ |
| IntelliJ IDEA | ✅    | ✅      | Full support |
| Eclipse       | ✅    | ✅      | Full support |
| VS Code       | ✅    | ✅      | Full support |
| NetBeans      | ✅    | ✅      | Full support |

## CI/CD

### GitHub Actions

**Works on both runners:**

```yaml
# macOS runner
runs-on: macos-latest

# Windows runner
runs-on: windows-latest

# Linux runner (bonus!)
runs-on: ubuntu-latest
```

**Same build commands work everywhere!**

## Summary Table

| Feature           | macOS       | Windows     | Compatible? |
| ----------------- | ----------- | ----------- | ----------- |
| Installation      | Homebrew    | Scoop       | Different   |
| Command syntax    | Same        | Same        | ✅ Yes      |
| Project structure | Same        | Same        | ✅ Yes      |
| Gradle commands   | Same        | Same        | ✅ Yes      |
| Java code         | Same        | Same        | ✅ Yes      |
| IntelliJ support  | Same        | Same        | ✅ Yes      |
| Git commands      | Same        | Same        | ✅ Yes      |
| Path handling     | Auto        | Auto        | ✅ Yes      |
| Line endings      | Git handles | Git handles | ✅ Yes      |

## Migration Between Platforms

**To move a project from macOS to Windows (or vice versa):**

1. **Copy project files** (entire project folder)
2. **Commit to Git** (recommended)
3. **Clone/copy on new platform**
4. **Run Gradle wrapper:**
   - macOS: `./gradlew build`
   - Windows: `.\gradlew build`
5. **Done!** Everything else is automatic

**No code changes needed!** Java, Gradle, and the project structure are fully cross-platform.

## Best Practices

### Cross-Platform Development

1. **Use Git** - Handles line endings automatically
2. **Use forward slashes** in Java code - Works on both platforms
3. **Don't hardcode paths** - Use relative paths
4. **Test on both** - If targeting both platforms
5. **Use Gradle wrapper** - Ensures consistent Gradle version

### Platform-Specific

**macOS:**

- Use Homebrew for dependencies
- Use `./gradlew` (with dot-slash)

**Windows:**

- Use Scoop for dependencies
- Use `.\gradlew` (backslash is optional in PowerShell)
- Prefer PowerShell over CMD

## Conclusion

**The generated projects are 100% compatible!**

The only differences are:

- ✅ Installation method (Homebrew vs Scoop)
- ✅ Shell syntax (internal implementation)
- ✅ Path separators (handled automatically)

**Your Java tests work identically on both platforms without any modifications!**
