# ALI Automation - Windows Setup Guide

This guide will help you set up and use ALI Automation on Windows via Scoop.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Detailed Usage](#detailed-usage)
5. [Project Structure](#project-structure)
6. [Troubleshooting](#troubleshooting)

## Prerequisites

### 1. Install Scoop (if not already installed)

Open PowerShell and run:

```powershell
# Set execution policy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install Scoop
irm get.scoop.sh | iex
```

For more information, visit [Scoop.sh](https://scoop.sh/)

### 2. Install Git (Optional but recommended)

```powershell
scoop install git
```

## Installation

### Step 1: Add the ali-automation bucket

```powershell
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation
```

### Step 2: Install ali-automation

```powershell
scoop install ali-automation
```

### Step 3: Install required dependencies

```powershell
# Add Java bucket
scoop bucket add java

# Install Java 11 (required)
scoop install openjdk11
# OR
scoop install temurin11-jdk

# Install Gradle (required)
scoop install gradle

# Verify installations
java -version
gradle -version
```

## Quick Start

### Create Your First Project

```powershell
# Create a new test project
ali-automation create-project MyFirstProject

# When prompted, enter your package name:
# Example: com.i2c.automation.myapp
# Or press Enter to use default: com.i2c.automation.aliapp

# Navigate to the project
cd MyFirstProject

# Build the project
.\gradlew build

# Run tests
.\gradlew test
```

## Detailed Usage

### Command Reference

#### 1. Create Project

```powershell
ali-automation create-project <ProjectName>
```

**What it does:**

- Creates a complete Gradle project structure
- Generates Java test classes with Selenium setup
- Configures IntelliJ IDEA module
- Sets up CSV data source
- Creates SQL cleanup scripts
- Initializes Gradle wrapper

**Interactive prompts:**

- Package name (e.g., `com.i2c.automation.icm`)
- Press Enter for default: `com.i2c.automation.aliapp`

#### 2. Show Version

```powershell
ali-automation version
```

#### 3. Show Help

```powershell
ali-automation help
```

### Working with the Generated Project

#### Directory Structure

```
MyFirstProject/
├── build.gradle                           # Gradle build configuration
├── settings.gradle                        # Gradle settings
├── gradlew.bat                           # Gradle wrapper for Windows
├── MyFirstProject.iml                    # IntelliJ module file
├── src/
│   ├── main/
│   │   ├── java/                        # Main source (your package)
│   │   └── resources/                   # Main resources
│   └── test/
│       ├── java/                        # Test source
│       │   └── com/i2c/automation/      # Your package structure
│       │       └── myfirstproject/
│       │           ├── MyFirstProject.java           # Main test class
│       │           ├── MyFirstProjectDataSource.java # Data model
│       │           ├── MyFirstProjectScreen.java     # Page object
│       │           └── Navigation.java               # Navigation helper
│       └── resources/                   # Test resources
├── datasource/
│   └── MyFirstProject_DataSource.csv    # Test data
└── cleanup/
    └── MyFirstProject_CleanUp.sql       # Database cleanup
```

#### Gradle Commands

```powershell
# Build the project
.\gradlew build

# Run tests
.\gradlew test

# Clean build artifacts
.\gradlew clean

# Generate Allure report
.\gradlew allureReport

# View Allure report
.\gradlew allureServe

# List all tasks
.\gradlew tasks
```

### Opening in IntelliJ IDEA

1. **Open IntelliJ IDEA**
2. **File → Open**
3. **Navigate to your project folder** (e.g., `MyFirstProject`)
4. **Select the folder and click OK**
5. IntelliJ will auto-detect the Gradle project
6. **Configure JDK:**
   - Go to **File → Project Structure → Project**
   - Set **Project SDK** to Java 11
   - Set **Project language level** to 11

### Configuring ChromeDriver

The generated project uses Selenium WebDriver. You need ChromeDriver:

1. **Download ChromeDriver:**

   - Visit [ChromeDriver Downloads](https://chromedriver.chromium.org/downloads)
   - Download version matching your Chrome browser

2. **Place ChromeDriver:**
   - Option A: Add to PATH (recommended)
   - Option B: Update path in `<ProjectName>.java`:
     ```java
     System.setProperty("webdriver.chrome.driver", "C:\\path\\to\\chromedriver.exe");
     ```

### Editing Test Data

Edit the CSV file in `datasource/<ProjectName>_DataSource.csv`:

```csv
TC_ID,Scenario_Description,Application_URL
TC001,Login Test,https://example.com
TC002,Dashboard Test,https://example.com/dashboard
```

Add columns as needed for your tests.

### Writing Tests

The main test class (`<ProjectName>.java`) includes:

```java
@ParameterizedTest
@MethodSource("provideParameters")
void execute(ProjectNameDataSource data) {
    try {
        // Add your test logic here
        driver.get(data.Application_URL);

        // Use Screen classes for page interactions
        ProjectNameScreen.getInstance().execute(driver, data);

        // Add assertions
        Assert.assertTrue(condition, "Test passed");

    } catch (Exception e) {
        data.Actual_Result = "Fail";
        Assert.fail("Fail: " + e.getMessage(), e);
    }
}
```

## Project Structure

### Files Explained

| File                       | Purpose                                          |
| -------------------------- | ------------------------------------------------ |
| `build.gradle`             | Gradle build configuration with all dependencies |
| `settings.gradle`          | Project name configuration                       |
| `gradlew.bat`              | Gradle wrapper script for Windows                |
| `*.iml`                    | IntelliJ IDEA module configuration               |
| `<Project>.java`           | Main test class with JUnit 5 setup               |
| `<Project>DataSource.java` | Data model for CSV rows                          |
| `<Project>Screen.java`     | Page Object Model class                          |
| `Navigation.java`          | Shared navigation utilities                      |
| `*_DataSource.csv`         | Test data file                                   |
| `*_CleanUp.sql`            | Database cleanup scripts                         |

### Dependencies Included

- **JUnit 5** (5.6.2) - Testing framework
- **Selenium WebDriver** (4.6.0) - Browser automation
- **Allure** (2.13.6) - Test reporting
- **Apache Commons CSV** (1.9.0) - CSV parsing
- **Apache Commons IO** (2.11.0) - File utilities
- **JSON** (20220924) - JSON processing
- **Informix JDBC** (4.50.9) - Database connectivity

## Troubleshooting

### Issue: "java is not recognized"

**Solution:**

```powershell
# Install Java 11
scoop install openjdk11

# Verify installation
java -version

# If still not working, check PATH:
$env:PATH
```

### Issue: "gradle is not recognized"

**Solution:**

```powershell
# Install Gradle
scoop install gradle

# Verify installation
gradle -version
```

### Issue: Gradle wrapper fails to download

**Solution:**

```powershell
# Update Gradle wrapper manually
gradle wrapper --gradle-version 6.7

# Or download dependencies explicitly
.\gradlew --refresh-dependencies
```

### Issue: ChromeDriver version mismatch

**Solution:**

1. Check Chrome version: `chrome://version`
2. Download matching ChromeDriver from [ChromeDriver Downloads](https://chromedriver.chromium.org/downloads)
3. Place in PATH or update code

### Issue: "Cannot find symbol" compilation errors

**Solution:**

```powershell
# Clean and rebuild
.\gradlew clean build --refresh-dependencies
```

### Issue: Tests fail with "Could not initialize class"

**Solution:**

- Ensure Java 11 is being used
- Check JAVA_HOME environment variable
- Verify in IntelliJ: File → Project Structure → Project SDK

### Issue: Permission denied on gradlew.bat

**Solution:**

```powershell
# This shouldn't happen on Windows, but if it does:
icacls gradlew.bat /grant Everyone:F
```

## Advanced Usage

### Using with CI/CD

Example GitHub Actions workflow:

```yaml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: windows-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up JDK 11
        uses: actions/setup-java@v2
        with:
          java-version: "11"
          distribution: "temurin"
      - name: Run tests
        run: .\gradlew test
      - name: Generate Allure report
        run: .\gradlew allureReport
```

### Customizing build.gradle

Add dependencies:

```gradle
dependencies {
    // Add your dependencies here
    testImplementation 'org.assertj:assertj-core:3.24.2'
}
```

### Multiple Test Suites

Create multiple test classes following the same pattern:

```java
public class LoginTests { ... }
public class DashboardTests { ... }
public class CheckoutTests { ... }
```

## Support and Resources

- **GitHub Repository:** https://github.com/alirazabrame/scoop-ali-automation
- **Issues:** https://github.com/alirazabrame/scoop-ali-automation/issues
- **Scoop Documentation:** https://scoop.sh/
- **Gradle Documentation:** https://docs.gradle.org/
- **Selenium Documentation:** https://www.selenium.dev/documentation/

## License

MIT License - See LICENSE file for details
