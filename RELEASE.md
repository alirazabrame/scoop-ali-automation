# Release Guide for ALI Automation Scoop Package

## Prerequisites

- GitHub account with access to the repository
- Git installed and configured
- All changes committed to the repository

## Creating a New Release

### 1. Update Version Number

Edit `bucket/ali-automation.json` and update the version:

```json
{
  "version": "1.0.3",
  ...
}
```

### 2. Commit All Changes

```bash
git add .
git commit -m "Release v1.0.3 - Windows PowerShell implementation"
git push origin main
```

### 3. Create a Git Tag

```bash
# Create and push tag
git tag -a v1.0.3 -m "Version 1.0.3 - Windows PowerShell implementation"
git push origin v1.0.3
```

### 4. Create GitHub Release

1. Go to your repository on GitHub
2. Click on **Releases** (right sidebar)
3. Click **Create a new release**
4. Select the tag you just created (`v1.0.3`)
5. Add release title: `ALI Automation v1.0.3`
6. Add release notes (see template below)
7. Click **Publish release**

### Release Notes Template

````markdown
## ALI Automation v1.0.3

### 🎉 What's New

- Complete Windows PowerShell implementation
- Batch file wrapper for easy command execution
- Full feature parity with macOS/Homebrew version
- Enhanced error handling and user feedback

### ✨ Features

- Create IntelliJ-ready Gradle projects
- Java 11 + Selenium WebDriver 4.6.0
- JUnit 5 with parameterized tests
- Allure reporting integration
- CSV-driven test data
- Pre-configured IntelliJ IDEA modules

### 📦 Installation

```powershell
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation
scoop install ali-automation
```
````

### 🚀 Usage

```powershell
ali-automation create-project MyTestProject
```

### 📋 Requirements

- Windows 10 or later
- Java 11 JDK (install via: `scoop install openjdk11`)
- Gradle (install via: `scoop install gradle`)

### 📖 Documentation

- [README](https://github.com/alirazabrame/scoop-ali-automation/blob/main/README.md)
- [Installation Guide](https://github.com/alirazabrame/scoop-ali-automation/blob/main/INSTALLATION.md)

### 🐛 Bug Fixes

- Fixed path handling for Windows
- Improved package name validation
- Better error messages

### 🙏 Contributors

Thanks to all contributors who made this release possible!

````

### 5. Calculate SHA256 Hash

After creating the release, download the source code archive and calculate its hash:

**Option 1: Using PowerShell**
```powershell
# Download the release archive
$url = "https://github.com/alirazabrame/scoop-ali-automation/archive/v1.0.3.zip"
Invoke-WebRequest -Uri $url -OutFile "ali-automation-v1.0.3.zip"

# Calculate SHA256
Get-FileHash "ali-automation-v1.0.3.zip" -Algorithm SHA256 | Select-Object Hash
````

**Option 2: Using Scoop's checkver tool**

```powershell
scoop checkver -u ali-automation
```

### 6. Update Hash in Manifest

Edit `bucket/ali-automation.json` and add the hash:

```json
{
  "version": "1.0.3",
  "url": "https://github.com/alirazabrame/scoop-ali-automation/archive/v1.0.3.zip",
  "hash": "sha256:YOUR_CALCULATED_HASH_HERE",
  ...
}
```

### 7. Commit Hash Update

```bash
git add bucket/ali-automation.json
git commit -m "Update hash for v1.0.3"
git push origin main
```

## Testing the Release

### Test Installation

```powershell
# Remove existing installation
scoop uninstall ali-automation

# Update bucket
scoop update

# Reinstall from bucket
scoop install ali-automation

# Verify version
ali-automation version

# Test functionality
ali-automation create-project TestProject
```

### Test Project Creation

```powershell
cd TestProject
.\gradlew.bat build
```

## Automated Updates (Future)

The manifest includes `autoupdate` configuration:

```json
"autoupdate": {
  "url": "https://github.com/alirazabrame/scoop-ali-automation/archive/v$version.zip",
  "extract_dir": "scoop-ali-automation-$version"
}
```

This allows Scoop to automatically update the package when new releases are created.

## Version Numbering

Follow semantic versioning (SemVer):

- **MAJOR** (1.x.x): Incompatible API changes
- **MINOR** (x.1.x): New features, backward compatible
- **PATCH** (x.x.1): Bug fixes, backward compatible

Examples:

- `1.0.0` → `1.0.1`: Bug fix
- `1.0.1` → `1.1.0`: New feature
- `1.1.0` → `2.0.0`: Breaking change

## Troubleshooting

### Issue: Hash mismatch error

**Solution:** Recalculate the hash and update the manifest.

### Issue: Scoop can't find the bucket

**Solution:** Ensure the repository is public and the bucket name is correct.

### Issue: Extract directory error

**Solution:** Verify that `extract_dir` matches the GitHub archive structure.

## Checklist

Before releasing:

- [ ] All changes committed and pushed
- [ ] Version number updated in manifest
- [ ] Git tag created and pushed
- [ ] GitHub release created with notes
- [ ] SHA256 hash calculated and added to manifest
- [ ] Hash update committed and pushed
- [ ] Installation tested from bucket
- [ ] Project creation tested
- [ ] Documentation updated

## Quick Release Command Sequence

```bash
# 1. Update version in bucket/ali-automation.json first

# 2. Commit and tag
git add .
git commit -m "Release v1.0.3"
git push origin main
git tag -a v1.0.3 -m "Version 1.0.3"
git push origin v1.0.3

# 3. Create GitHub release via web interface

# 4. Calculate hash
$hash = (Invoke-WebRequest "https://github.com/alirazabrame/scoop-ali-automation/archive/v1.0.3.zip" -OutFile "temp.zip") ; (Get-FileHash "temp.zip" -Algorithm SHA256).Hash

# 5. Update hash in manifest, commit, and push
git add bucket/ali-automation.json
git commit -m "Update hash for v1.0.3"
git push origin main
```

---

## Future Enhancements

Consider for future releases:

1. **CI/CD Integration**: Automate hash calculation and manifest updates
2. **Multiple Architectures**: Support for different Windows versions
3. **Pre/Post Install Scripts**: Custom setup actions
4. **App Shortcuts**: Desktop/Start Menu shortcuts
5. **Persist Config**: Save user preferences between updates

---

Happy Releasing! 🚀
