# Testing Guide - Before Publishing

## Pre-Release Testing Checklist

Before publishing to GitHub and making available via Scoop, perform these tests:

### 1. Local Script Testing

#### Test PowerShell Script Directly

```powershell
# Navigate to scripts directory
cd /Users/araza08/Data/GitHub/scoop-ali-automation/scripts

# Test help command
powershell -ExecutionPolicy Bypass -File .\ali-automation.ps1 help

# Test version command
powershell -ExecutionPolicy Bypass -File .\ali-automation.ps1 version

# Test project creation
powershell -ExecutionPolicy Bypass -File .\ali-automation.ps1 create-project TestProject1
```

#### Test Batch Wrapper

```powershell
# Navigate to scripts directory
cd /Users/araza08/Data/GitHub/scoop-ali-automation/scripts

# Test help
.\ali-automation.bat help

# Test version
.\ali-automation.bat version

# Test project creation
.\ali-automation.bat create-project TestProject2
```

### 2. Verify Generated Project Structure

```powershell
# Check if project was created
cd TestProject1

# Verify directory structure
tree /F

# Expected structure:
# TestProject1/
# ├── .idea/
# ├── src/test/java/.../testproject1/
# ├── datasource/
# ├── cleanup/
# ├── build.gradle
# ├── settings.gradle
# └── TestProject1.iml
```

### 3. Test Gradle Build

```powershell
# In the generated project directory
cd TestProject1

# Test Gradle wrapper
.\gradlew.bat --version

# Build project
.\gradlew.bat build

# Expected: BUILD SUCCESSFUL
```

### 4. Test IntelliJ Integration

1. Open IntelliJ IDEA
2. Open the generated project folder
3. Verify:
   - [ ] Project loads without errors
   - [ ] Java 11 SDK is recognized
   - [ ] Source folders are marked correctly
   - [ ] Dependencies are resolved
   - [ ] No compilation errors

### 5. Verify File Contents

#### Check Java Files

```powershell
# Check main test class
type TestProject1\src\test\java\com\i2c\automation\aliapp\testproject1\TestProject1.java

# Verify:
# - Package declaration is correct
# - Imports are present
# - Class structure is valid
# - WebDriver setup exists
```

#### Check Configuration Files

```powershell
# Check build.gradle
type TestProject1\build.gradle

# Check IntelliJ module file
type TestProject1\TestProject1.iml

# Check CSV file
type TestProject1\datasource\TestProject1_DataSource.csv
```

### 6. Test Different Package Names

```powershell
# Test with custom package
.\ali-automation.bat create-project CustomPackageTest
# Enter: com.example.test.automation

# Test with default package (press Enter)
.\ali-automation.bat create-project DefaultPackageTest

# Verify both projects build successfully
```

### 7. Test Error Handling

```powershell
# Test without project name
.\ali-automation.bat create-project
# Expected: Error message

# Test with invalid command
.\ali-automation.bat invalid-command
# Expected: Show help

# Test with spaces in name
.\ali-automation.bat create-project "Project With Spaces"
# Should handle or show appropriate error
```

## Scoop Local Testing

### 1. Create Local Bucket for Testing

```powershell
# Create test directory
mkdir C:\scoop-test
cd C:\scoop-test

# Copy your bucket files
xcopy /E /I "C:\Users\araza08\Data\GitHub\scoop-ali-automation" "C:\scoop-test\scoop-ali-automation"

# Add local bucket
scoop bucket add ali-automation-test "C:\scoop-test\scoop-ali-automation"
```

### 2. Test Installation from Local Bucket

```powershell
# Install from local bucket
scoop install ali-automation-test/ali-automation

# Verify installation
scoop list

# Test commands
ali-automation version
ali-automation help
```

### 3. Test Project Creation After Installation

```powershell
# Create test project
mkdir C:\temp-test
cd C:\temp-test

ali-automation create-project ScoopInstalledTest

# Verify project
cd ScoopInstalledTest
.\gradlew.bat build
```

### 4. Test Update Mechanism

```powershell
# Update manifest version locally
# Edit bucket/ali-automation.json, change version to 1.0.4

# Update Scoop
scoop update

# Check if update is detected
scoop status

# Update package
scoop update ali-automation
```

### 5. Test Uninstallation

```powershell
# Uninstall
scoop uninstall ali-automation

# Verify removal
ali-automation version
# Expected: Command not found

# Verify shim removed
Get-Command ali-automation
# Expected: Error
```

## Edge Case Testing

### Test with Long Project Names

```powershell
ali-automation create-project VeryLongProjectNameForTestingPurposes
```

### Test with Special Characters (should fail gracefully)

```powershell
ali-automation create-project Project@Name
ali-automation create-project Project-Name-123
```

### Test Concurrent Execution

```powershell
# Open two PowerShell windows
# Run in Window 1:
ali-automation create-project Concurrent1

# Run in Window 2 simultaneously:
ali-automation create-project Concurrent2
```

### Test with Insufficient Permissions

```powershell
# Try creating project in protected directory
cd C:\Program Files
ali-automation create-project TestPermissions
# Expected: Appropriate error message
```

## Performance Testing

### Measure Creation Time

```powershell
Measure-Command {
    ali-automation create-project PerformanceTest
}

# Acceptable: < 30 seconds
```

### Check Resource Usage

```powershell
# Monitor during execution
Get-Process -Name powershell | Select-Object CPU, PM

# Should not consume excessive memory or CPU
```

## Validation Checklist

Before publishing, ensure:

### Script Functionality

- [ ] Help command displays correctly
- [ ] Version command shows correct version
- [ ] Project creation completes without errors
- [ ] All directories are created
- [ ] All files have correct content
- [ ] Package names are handled correctly

### Generated Project

- [ ] Builds successfully with Gradle
- [ ] Opens correctly in IntelliJ IDEA
- [ ] All Java files compile
- [ ] Dependencies are resolved
- [ ] IntelliJ configuration is valid
- [ ] CSV file is created with headers

### Scoop Integration

- [ ] Manifest JSON is valid
- [ ] URL points to correct repository
- [ ] Extract directory matches archive structure
- [ ] Bin shim is created correctly
- [ ] Commands are accessible globally
- [ ] Suggests are appropriate
- [ ] Notes display on installation

### Documentation

- [ ] README is complete and accurate
- [ ] Installation guide is clear
- [ ] Examples work as documented
- [ ] Prerequisites are listed
- [ ] Troubleshooting covers common issues

### Error Handling

- [ ] Missing project name shows error
- [ ] Invalid commands show help
- [ ] Permission errors are handled
- [ ] Java/Gradle not found warnings work
- [ ] Graceful failures with clear messages

## Common Issues to Check

### 1. Path Issues

```powershell
# Test with spaces in path
cd "C:\Users\Test User\Documents"
ali-automation create-project PathTest
```

### 2. Line Ending Issues

```bash
# On Windows, verify CRLF line endings
file scripts/ali-automation.ps1
# Should show: CRLF line terminators
```

### 3. Encoding Issues

```powershell
# Check file encoding
Get-Content scripts/ali-automation.ps1 -Encoding UTF8
```

### 4. PowerShell Version Compatibility

```powershell
# Test with different PowerShell versions
$PSVersionTable.PSVersion

# Test with PowerShell 5.1 (Windows default)
# Test with PowerShell 7+ if available
```

## Automated Testing Script

Save this as `test-ali-automation.ps1`:

```powershell
# Automated testing script
Write-Host "=== ALI Automation Test Suite ===" -ForegroundColor Cyan

$testDir = "C:\temp\ali-automation-tests"
$testsPassed = 0
$testsFailed = 0

# Clean test directory
if (Test-Path $testDir) {
    Remove-Item $testDir -Recurse -Force
}
New-Item -ItemType Directory -Path $testDir | Out-Null
Set-Location $testDir

# Test 1: Version command
Write-Host "`nTest 1: Version command" -ForegroundColor Yellow
try {
    $version = ali-automation version
    if ($version -match "ALI Automation v\d+\.\d+\.\d+") {
        Write-Host "✅ PASS" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "❌ FAIL: Unexpected version format" -ForegroundColor Red
        $testsFailed++
    }
} catch {
    Write-Host "❌ FAIL: $_" -ForegroundColor Red
    $testsFailed++
}

# Test 2: Help command
Write-Host "`nTest 2: Help command" -ForegroundColor Yellow
try {
    $help = ali-automation help
    if ($help -match "Usage:") {
        Write-Host "✅ PASS" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "❌ FAIL: Help output missing" -ForegroundColor Red
        $testsFailed++
    }
} catch {
    Write-Host "❌ FAIL: $_" -ForegroundColor Red
    $testsFailed++
}

# Test 3: Project creation
Write-Host "`nTest 3: Project creation" -ForegroundColor Yellow
try {
    # Use echo to simulate Enter key (default package)
    echo "" | ali-automation create-project TestProject

    if (Test-Path "TestProject\build.gradle") {
        Write-Host "✅ PASS" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "❌ FAIL: Project not created" -ForegroundColor Red
        $testsFailed++
    }
} catch {
    Write-Host "❌ FAIL: $_" -ForegroundColor Red
    $testsFailed++
}

# Test 4: Gradle build
Write-Host "`nTest 4: Gradle build" -ForegroundColor Yellow
try {
    Set-Location TestProject
    $buildResult = .\gradlew.bat build 2>&1
    if ($buildResult -match "BUILD SUCCESSFUL") {
        Write-Host "✅ PASS" -ForegroundColor Green
        $testsPassed++
    } else {
        Write-Host "❌ FAIL: Build failed" -ForegroundColor Red
        $testsFailed++
    }
    Set-Location $testDir
} catch {
    Write-Host "❌ FAIL: $_" -ForegroundColor Red
    $testsFailed++
}

# Summary
Write-Host "`n=== Test Summary ===" -ForegroundColor Cyan
Write-Host "Passed: $testsPassed" -ForegroundColor Green
Write-Host "Failed: $testsFailed" -ForegroundColor Red
Write-Host "Total: $($testsPassed + $testsFailed)" -ForegroundColor White

if ($testsFailed -eq 0) {
    Write-Host "`n✅ All tests passed! Ready to publish." -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n❌ Some tests failed. Fix issues before publishing." -ForegroundColor Red
    exit 1
}
```

Run the automated tests:

```powershell
.\test-ali-automation.ps1
```

## Final Pre-Publish Checklist

- [ ] All manual tests pass
- [ ] Automated test script passes
- [ ] Documentation is reviewed
- [ ] Version numbers are consistent
- [ ] Git repository is clean
- [ ] No sensitive data in files
- [ ] License file is present
- [ ] README has correct repository URLs

---

Once all tests pass, proceed to [RELEASE.md](RELEASE.md) for publishing instructions.
