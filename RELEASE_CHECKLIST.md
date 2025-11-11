# Release Checklist for ALI Automation Scoop Package

## Pre-Release Checklist

### 1. Version Management

- [ ] Update version in `bucket/ali-automation.json`
- [ ] Update version in `scripts/ali-automation.bat` (line 5)
- [ ] Update version in `scripts/ali-automation.ps1` (line 4)
- [ ] Ensure all files use consistent version number

### 2. Testing

- [ ] Test batch script on Windows
  ```cmd
  scripts\ali-automation.bat create-project TestProject
  ```
- [ ] Test PowerShell script on Windows
  ```powershell
  .\scripts\ali-automation.ps1 create-project TestProject
  ```
- [ ] Verify created project structure
- [ ] Test Gradle build in created project
- [ ] Test in IntelliJ IDEA

### 3. Documentation

- [ ] Review README.md for accuracy
- [ ] Review SETUP_GUIDE.md
- [ ] Check all links work
- [ ] Verify examples are correct

## Release Process

### Step 1: Commit Changes

```bash
git add .
git commit -m "Release version X.X.X"
git push origin main
```

### Step 2: Create GitHub Release

```bash
# Tag the release
git tag -a vX.X.X -m "Release version X.X.X"
git push origin vX.X.X
```

1. Go to GitHub repository
2. Click "Releases" → "Create a new release"
3. Select tag: `vX.X.X`
4. Title: `ALI Automation vX.X.X`
5. Description: List changes
6. Click "Publish release"

### Step 3: Update Hash in Manifest

After creating the GitHub release, the archive URL will be available:

```
https://github.com/alirazabrame/scoop-ali-automation/archive/vX.X.X.zip
```

Calculate SHA256 hash:

**Option A: Using PowerShell**

```powershell
$url = "https://github.com/alirazabrame/scoop-ali-automation/archive/vX.X.X.zip"
$hash = (Get-FileHash -InputStream (Invoke-WebRequest $url).Content -Algorithm SHA256).Hash
Write-Host "sha256:$($hash.ToLower())"
```

**Option B: Download and hash**

```powershell
# Download the zip
Invoke-WebRequest -Uri "https://github.com/alirazabrame/scoop-ali-automation/archive/vX.X.X.zip" -OutFile "release.zip"

# Calculate hash
Get-FileHash release.zip -Algorithm SHA256

# Clean up
Remove-Item release.zip
```

**Option C: Use Scoop's checkver**

```powershell
scoop checkver -u ali-automation
```

### Step 4: Update Manifest Hash

Edit `bucket/ali-automation.json`:

```json
{
    "version": "X.X.X",
    "hash": "sha256:YOUR_CALCULATED_HASH_HERE",
    ...
}
```

### Step 5: Commit Hash Update

```bash
git add bucket/ali-automation.json
git commit -m "Update hash for version X.X.X"
git push origin main
```

## Testing Installation

### Test on Clean Windows Machine

```powershell
# Add bucket
scoop bucket add ali-automation https://github.com/alirazabrame/scoop-ali-automation

# Install
scoop install ali-automation

# Verify installation
ali-automation version
ali-automation help

# Test project creation
ali-automation create-project TestProject
cd TestProject
.\gradlew build
```

### Test Update Process

```powershell
scoop update ali-automation
ali-automation version
```

## Post-Release Checklist

- [ ] Verify Scoop installation works
- [ ] Test on fresh Windows installation (if possible)
- [ ] Update GitHub repo description
- [ ] Update documentation if needed
- [ ] Announce release (if applicable)

## Version Numbering

Follow Semantic Versioning (SemVer):

- **MAJOR** version: Incompatible API changes
- **MINOR** version: Add functionality (backwards-compatible)
- **PATCH** version: Bug fixes (backwards-compatible)

Example:

- `1.0.0` - Initial release
- `1.0.1` - Bug fix
- `1.1.0` - New feature
- `2.0.0` - Breaking change

## Rollback Procedure

If a release has issues:

```bash
# Revert to previous version
git revert <commit_hash>
git push origin main

# Delete bad tag
git tag -d vX.X.X
git push origin :refs/tags/vX.X.X

# Delete GitHub release
# (Do this manually on GitHub)
```

## Common Issues

### Issue: Wrong hash in manifest

**Solution:** Recalculate and update hash, commit and push

### Issue: Extract directory doesn't match

**Solution:** Verify `extract_dir` matches archive structure

### Issue: Binary path incorrect

**Solution:** Check `bin` array points to correct script location

## Files to Check Before Release

- [ ] `bucket/ali-automation.json` - Manifest
- [ ] `scripts/ali-automation.bat` - Windows batch script
- [ ] `scripts/ali-automation.ps1` - PowerShell script (optional)
- [ ] `README.md` - Documentation
- [ ] `SETUP_GUIDE.md` - Setup instructions
- [ ] `LICENSE` - License file

## Automation Opportunities

Consider creating:

- GitHub Actions workflow for testing
- Automated hash calculation on tag
- Automated manifest update
- Release notes generation

## Support

After release, monitor:

- GitHub Issues
- Installation reports
- User feedback

## Notes

- Always test on actual Windows machine before release
- Keep backup of working version
- Document any breaking changes clearly
- Update examples if API changes
