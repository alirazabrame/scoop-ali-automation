# ALI Automation - Quick Reference

## Installation

```powershell
# One-time setup
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation
scoop bucket add java
scoop install ali-automation openjdk11 gradle
```

## Commands

| Command                                | Description        |
| -------------------------------------- | ------------------ |
| `ali-automation create-project <name>` | Create new project |
| `ali-automation version`               | Show version       |
| `ali-automation help`                  | Show help          |

## Project Commands

```powershell
# After creating a project
cd MyProject

.\gradlew build          # Build project
.\gradlew test           # Run tests
.\gradlew clean          # Clean artifacts
.\gradlew allureReport   # Generate report
.\gradlew allureServe    # View report
```

## File Locations

```
MyProject/
├── src/test/java/com/i2c/automation/myproject/  # Your test code
├── datasource/MyProject_DataSource.csv          # Test data
└── cleanup/MyProject_CleanUp.sql                # SQL scripts
```

## Common Tasks

### 1. Add Test Data

Edit `datasource/<Project>_DataSource.csv`:

```csv
TC_ID,Scenario_Description,Application_URL
TC001,Test Login,https://example.com
```

### 2. Write Test Logic

Edit `src/test/java/.../MyProject.java`:

```java
void execute(MyProjectDataSource data) {
    driver.get(data.Application_URL);
    // Add your test steps
}
```

### 3. Run Specific Test

```powershell
.\gradlew test --tests "*MyProject*"
```

## Troubleshooting Quick Fixes

```powershell
# Java not found
scoop install openjdk11
java -version

# Gradle not found
scoop install gradle
gradle -version

# Clean and rebuild
.\gradlew clean build --refresh-dependencies

# Update Gradle wrapper
gradle wrapper --gradle-version 6.7
```

## IntelliJ Setup

1. File → Open → Select project folder
2. File → Project Structure → Project
3. Set SDK to Java 11
4. Set language level to 11

## ChromeDriver Setup

1. Download from: https://chromedriver.chromium.org/
2. Add to PATH or update in code:

```java
System.setProperty("webdriver.chrome.driver", "C:\\path\\to\\chromedriver.exe");
```

## Dependencies Included

- JUnit 5 (5.6.2)
- Selenium WebDriver (4.6.0)
- Allure Reporting (2.13.6)
- Apache Commons CSV (1.9.0)
- Apache Commons IO (2.11.0)

## Links

- **Docs:** https://github.com/alirazabrame/scoop-ali-automation
- **Issues:** https://github.com/alirazabrame/scoop-ali-automation/issues
- **Scoop:** https://scoop.sh/
