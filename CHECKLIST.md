# Pre-Release Checklist

Complete this checklist before publishing your Scoop package.

## ✅ Repository Setup

- [ ] Repository name: `scoop-ali-automation`
- [ ] Repository is public on GitHub
- [ ] All files are committed
- [ ] .gitignore is configured
- [ ] LICENSE file exists

## ✅ Core Files Created

- [ ] `scripts/ali-automation.ps1` - PowerShell script (main logic)
- [ ] `scripts/ali-automation.bat` - Batch wrapper (entry point)
- [ ] `bucket/ali-automation.json` - Scoop manifest
- [ ] `README.md` - Main documentation
- [ ] `INSTALLATION.md` - Detailed setup guide
- [ ] `QUICKSTART.md` - Quick start guide
- [ ] `TESTING.md` - Testing procedures
- [ ] `RELEASE.md` - Release workflow
- [ ] `MIGRATION.md` - Homebrew to Scoop migration notes

## ✅ Script Validation

- [ ] PowerShell script uses Windows path separators (\)
- [ ] Batch wrapper correctly calls PowerShell script
- [ ] Help command works
- [ ] Version command works
- [ ] Create-project command works
- [ ] Package name prompt works
- [ ] All Java files are generated correctly
- [ ] IntelliJ configuration files are created
- [ ] Gradle wrapper is set up
- [ ] Error handling is implemented

## ✅ Manifest Configuration

Current values in `bucket/ali-automation.json`:

```json
{
  "version": "1.0.3",
  "url": "https://github.com/alirazabrame/scoop-ali-automation/archive/v1.0.3.zip",
  "hash": "",
  "extract_dir": "scoop-ali-automation-1.0.3",
  "bin": [["scripts\\ali-automation.bat", "ali-automation"]]
}
```

Actions needed:

- [ ] Version number is correct
- [ ] URL points to your repository
- [ ] Hash will be calculated after release
- [ ] extract_dir matches archive structure
- [ ] bin path is correct for Windows

## ✅ Testing (On Windows Machine)

### Local Script Testing

- [ ] Test PowerShell script directly:

  ```powershell
  cd scripts
  powershell -ExecutionPolicy Bypass -File .\ali-automation.ps1 help
  powershell -ExecutionPolicy Bypass -File .\ali-automation.ps1 version
  powershell -ExecutionPolicy Bypass -File .\ali-automation.ps1 create-project TestProj
  ```

- [ ] Test batch wrapper:
  ```powershell
  .\ali-automation.bat help
  .\ali-automation.bat version
  .\ali-automation.bat create-project TestProj
  ```

### Generated Project Testing

- [ ] Project directory is created
- [ ] All subdirectories exist (src/test/java, datasource, cleanup, .idea)
- [ ] Java files have correct package declarations
- [ ] build.gradle is valid
- [ ] IntelliJ .iml file is created
- [ ] CSV file has headers
- [ ] Gradle wrapper works:
  ```powershell
  cd TestProj
  .\gradlew.bat --version
  .\gradlew.bat build
  ```

### IntelliJ Integration Testing

- [ ] Open project in IntelliJ IDEA
- [ ] Project loads without errors
- [ ] Java SDK is detected (Java 11)
- [ ] Source folders are marked correctly
- [ ] Dependencies resolve successfully
- [ ] No compilation errors

## ✅ Documentation Review

- [ ] README has Windows-specific instructions
- [ ] Installation steps are clear and tested
- [ ] Examples use Windows paths and commands (.\gradlew.bat)
- [ ] Prerequisites list is complete
- [ ] Troubleshooting section covers common Windows issues
- [ ] Repository URLs are correct
- [ ] All code blocks use correct syntax (powershell, java, etc.)

## ✅ Pre-Commit Checks

```powershell
# Run these checks before committing

# 1. Check for syntax errors
Get-Content scripts\ali-automation.ps1 | Select-String "syntax error"

# 2. Verify manifest is valid JSON
Get-Content bucket\ali-automation.json | ConvertFrom-Json

# 3. Check for hardcoded paths
Get-ChildItem -Recurse | Select-String "/Users/" -List

# 4. Verify line endings (should be CRLF for Windows)
git config core.autocrlf true
```

Expected results:

- [ ] No syntax errors
- [ ] JSON is valid
- [ ] No macOS-specific paths (except in examples)
- [ ] Line endings configured

## ✅ Git Operations

```bash
# Review changes
git status
git diff

# Stage all files
git add .

# Commit with descriptive message
git commit -m "Convert Homebrew formula to Scoop package

- Add PowerShell implementation (ali-automation.ps1)
- Add Windows batch wrapper (ali-automation.bat)
- Create Scoop manifest (ali-automation.json)
- Update documentation for Windows
- Add comprehensive guides (INSTALLATION, QUICKSTART, TESTING, RELEASE)
- Maintain feature parity with Homebrew version"

# Push to GitHub
git push origin main
```

Actions:

- [ ] All files are staged
- [ ] Commit message is descriptive
- [ ] Changes are pushed to GitHub

## ✅ Release Process

### 1. Create Git Tag

```bash
git tag -a v1.0.3 -m "Version 1.0.3 - Initial Windows/Scoop release"
git push origin v1.0.3
```

- [ ] Tag created locally
- [ ] Tag pushed to GitHub

### 2. Create GitHub Release

1. Go to: https://github.com/alirazabrame/scoop-ali-automation/releases
2. Click "Create a new release"
3. Select tag: v1.0.3
4. Release title: "ALI Automation v1.0.3"
5. Add release notes (see RELEASE.md for template)
6. Click "Publish release"

- [ ] GitHub release created
- [ ] Release notes are complete
- [ ] Release is published (not draft)

### 3. Calculate and Update Hash

```powershell
# Download the release archive
$url = "https://github.com/alirazabrame/scoop-ali-automation/archive/v1.0.3.zip"
Invoke-WebRequest -Uri $url -OutFile "ali-automation-v1.0.3.zip"

# Calculate SHA256
$hash = (Get-FileHash "ali-automation-v1.0.3.zip" -Algorithm SHA256).Hash
Write-Host "Hash: sha256:$hash"

# Update bucket/ali-automation.json with the hash
# Then commit and push
```

- [ ] Archive downloaded
- [ ] Hash calculated
- [ ] Manifest updated with hash
- [ ] Changes committed and pushed

## ✅ Scoop Installation Testing

### Install from Your Bucket

```powershell
# Add your bucket
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation

# Install the package
scoop install ali-automation

# Verify installation
scoop list | Select-String "ali-automation"
ali-automation version
```

- [ ] Bucket added successfully
- [ ] Package installed without errors
- [ ] Command is available globally
- [ ] Version command works

### Create Test Project

```powershell
mkdir C:\temp\scoop-test
cd C:\temp\scoop-test
ali-automation create-project ScoopTestProject
cd ScoopTestProject
.\gradlew.bat build
```

- [ ] Project created successfully
- [ ] Build completes without errors
- [ ] All files are present

### Test Uninstall

```powershell
scoop uninstall ali-automation
ali-automation version  # Should fail
```

- [ ] Uninstall completes
- [ ] Command is removed
- [ ] No leftover files

## ✅ Final Validation

### Cross-Platform Comparison

Compare with Homebrew version:

- [ ] Same commands work on both platforms
- [ ] Same project structure is generated
- [ ] Same features are available
- [ ] Documentation mentions both platforms

### User Experience

- [ ] Installation is straightforward
- [ ] Commands are intuitive
- [ ] Error messages are helpful
- [ ] Success messages are clear
- [ ] Progress indicators work

### Performance

- [ ] Script executes reasonably fast (< 30 seconds)
- [ ] No excessive memory usage
- [ ] No hanging or freezing

## ✅ Communication

### Update Related Resources

- [ ] Update any blog posts or articles
- [ ] Announce on social media (optional)
- [ ] Update other repositories that reference this
- [ ] Notify users who requested Windows support

### Create Issues/Discussions

- [ ] Enable GitHub Issues
- [ ] Enable GitHub Discussions
- [ ] Create issue templates
- [ ] Add contribution guidelines

## ✅ Post-Release Monitoring

### First 24 Hours

- [ ] Monitor GitHub Issues
- [ ] Check installation reports
- [ ] Respond to questions
- [ ] Fix critical bugs if any

### First Week

- [ ] Gather user feedback
- [ ] Document common issues
- [ ] Update FAQ if needed
- [ ] Plan next version improvements

## 🎯 Success Criteria

Your package is ready when:

- ✅ All tests pass on Windows
- ✅ Scoop installation works
- ✅ Generated projects build successfully
- ✅ IntelliJ integration works
- ✅ Documentation is complete
- ✅ No critical bugs

## 📝 Notes Section

Use this space to track any issues or special considerations:

```
Date: _____________
Tested by: _____________
Windows Version: _____________
Issues Found:
1.
2.
3.

Resolution:
1.
2.
3.
```

## ✨ You're Ready!

Once all items are checked, your Scoop package is ready for release! 🚀

**Next Steps:**

1. Complete any unchecked items above
2. Follow the release process in `RELEASE.md`
3. Test installation from published bucket
4. Monitor for user feedback
5. Iterate and improve

Good luck! 🎉
