# ALI Automation - Scoop Package

A Windows automation tool for creating IntelliJ-ready Gradle test projects with Java 11, Selenium, and Allure reporting.

## Installation

### Prerequisites

Before installing ALI Automation, make sure you have [Scoop](https://scoop.sh/) installed.

### Install ALI Automation

```powershell
# Add this bucket
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation

# Install ali-automation
scoop install ali-automation
```

### Install Required Dependencies

```powershell
# Install Java 11 (required)
scoop bucket add java
scoop install openjdk11
# or
scoop install temurin11-jdk

# Install Gradle (required)
scoop install gradle

# Install Git (optional, for version control)
scoop install git
```

## Usage

### Create a New Project

```powershell
ali-automation create-project MyTestProject
```

This will:

1. Prompt you for a package name (e.g., `com.i2c.automation.icm`)
2. Create a complete Gradle project structure
3. Generate Java test classes with Selenium and Allure setup
4. Configure IntelliJ IDEA module settings
5. Set up Gradle wrapper

### Show Version

```powershell
ali-automation version
```

### Show Help

```powershell
ali-automation help
```

## Project Structure

After creation, your project will have:

```
MyTestProject/
├── build.gradle                      # Gradle build configuration
├── settings.gradle                   # Gradle settings
├── gradlew.bat                       # Gradle wrapper (Windows)
├── MyTestProject.iml                 # IntelliJ module file
├── src/
│   ├── main/
│   │   ├── java/                     # Main source code
│   │   └── resources/                # Main resources
│   └── test/
│       ├── java/                     # Test source code
│       │   └── com/i2c/automation/   # Your package
│       │       └── mytestproject/
│       │           ├── MyTestProject.java              # Main test class
│       │           ├── MyTestProjectDataSource.java    # Data model
│       │           ├── MyTestProjectScreen.java        # Page object
│       │           └── Navigation.java                 # Navigation helper
│       └── resources/                # Test resources
├── datasource/
│   └── MyTestProject_DataSource.csv  # Test data CSV
└── cleanup/
    └── MyTestProject_CleanUp.sql     # SQL cleanup script
```

## Features

- ✅ **Java 11 Support**: Configured for Java 11 compatibility
- ✅ **Gradle Build**: Modern Gradle 6.7 setup with wrapper
- ✅ **Selenium WebDriver**: Chrome driver integration for browser automation
- ✅ **JUnit 5**: Parameterized tests with JUnit Jupiter
- ✅ **Allure Reporting**: Built-in Allure test reporting
- ✅ **CSV Data-Driven**: Test data management via CSV files
- ✅ **IntelliJ Ready**: Pre-configured for IntelliJ IDEA
- ✅ **Page Object Pattern**: Structured test architecture

## Dependencies Included

The generated project includes:

- JUnit 5 (Jupiter)
- Selenium WebDriver 4.6.0
- Allure Reporting 2.13.6
- Apache Commons CSV
- Apache Commons IO
- Informix JDBC Driver
- JSON processing

## Example Workflow

```powershell
# Create a new test project
ali-automation create-project LoginTests

# Navigate to the project
cd LoginTests

# Build the project
.\gradlew build

# Run tests
.\gradlew test

# Generate Allure report
.\gradlew allureReport
```

## Opening in IntelliJ IDEA

1. Open IntelliJ IDEA
2. Select **File → Open**
3. Navigate to your project folder
4. Select the folder and click **OK**
5. IntelliJ will automatically detect the Gradle project
6. Ensure Java 11 SDK is configured in **File → Project Structure → Project**

## Requirements

- Windows 10 or later
- Java 11 or higher
- Gradle 6.7+
- Chrome browser (for Selenium tests)
- IntelliJ IDEA (recommended)

## Troubleshooting

### Java 11 Not Found

```powershell
scoop install openjdk11
java -version  # Verify installation
```

### Gradle Not Found

```powershell
scoop install gradle
gradle -version  # Verify installation
```

### ChromeDriver Issues

Download ChromeDriver from [ChromeDriver Downloads](https://chromedriver.chromium.org/) and ensure it matches your Chrome version.

## License

MIT License - See LICENSE file for details

## Author

Ali Raza

## Support

For issues and feature requests, please visit:
https://github.com/alirazabrame/scoop-ali-automation/issues
