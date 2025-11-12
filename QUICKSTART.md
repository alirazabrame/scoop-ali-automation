# Quick Start Guide

Get started with ALI Automation in 5 minutes! 🚀

## Prerequisites (5 minutes)

### 1. Install Scoop

Open PowerShell and run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

### 2. Install Java and Gradle

```powershell
scoop bucket add java
scoop install openjdk11 gradle
```

## Installation (1 minute)

```powershell
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation
scoop install ali-automation
```

## Create Your First Project (2 minutes)

### Step 1: Create Project

```powershell
ali-automation create-project MyFirstTest
```

### Step 2: Enter Package Name

When prompted, enter your package name (or press Enter for default):

```
📦 Enter the package name for your project (e.g., com.i2c.automation.icm):
com.mycompany.tests

✅ Package set to: com.mycompany.tests
📁 Source path: src\test\java\com\mycompany\tests\myfirsttest
```

### Step 3: Wait for Creation

```
🚀 Creating Gradle project 'MyFirstTest'...
🧩 Checking Java 11 environment...
✅ Java found: openjdk version "11.0.x"
🛠  Setting up Gradle wrapper version 6.7...
🧩 Creating IntelliJ IDEA configuration...

✅ Project 'MyFirstTest' created successfully!
📁 Location: C:\Users\YourName\MyFirstTest
📦 Package: com.mycompany.tests.myfirsttest
```

## Build and Test (1 minute)

```powershell
cd MyFirstTest
.\gradlew.bat build
```

## Open in IntelliJ IDEA (30 seconds)

1. Launch IntelliJ IDEA
2. Click **Open**
3. Select your `MyFirstTest` folder
4. Click **OK**

Done! Your project is ready. ✅

## What You Get

Your project includes:

### ✅ Test Framework

- JUnit 5 for running tests
- Selenium WebDriver for browser automation
- Allure for beautiful test reports

### ✅ Project Structure

```
MyFirstTest/
├── src/test/java/com/mycompany/tests/myfirsttest/
│   ├── MyFirstTest.java           ← Your main test class
│   ├── MyFirstTestDataSource.java ← Test data model
│   ├── MyFirstTestScreen.java     ← Page object
│   └── Navigation.java            ← Navigation helper
├── datasource/
│   └── MyFirstTest_DataSource.csv ← Test data
└── build.gradle                   ← Dependencies
```

### ✅ Ready to Use Code

The main test class is already set up:

```java
@DisplayName("MyFirstTest")
@ParameterizedTest
@MethodSource("provideParameters")
void execute(MyFirstTestDataSource data) {
    try {
        // Add your test logic here
    } catch (Exception e) {
        Assert.fail("Test failed: " + e.getMessage());
    }
}
```

## Next Steps

### 1. Add Test Data

Edit `datasource\MyFirstTest_DataSource.csv`:

```csv
TC_ID,Scenario_Description,Application_URL
TC_001,Test Login Page,https://example.com
TC_002,Test Dashboard,https://example.com/dashboard
```

### 2. Implement Page Objects

Edit `MyFirstTestScreen.java`:

```java
public void login(WebDriver driver, String username, String password) {
    driver.findElement(By.id("username")).sendKeys(username);
    driver.findElement(By.id("password")).sendKeys(password);
    driver.findElement(By.id("login-btn")).click();
}
```

### 3. Write Test Logic

Edit `MyFirstTest.java`:

```java
void execute(MyFirstTestDataSource data) {
    try {
        driver.get(data.Application_URL);
        MyFirstTestScreen.getInstance().login(driver, "user", "pass");
        // Add assertions
    } catch (Exception e) {
        Assert.fail("Test failed: " + e.getMessage());
    }
}
```

### 4. Run Tests

```powershell
.\gradlew.bat test
.\gradlew.bat allureReport
```

## Common Commands

```powershell
# Create new project
ali-automation create-project ProjectName

# Show version
ali-automation version

# Show help
ali-automation help

# Build project
.\gradlew.bat build

# Run tests
.\gradlew.bat test

# Clean build
.\gradlew.bat clean build

# Generate report
.\gradlew.bat allureReport
```

## Tips for Success

### 💡 Use Descriptive Names

```powershell
# Good
ali-automation create-project LoginTests
ali-automation create-project PaymentFlow
ali-automation create-project UserRegistration

# Avoid
ali-automation create-project test
ali-automation create-project proj1
```

### 💡 Follow Java Package Conventions

```
✅ com.company.project.module
✅ com.example.automation.tests
❌ Company.Project
❌ test.automation
```

### 💡 Keep Test Data Organized

```csv
TC_ID,Scenario_Description,Application_URL
TC_LOGIN_001,Valid credentials,https://app.com
TC_LOGIN_002,Invalid credentials,https://app.com
TC_LOGIN_003,Empty fields,https://app.com
```

### 💡 Use Page Object Pattern

```java
// Don't do this in test:
driver.findElement(By.id("username")).sendKeys("user");

// Do this:
loginScreen.enterUsername("user");
```

## Troubleshooting Quick Fixes

### ❌ "java is not recognized"

```powershell
scoop install openjdk11
```

### ❌ "gradlew.bat not found"

```powershell
cd MyFirstTest  # Make sure you're in project directory
.\gradlew.bat build
```

### ❌ "IntelliJ can't find SDK"

1. File → Project Structure → Project
2. Select Java 11 from dropdown
3. Click Apply

### ❌ "ChromeDriver error"

- Update Chrome browser
- Selenium 4.6.0+ downloads drivers automatically

## Get Help

- 📖 [Full README](README.md)
- 📚 [Installation Guide](INSTALLATION.md)
- 🧪 [Testing Guide](TESTING.md)
- 📦 [GitHub Issues](https://github.com/alirazabrame/scoop-ali-automation/issues)

## Example Projects

### Simple Login Test

```powershell
ali-automation create-project LoginTest
cd LoginTest
# Edit datasource\LoginTest_DataSource.csv
# Edit LoginTestScreen.java
.\gradlew.bat test
```

### E-commerce Flow

```powershell
ali-automation create-project EcommerceTest
cd EcommerceTest
# Add multiple screen classes
# Implement shopping cart logic
.\gradlew.bat test allureReport
```

### API + UI Test

```powershell
ali-automation create-project HybridTest
cd HybridTest
# Add REST Assured dependency to build.gradle
# Implement API and UI tests
.\gradlew.bat test
```

## Video Tutorials (Coming Soon)

- [ ] Installation and Setup
- [ ] Creating Your First Test
- [ ] Working with Page Objects
- [ ] Data-Driven Testing
- [ ] Generating Reports

## Learning Path

1. **Day 1**: Install and create first project ✅
2. **Day 2**: Understand project structure
3. **Day 3**: Write your first test
4. **Day 4**: Add page objects
5. **Day 5**: Implement data-driven tests
6. **Week 2**: Master Allure reports
7. **Week 3**: Advanced patterns and best practices

---

**Ready to automate? Let's go!** 🚀

```powershell
ali-automation create-project MyAwesomeTest
```
