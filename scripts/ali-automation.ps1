# ALI Automation - Project Creator (IntelliJ + Java 11)
# PowerShell version for Windows

# Main script parameters
param(
    [Parameter(Position=0)]
    [string]$Command,
    
    [Parameter(Position=1)]
    [string]$ProjectName
)

$VERSION = "1.0.2"

function Show-Help {
    Write-Host @"
ALI Automation v$VERSION

Usage: ali-automation create-project <PROJECT_NAME>

Commands:
    create-project <name>    Create a new IntelliJ-ready Gradle project
    version                  Show version information
    help                     Show this help message

Examples:
    ali-automation create-project MyTestProject
    ali-automation version
    ali-automation help
"@
}

function Get-PackagePath {
    param([string]$ProjectName)
    
    Write-Host "Enter the package name for your project (e.g., com.i2c.automation.icm):" -ForegroundColor Cyan
    $userPackage = Read-Host
    
    if ([string]::IsNullOrWhiteSpace($userPackage)) {
        Write-Host "No package provided. Using default: com.i2c.automation.aliapp" -ForegroundColor Yellow
        $userPackage = "com.i2c.automation.aliapp"
    }
    
    $script:PACKAGE_PATH = $userPackage -replace '\.','\\'
    $script:PACKAGE_NAME = $userPackage
    
    Write-Host "Package set to: $PACKAGE_NAME" -ForegroundColor Green
    Write-Host "Source path: src\test\java\$PACKAGE_PATH\$ProjectName" -ForegroundColor Cyan
}

function Create-GradleProject {
    param([string]$ProjectName)
    
    $GRADLE_VERSION = "6.7"
    $WORK_DIR = Get-Location
    
    if ([string]::IsNullOrWhiteSpace($ProjectName)) {
        Write-Host "[ERROR] Usage: ali-automation create-project <ProjectName>" -ForegroundColor Red
        exit 1
    }
    
    Get-PackagePath -ProjectName $ProjectName
    
    $ROOT_DIR = Join-Path $WORK_DIR $ProjectName
    # Convert to camelCase: remove spaces and make first letter lowercase
    $PROJECT_NAME_LOWER = $ProjectName -replace '\s','' 
    $PROJECT_NAME_LOWER = $PROJECT_NAME_LOWER.Substring(0,1).ToLower() + $PROJECT_NAME_LOWER.Substring(1)
    $SRC_MAIN_DIR = Join-Path $ROOT_DIR "src\main\java\$PACKAGE_PATH"
    $SRC_TEST_DIR = Join-Path $ROOT_DIR "src\test\java\$PACKAGE_PATH\$PROJECT_NAME_LOWER"
    
    # Create directory structure
    New-Item -ItemType Directory -Force -Path $SRC_MAIN_DIR | Out-Null
    New-Item -ItemType Directory -Force -Path $SRC_TEST_DIR | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $ROOT_DIR "src\main\resources") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $ROOT_DIR "src\test\resources") | Out-Null
    
    # Get system user info
    try {
        $SYSTEM_USER_NAME = git config user.name 2>$null
        if ([string]::IsNullOrWhiteSpace($SYSTEM_USER_NAME)) {
            $SYSTEM_USER_NAME = $env:USERNAME
        }
    } catch {
        $SYSTEM_USER_NAME = $env:USERNAME
    }
    
    try {
        $SYSTEM_USER_EMAIL = git config user.email 2>$null
        if ([string]::IsNullOrWhiteSpace($SYSTEM_USER_EMAIL)) {
            $SYSTEM_USER_EMAIL = "eng.st14@i2cinc.com"
        }
    } catch {
        $SYSTEM_USER_EMAIL = "eng.st14@i2cinc.com"
    }
    
    $GENERATED_DATE = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    Write-Host "[INFO] Creating Gradle project '$ProjectName'..." -ForegroundColor Green
    
    # Create build.gradle
    $BUILD_GRADLE_CONTENT = @"
plugins {
    id 'java'
    id 'maven'
    id 'io.qameta.allure' version '2.8.1'
}

group 'SampleProject.generated'
version '1.0'

sourceCompatibility = 11
targetCompatibility = 11

test {
    useJUnitPlatform()
}

repositories {
    mavenCentral()
    maven { url "https://oss.sonatype.org/content/repositories/snapshots/" }
}

jar {
    from sourceSets.test.output + sourceSets.test.allSource
    from { configurations.testRuntimeClasspath.collect { it.isDirectory() ? it : zipTree(it) } }
}

compileTestJava.options.compilerArgs.add '-parameters'

def allureVersion = "2.13.6"
def junit5Version = "5.6.2"
allure {
    autoconfigure = true
    aspectjweaver = true
    version = allureVersion
    clean = true
    useJUnit5 { version = allureVersion }
}
dependencies {
    testImplementation("io.qameta.allure:allure-java-commons:`$allureVersion")
    testImplementation("org.junit.jupiter:junit-jupiter-api:`$junit5Version")
    testImplementation("org.junit.jupiter:junit-jupiter-engine:`$junit5Version")
    testImplementation("org.junit.jupiter:junit-jupiter-params:`$junit5Version")
    implementation group: 'commons-io', name: 'commons-io', version: '2.11.0'
    implementation group: 'com.ibm.informix', name: 'jdbc', version: '4.50.9'
    implementation group: 'org.json', name: 'json', version: '20220924'
    implementation group: 'org.apache.commons', name: 'commons-csv', version: '1.9.0'
    implementation group: 'org.seleniumhq.selenium', name: 'selenium-java', version: '4.6.0'
    implementation fileTree(dir: 'D:/i2c_Repos/Automation-ICM/Automation Migration/Utilities-JAR')
}
"@
    
    Set-Content -Path (Join-Path $ROOT_DIR "build.gradle") -Value $BUILD_GRADLE_CONTENT
    Set-Content -Path (Join-Path $ROOT_DIR "settings.gradle") -Value "rootProject.name = '$ProjectName'"
    
    # Function to create Java files with header
    function Create-JavaFile {
        param(
            [string]$FilePath,
            [string]$Content
        )
        
        $header = @"
/**
 * This class was automatically generated by TestProject
 * Project: $ProjectName
 * Generated by: $SYSTEM_USER_NAME ($SYSTEM_USER_EMAIL)
 * Generated on $GENERATED_DATE.
 */
package $PACKAGE_NAME.$PROJECT_NAME_LOWER;

$Content
"@
        Set-Content -Path $FilePath -Value $header
    }
    
    # Create main test class
    $mainClassContent = @"
import org.testng.Assert;
import com.i2c.addons.Informix.SendQuery;
import io.qameta.allure.Allure;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.MethodSource;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.FileReader;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

public class $ProjectName {
    public static WebDriver driver;

    @BeforeAll
    static void setup() throws Exception {
        System.setProperty("webdriver.chrome.driver", "/Users/araza08/Data/Libraries/chromedriver-mac-x64/chromedriver");
        ChromeOptions chromeOptions = new ChromeOptions();
        chromeOptions.addArguments("--remote-allow-origins=*", "ignore-certificate-errors");
        driver = new ChromeDriver(chromeOptions);
        driver.manage().timeouts().implicitlyWait(Duration.ofMillis(15000));
        driver.manage().window().maximize();
    }

    private static Object[][] provideParameters() throws Exception {
        List<${ProjectName}DataSource> csvList = new ArrayList<>();
        try (
            BufferedReader br = new BufferedReader(new FileReader("datasource/${ProjectName}_DataSource.csv"));
            CSVParser parser = CSVFormat.DEFAULT.withDelimiter(',').withHeader().parse(br);
        ) {
            for (CSVRecord record : parser) {
                ${ProjectName}DataSource csvObject = new ${ProjectName}DataSource();
                csvObject.TID = record.get("TC_ID");
                csvObject.Scenario_Description = record.get("Scenario_Description");
                csvObject.Application_URL = record.get("Application_URL");
                csvList.add(csvObject);
            }
            return csvList.stream()
                    .map(bean -> new Object[]{bean})
                    .toArray(Object[][]::new);
        }
    }

    @DisplayName("$ProjectName")
    @ParameterizedTest
    @MethodSource("provideParameters")
    void execute(${ProjectName}DataSource data) {
        try {
            // main logic
        } catch (Exception e) {
            data.Actual_Result = "Fail";
            Assert.fail("Fail: " + e.getMessage(), e);
        }
    }

    @AfterEach
    public void takeScreenShot() {
        Allure.attachment("Test End: ", new ByteArrayInputStream(((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES)));
    }

    @AfterAll
    static void tearDown() {
        if (driver != null) {
            driver.quit();
        }
        // executeCleanUp();
    }
    
    static void executeCleanUp() {
        SendQuery.executeICMCleanUpFile("cleanup/${PROJECT_NAME}_CleanUp.sql");
    }
}
"@
    
    Create-JavaFile -FilePath (Join-Path $SRC_TEST_DIR "${ProjectName}.java") -Content $mainClassContent
    
    # Create DataSource class
    $dataSourceContent = @"
public class ${ProjectName}DataSource {

    String TID;
    String Scenario_Description;
    String Module_Name;
    String Application_URL;
    String Verify_Login;
    String LoggedIn_UserID;
    String LoggedIn_UserPassword;
    String OLD_Password;
    String New_Password;
    String Confirm_NewPassword;
    String Expected_Result;
    String Actual_Result;
    String Test_Result;

    @Override
    public String toString() {
        return "[" + TID + ',' + Module_Name + ',' + Scenario_Description + ']';
    }
}
"@
    
    Create-JavaFile -FilePath (Join-Path $SRC_TEST_DIR "${ProjectName}DataSource.java") -Content $dataSourceContent
    
    # Create Screen class
    $screenContent = @"
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class ${ProjectName}Screen {
    String oldPasswordFieldId = "old-password";
    String newPasswordFieldId = "new-password";
    String confirmNewPasswordFieldId = "confirm-password";
    String submitButtonId = "continueButton";

    private ${ProjectName}Screen() {}

    private static ${ProjectName}Screen instance = null;

    public static ${ProjectName}Screen getInstance() {
        if (instance == null) {
            instance = new ${ProjectName}Screen();
        }
        return instance;
    }

    public void execute(WebDriver driver, ${ProjectName}DataSource data) {
       driver.findElement(By.id(oldPasswordFieldId)).sendKeys(data.OLD_Password);
       driver.findElement(By.id(newPasswordFieldId)).sendKeys(data.New_Password);
       driver.findElement(By.id(confirmNewPasswordFieldId)).sendKeys(data.Confirm_NewPassword);
       driver.findElement(By.id(submitButtonId)).click();
    }
}
"@
    
    Create-JavaFile -FilePath (Join-Path $SRC_TEST_DIR "${ProjectName}Screen.java") -Content $screenContent
    
    # Create Navigation class
    $navigationContent = @"
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;

public class Navigation {
    private static String User_Info_Button_Id = "user-info-drop";
    public static void selectUserInfoButton(WebDriver driver) throws Exception {
        By by = By.id(User_Info_Button_Id);
        driver.findElement(by).click();
        Thread.sleep(2000);
    }
}
"@
    
    Create-JavaFile -FilePath (Join-Path $SRC_TEST_DIR "Navigation.java") -Content $navigationContent
    
    # Create supporting folders and files
    New-Item -ItemType Directory -Force -Path (Join-Path $ROOT_DIR "cleanup") | Out-Null
    New-Item -ItemType Directory -Force -Path (Join-Path $ROOT_DIR "datasource") | Out-Null
    
    Set-Content -Path (Join-Path $ROOT_DIR "cleanup\${ProjectName}_CleanUp.sql") -Value "-- SQL cleanup script for $ProjectName"
    Set-Content -Path (Join-Path $ROOT_DIR "datasource\${ProjectName}_DataSource.csv") -Value "TC_ID,Scenario_Description,Application_URL"
    
    # Verify Java 11 is available
    Write-Host "[INFO] Checking Java 11 environment..." -ForegroundColor Cyan
    try {
        $javaVersion = java -version 2>&1 | Select-String "version" | Select-Object -First 1
        Write-Host "[OK] Java found: $javaVersion" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Java not found. Please install Java 11 JDK:" -ForegroundColor Red
        Write-Host "   scoop install openjdk11" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "After installing Java, run the command again." -ForegroundColor Yellow
        exit 1
    }
    
    # Verify Gradle is available
    Write-Host "[INFO] Checking Gradle installation..." -ForegroundColor Cyan
    try {
        $gradleCheck = Get-Command gradle -ErrorAction Stop
        $gradleVersion = gradle --version 2>&1 | Select-String "Gradle" | Select-Object -First 1
        Write-Host "[OK] Gradle found: $gradleVersion" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Gradle not found. Gradle is required to set up the project wrapper." -ForegroundColor Red
        Write-Host "   scoop install gradle" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "After installing Gradle, run the command again." -ForegroundColor Yellow
        exit 1
    }
    
    # Create Gradle wrapper
    Write-Host "[INFO] Setting up Gradle wrapper version $GRADLE_VERSION..." -ForegroundColor Cyan
    
    Push-Location $ROOT_DIR
    
    # Create gradle/wrapper directory
    New-Item -ItemType Directory -Force -Path "gradle\wrapper" | Out-Null
    
    # Create gradle-wrapper.properties
    $gradleWrapperProps = @"
distributionUrl=https\://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
"@
    Set-Content -Path "gradle\wrapper\gradle-wrapper.properties" -Value $gradleWrapperProps
    
    # Initialize Gradle wrapper using gradle command
    Write-Host "[INFO] Initializing Gradle wrapper..." -ForegroundColor Cyan
    gradle wrapper --gradle-version $GRADLE_VERSION 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Gradle wrapper initialized successfully" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Gradle wrapper initialization had issues, but project structure is ready" -ForegroundColor Yellow
    }
    
    Pop-Location
    
    # Create IntelliJ IDEA configuration
    Write-Host "[INFO] Creating IntelliJ IDEA configuration..." -ForegroundColor Cyan
    
    New-Item -ItemType Directory -Force -Path (Join-Path $ROOT_DIR ".idea") | Out-Null
    
    # Create modules.xml
    $modulesXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="ProjectModuleManager">
    <modules>
      <module fileurl="file://`$PROJECT_DIR`$/$ProjectName.iml" filepath="`$PROJECT_DIR`$/$ProjectName.iml" />
    </modules>
  </component>
</project>
"@
    $ideaModulesPath = Join-Path $ROOT_DIR ".idea"
    $ideaModulesPath = Join-Path $ideaModulesPath "modules.xml"
    Set-Content -Path $ideaModulesPath -Value $modulesXml
    
    # Create misc.xml
    $miscXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="ProjectRootManager" version="2" languageLevel="JDK_11" default="true" project-jdk-name="11" project-jdk-type="JavaSDK">
    <output url="file://`$PROJECT_DIR`$/out" />
  </component>
</project>
"@
    $ideaMiscPath = Join-Path $ROOT_DIR ".idea"
    $ideaMiscPath = Join-Path $ideaMiscPath "misc.xml"
    Set-Content -Path $ideaMiscPath -Value $miscXml
    
    # Create vcs.xml
    $vcsXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="VcsDirectoryMappings">
    <mapping directory="" vcs="Git" />
  </component>
</project>
"@
    $ideaVcsPath = Join-Path $ROOT_DIR ".idea"
    $ideaVcsPath = Join-Path $ideaVcsPath "vcs.xml"
    Set-Content -Path $ideaVcsPath -Value $vcsXml
    
    # Create compiler.xml
    $compilerXml = @"
<?xml version="1.0" encoding="UTF-8"?>
<project version="4">
  <component name="CompilerConfiguration">
    <bytecodeTargetLevel target="11" />
  </component>
</project>
"@
    $ideaCompilerPath = Join-Path $ROOT_DIR ".idea"
    $ideaCompilerPath = Join-Path $ideaCompilerPath "compiler.xml"
    Set-Content -Path $ideaCompilerPath -Value $compilerXml
    
    # Create .iml file
    $imlContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<module type="JAVA_MODULE" version="4">
  <component name="NewModuleRootManager" inherit-compiler-output="true">
    <exclude-output />
    <content url="file://`$MODULE_DIR`$">
      <sourceFolder url="file://`$MODULE_DIR`$/src/main/java" isTestSource="false" />
      <sourceFolder url="file://`$MODULE_DIR`$/src/main/resources" type="java-resource" />
      <sourceFolder url="file://`$MODULE_DIR`$/src/test/java" isTestSource="true" />
      <sourceFolder url="file://`$MODULE_DIR`$/src/test/resources" type="java-test-resource" />
      <excludeFolder url="file://`$MODULE_DIR`$/.gradle" />
      <excludeFolder url="file://`$MODULE_DIR`$/build" />
    </content>
    <orderEntry type="inheritedJdk" />
    <orderEntry type="sourceFolder" forTests="false" />
  </component>
</module>
"@
    Set-Content -Path (Join-Path $ROOT_DIR "${ProjectName}.iml") -Value $imlContent
    
    Write-Host ""
    Write-Host "[SUCCESS] Project '$ProjectName' created successfully!" -ForegroundColor Green
    Write-Host "Location: $ROOT_DIR" -ForegroundColor Cyan
    Write-Host "Package: $PACKAGE_NAME.$PROJECT_NAME_LOWER" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. cd $ProjectName" -ForegroundColor White
    Write-Host "  2. .\gradlew.bat build" -ForegroundColor White
    Write-Host "  3. Open the folder in IntelliJ IDEA" -ForegroundColor White
}

# Main script logic
switch ($Command) {
    "create-project" {
        if ([string]::IsNullOrWhiteSpace($ProjectName)) {
            Write-Host "[ERROR] Project name is required" -ForegroundColor Red
            Write-Host "Usage: ali-automation create-project <ProjectName>" -ForegroundColor Yellow
            exit 1
        }
        Create-GradleProject -ProjectName $ProjectName
    }
    "version" {
        Write-Host "ALI Automation v$VERSION"
    }
    { $_ -in "help", "--help", "-h" } {
        Show-Help
    }
    default {
        Show-Help
    }
}
