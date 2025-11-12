# Installation and Setup Guide

## Step-by-Step Installation

### 1. Install Scoop Package Manager

Open PowerShell and run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
```

### 2. Install Prerequisites

```powershell
# Add Java bucket
scoop bucket add java

# Install Java 11 JDK
scoop install openjdk11

# Install Gradle
scoop install gradle

# Install Git (optional but recommended)
scoop install git
```

### 3. Verify Prerequisites

```powershell
# Check Java version
java -version
# Should show: openjdk version "11.x.x"

# Check Gradle version
gradle --version
# Should show: Gradle 8.x or higher

# Check Git (if installed)
git --version
```

### 4. Install ALI Automation

```powershell
# Add the ali-automation bucket
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation

# Install ali-automation
scoop install ali-automation

# Verify installation
ali-automation version
```

## Quick Start

### Create Your First Project

```powershell
# Create a new project
ali-automation create-project MyFirstProject

# When prompted, enter package name (or press Enter for default)
# Example: com.mycompany.automation.tests

# Navigate to project
cd MyFirstProject

# Build the project
.\gradlew.bat build
```

### Open in IntelliJ IDEA

1. Launch IntelliJ IDEA
2. Click **Open** or **File → Open**
3. Navigate to your project folder (e.g., `MyFirstProject`)
4. Click **OK**
5. Wait for Gradle sync to complete

### Configure IntelliJ (First Time)

1. Go to **File → Project Structure → Project**
2. Set **SDK** to Java 11 (should be detected automatically)
3. Set **Language Level** to 11
4. Click **Apply** and **OK**

## Project Structure Explained

```
MyFirstProject/
├── .idea/                           # IntelliJ IDEA configuration
│   ├── compiler.xml
│   ├── misc.xml
│   ├── modules.xml
│   └── vcs.xml
├── gradle/                          # Gradle wrapper
│   └── wrapper/
│       └── gradle-wrapper.properties
├── src/
│   ├── main/
│   │   ├── java/                    # Main application code
│   │   └── resources/               # Main resources
│   └── test/
│       ├── java/                    # Test code
│       │   └── com/mycompany/automation/myfirstproject/
│       │       ├── MyFirstProject.java              # Main test class
│       │       ├── MyFirstProjectDataSource.java    # Data model
│       │       ├── MyFirstProjectScreen.java        # Page object
│       │       └── Navigation.java                  # Navigation helper
│       └── resources/               # Test resources
├── datasource/
│   └── MyFirstProject_DataSource.csv  # Test data
├── cleanup/
│   └── MyFirstProject_CleanUp.sql     # Database cleanup scripts
├── build.gradle                     # Gradle build configuration
├── settings.gradle                  # Gradle settings
├── gradlew.bat                      # Gradle wrapper (Windows)
└── MyFirstProject.iml               # IntelliJ module file
```

## Customizing Your Project

### 1. Update Test Data

Edit `datasource\<ProjectName>_DataSource.csv`:

```csv
TC_ID,Scenario_Description,Application_URL
TC_001,Login with valid credentials,https://example.com/login
TC_002,Login with invalid credentials,https://example.com/login
TC_003,Password reset flow,https://example.com/reset
```

### 2. Modify Page Objects

Edit `<ProjectName>Screen.java` to match your application's UI:

```java
public class MyFirstProjectScreen {
    // Update these locators for your application
    String usernameFieldId = "username";
    String passwordFieldId = "password";
    String loginButtonId = "login-btn";

    public void login(WebDriver driver, String username, String password) {
        driver.findElement(By.id(usernameFieldId)).sendKeys(username);
        driver.findElement(By.id(passwordFieldId)).sendKeys(password);
        driver.findElement(By.id(loginButtonId)).click();
    }
}
```

### 3. Add More Dependencies

Edit `build.gradle` to add libraries:

```gradle
dependencies {
    // Existing dependencies...

    // Add new dependencies here
    implementation group: 'com.google.guava', name: 'guava', version: '31.1-jre'
    testImplementation group: 'org.assertj', name: 'assertj-core', version: '3.24.2'
}
```

## Running Tests

### Command Line

```powershell
# Build the project
.\gradlew.bat build

# Run all tests
.\gradlew.bat test

# Clean and test
.\gradlew.bat clean test

# Generate Allure report
.\gradlew.bat allureReport

# Serve Allure report in browser
.\gradlew.bat allureServe
```

### IntelliJ IDEA

1. Right-click on test class or method
2. Select **Run '<TestName>'**
3. View results in the Run window

## Advanced Configuration

### Configure ChromeDriver Path (Optional)

By default, Selenium 4.6.0+ uses Selenium Manager to auto-download drivers.

To use a specific ChromeDriver:

```java
@BeforeAll
static void setup() throws Exception {
    System.setProperty("webdriver.chrome.driver", "C:\\path\\to\\chromedriver.exe");
    ChromeOptions chromeOptions = new ChromeOptions();
    chromeOptions.addArguments("--remote-allow-origins=*", "ignore-certificate-errors");
    driver = new ChromeDriver(chromeOptions);
    // ... rest of setup
}
```

### Run Tests Headless

Edit your test class:

```java
@BeforeAll
static void setup() throws Exception {
    ChromeOptions chromeOptions = new ChromeOptions();
    chromeOptions.addArguments(
        "--headless",
        "--no-sandbox",
        "--disable-dev-shm-usage",
        "--remote-allow-origins=*"
    );
    driver = new ChromeDriver(chromeOptions);
    // ... rest of setup
}
```

### Configure Test Timeouts

In `build.gradle`:

```gradle
test {
    useJUnitPlatform()
    testLogging {
        events "passed", "skipped", "failed"
    }
    // Set timeout
    timeout = Duration.ofMinutes(30)
}
```

## Troubleshooting

### Issue: "java is not recognized"

**Solution:**

```powershell
scoop install openjdk11
scoop reset openjdk11
```

### Issue: "gradlew.bat: command not found"

**Solution:**

```powershell
# Make sure you're in the project directory
cd MyFirstProject

# Run with explicit path
.\gradlew.bat build
```

### Issue: "IntelliJ doesn't recognize Java SDK"

**Solution:**

1. Go to **File → Project Structure → SDKs**
2. Click **+** → **Add JDK**
3. Navigate to Scoop Java location: `C:\Users\<YourUsername>\scoop\apps\openjdk11\current`
4. Click **OK**

### Issue: ChromeDriver compatibility

**Solution:**

- Update Chrome browser to latest version
- Selenium 4.6.0+ will auto-download compatible driver
- Or manually download from: https://chromedriver.chromium.org/

### Issue: PowerShell script execution blocked

**Solution:**

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Best Practices

### 1. Version Control

Initialize Git in your project:

```powershell
cd MyFirstProject
git init
git add .
git commit -m "Initial commit"
```

### 2. .gitignore

Create a `.gitignore` file:

```
# Gradle
.gradle/
build/
!gradle/wrapper/gradle-wrapper.jar

# IntelliJ
.idea/workspace.xml
.idea/tasks.xml
*.iws
out/

# Test results
allure-results/
test-output/

# OS
.DS_Store
Thumbs.db
```

### 3. Test Organization

- Keep one feature per test class
- Use descriptive test method names
- Group related tests using `@Nested` classes
- Use `@Tag` for categorizing tests

### 4. Page Object Pattern

- One screen/page = one class
- Encapsulate element locators
- Provide methods for user actions
- Keep tests readable and maintainable

## Next Steps

1. **Learn More**: Read the [main README](README.md)
2. **Explore Examples**: Check the generated test classes
3. **Customize**: Adapt the template to your needs
4. **Extend**: Add more test cases and page objects
5. **Share**: Contribute improvements back to the project

## Getting Help

- **Issues**: Report bugs on [GitHub Issues](https://github.com/alirazabrame/scoop-ali-automation/issues)
- **Discussions**: Ask questions in [GitHub Discussions](https://github.com/alirazabrame/scoop-ali-automation/discussions)
- **Email**: Contact the maintainer

---

Happy Testing! 🚀
