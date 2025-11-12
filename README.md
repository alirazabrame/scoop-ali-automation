# ALI Automation - Scoop Package

A Windows automation tool for creating IntelliJ-ready Gradle test projects with Java 11, Selenium, and Allure reporting.

## 📋 Prerequisites

1. **Scoop Package Manager**: Install from [scoop.sh](https://scoop.sh/)

   ```powershell
   # Run this in PowerShell
   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
   irm get.scoop.sh | iex
   ```

2. **Java 11 JDK**: Required for running the generated projects

   ```powershell
   scoop bucket add java
   scoop install openjdk11
   ```

3. **Gradle**: Build automation tool

   ```powershell
   scoop install gradle
   ```

4. **Git**: For version control (optional but recommended)
   ```powershell
   scoop install git
   ```

## 🚀 Installation

### Add the ALI Automation Bucket

```powershell
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation
```

### Install ALI Automation

```powershell
scoop install ali-automation
```

## 💡 Usage

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

## 🎯 Example Workflow

```powershell
# Create a new test project
ali-automation create-project LoginTests

# Navigate to the project
cd LoginTests

# Build the project
.\gradlew.bat build

# Run tests
.\gradlew.bat test

# Generate Allure report
.\gradlew.bat allureReport
```

## 🔧 Opening in IntelliJ IDEA

1. Open IntelliJ IDEA
2. Select **File → Open**
3. Navigate to your project folder (e.g., `LoginTests`)
4. Select the folder and click **OK**
5. IntelliJ will automatically detect the Gradle project and `.iml` file
6. Wait for Gradle to sync dependencies
7. Ensure Java 11 SDK is configured in **File → Project Structure → Project**

## 📊 Working with Test Data

The generated project includes a CSV-based data-driven testing approach:

1. Edit `datasource\<ProjectName>_DataSource.csv` to add test data
2. Each row becomes a test case
3. Add columns as needed for your test scenarios

Example CSV structure:

```csv
TC_ID,Scenario_Description,Application_URL
TC_001,Valid Login Test,https://example.com/login
TC_002,Invalid Login Test,https://example.com/login
```

## 🧪 Running Tests

```powershell
# Run all tests
.\gradlew.bat test

# Run with Allure report generation
.\gradlew.bat clean test allureReport

# View Allure report
.\gradlew.bat allureServe
```

## 🔍 Project Customization

After generating a project, you can customize:

1. **Dependencies**: Edit `build.gradle` to add/remove libraries
2. **Test Data**: Modify CSV files in the `datasource` folder
3. **Page Objects**: Add more screen classes for different pages
4. **Cleanup Scripts**: Update SQL scripts in the `cleanup` folder

## 💻 Requirements

- **OS**: Windows 10 or later
- **Java**: Java 11 JDK or higher
- **Gradle**: 6.7+ (automatically installed via wrapper)
- **Browser**: Chrome browser (for Selenium tests)
- **IDE**: IntelliJ IDEA (recommended)
- **ChromeDriver**: Selenium will download automatically

## 🐛 Troubleshooting

### Java 11 Not Found

```powershell
scoop install openjdk11
java -version  # Verify installation
```

### Gradle Not Found

```powershell
scoop install gradle
gradle --version  # Verify installation
```

### PowerShell Execution Policy Error

If you see an error about script execution:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### ChromeDriver Issues

The script uses Selenium Manager to automatically download ChromeDriver. If you encounter issues:

1. Ensure Chrome browser is installed
2. Update Chrome to the latest version
3. Selenium 4.6.0+ handles driver management automatically

### Package Name Format

When prompted for package name, use Java package convention:

- ✅ Good: `com.company.project.module`
- ❌ Bad: `Company.Project`, `company/project`

## 🔄 Updating

```powershell
# Update to the latest version
scoop update ali-automation

# Check current version
ali-automation version
```

## 🗑️ Uninstalling

```powershell
scoop uninstall ali-automation
```

## 📚 Additional Resources

- [Scoop Documentation](https://scoop.sh/)
- [Gradle User Guide](https://docs.gradle.org/)
- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/)
- [Allure Report](https://docs.qameta.io/allure/)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details

## 👨‍💻 Author

**Ali Raza**

- GitHub: [@alirazabrame](https://github.com/alirazabrame)

## 🙏 Acknowledgments

- Built for Windows automation testing with Selenium and Java
- Designed for integration with IntelliJ IDEA
- Optimized for data-driven testing with CSV files

---

**Note**: This tool is specifically designed for Windows using Scoop package manager. For macOS/Linux, see the Homebrew version.

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
