# Client Update Process

This document describes the complete process for updating The Infinite Black client to a new version and deploying it to the website.

**IMPORTANT**: When updating the client, **ALWAYS update both Windows AND macOS clients** to the same version number.

---

## Quick Update (Using Automated Script)

For routine updates, use the automated script:

```powershell
cd C:\Projects\TIBStar-Website
.\update-version.ps1 -NewVersion "1.4.8" -UpdateDate "January 2, 2026"
```

The script will:
1. ✓ Verify both Windows and Mac builds exist
2. ✓ Package both clients with version numbers
3. ✓ Update website with new version numbers and dates
4. ✓ Commit to GitHub
5. ✓ Deploy to Netlify

**Then skip to [Verification](#verification) section below.**

---

## Manual Update Process

If you need to update manually or want to understand the full process:

### Step 1: Make Code Changes

If you're making code changes (not just rebuilding):

1. **Navigate to project**:
   ```bash
   cd /c/Projects/TheInfiniteBlack
   ```

2. **Make your code changes** in `Assets/Assembly/` directory

3. **Update version in TibProxy.cs**:
   ```csharp
   // In TibProxy.cs
   public readonly string clientVersion = "1.4.8"; // Update this
   ```

---

### Step 2: Rebuild Both Clients

**CRITICAL**: You MUST rebuild BOTH Windows and Mac clients, even if you only changed one.

#### 2a. Rebuild Windows Client

```bash
cd /c/Projects/TheInfiniteBlack

# Build firstpass assembly
"C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" \
  "Assets/Assembly/TheInfiniteBlack.Unity.FirstPass/TheInfiniteBlack.Unity.FirstPass.csproj" \
  /p:Configuration=Release

# Build library
"C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" \
  "Assets/Assembly/TheInfiniteBlack.Library/TheInfiniteBlack.Library.csproj" \
  /p:Configuration=Release

# Build main assembly
"C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe" \
  "Assets/Assembly/TheInfiniteBlack.Unity/TheInfiniteBlack.Unity.csproj" \
  /p:Configuration=Release

# Copy DLLs to build directory
cp "Assets/Assembly/bin/Release/net35/Assembly-CSharp-firstpass.dll" \
   "Build/TIB-Recompiled_Data/Managed/"

cp "Assets/Assembly/bin/Release/net35/TheInfiniteBlack.Library.dll" \
   "Build/TIB-Recompiled_Data/Managed/"

cp "Assets/Assembly/bin/Release/net35/Assembly-CSharp.dll" \
   "Build/TIB-Recompiled_Data/Managed/"
```

**Verify Windows build**:
```bash
"/c/Projects/TheInfiniteBlack/Build/TIB-Recompiled.exe"
```

#### 2b. Rebuild Mac Client

```bash
cd /c/Projects/TheInfiniteBlack/Build-Mac

# Remove old build
rm -rf TIB-Recompiled.app

# Copy Mac player template
cp -r "/c/Program Files/Unity/Hub/Editor/5.6.7f1/Editor/Data/PlaybackEngines/MacStandaloneSupport/Variations/universal_nondevelopment_mono" \
   "TIB-Recompiled.app"

# Copy game data
cp -r "../Build/TIB-Recompiled_Data/"* "TIB-Recompiled.app/Data/"

# Copy DLLs (same ones as Windows)
cp -r "../Build/TIB-Recompiled_Data/Managed" "TIB-Recompiled.app/Data/"
```

**Update Info.plist** in `TIB-Recompiled.app/UnityPlayer.app/Contents/Info.plist`:
- Ensure `CFBundleIdentifier` = `com.spellbook.theinfiniteblack`
- Ensure `CFBundleName` = `The Infinite Black`
- Update `CFBundleShortVersionString` to new version (e.g., `1.4.8`)
- Update `CFBundleVersion` to new version (e.g., `1.4.8`)

---

### Step 3: Package Clients

#### 3a. Package Windows Client

```powershell
cd C:\Projects\TheInfiniteBlack
$version = "1.4.8"  # Your new version

# Create versioned ZIP
Compress-Archive -Path "Build\*" `
  -DestinationPath "C:\Projects\TIBStar-Website\downloads\TIB-Remastered-v$version-Windows.zip" `
  -Force

# Check size
Get-Item "C:\Projects\TIBStar-Website\downloads\TIB-Remastered-v$version-Windows.zip" | Select-Object Name, Length
```

#### 3b. Package Mac Client

```powershell
cd C:\Projects\TheInfiniteBlack
$version = "1.4.8"  # Your new version

# Create versioned ZIP
Compress-Archive -Path "Build-Mac\TIB-Recompiled.app" `
  -DestinationPath "C:\Projects\TIBStar-Website\downloads\TIB-Remastered-v$version-macOS.zip" `
  -Force

# Check size
Get-Item "C:\Projects\TIBStar-Website\downloads\TIB-Remastered-v$version-macOS.zip" | Select-Object Name, Length
```

---

### Step 4: Update Website

Edit `C:\Projects\TIBStar-Website\index.html`:

#### 4a. Update Version Numbers

Find and replace:
```html
<!-- OLD -->
<p class="version">Version 1.4.7 (Unity 5.6.7f1)</p>

<!-- NEW -->
<p class="version">Version 1.4.8 (Unity 5.6.7f1)</p>
```

Do this for BOTH Windows and macOS sections.

#### 4b. Update Dates

Find and replace:
```html
<!-- OLD -->
<p class="updated">Updated: January 1, 2026</p>

<!-- NEW -->
<p class="updated">Updated: January 2, 2026</p>
```

Do this for BOTH Windows and macOS sections.

#### 4c. Update Download Links

```html
<!-- Windows download link -->
<a href="downloads/TIB-Remastered-v1.4.8-Windows.zip" class="download-btn" download>

<!-- macOS download link -->
<a href="downloads/TIB-Remastered-v1.4.8-macOS.zip" class="download-btn" download>
```

#### 4d. Update File Sizes (if changed)

```html
<!-- Windows -->
<p class="size">Size: ~42 MB</p>  <!-- Update if size changed -->

<!-- macOS -->
<p class="size">Size: ~60 MB</p>  <!-- Update if size changed -->
```

---

### Step 5: Remove Old Downloads

```powershell
cd C:\Projects\TIBStar-Website\downloads

# Remove old versioned files
Remove-Item TIB-Remastered-v1.4.7-Windows.zip
Remove-Item TIB-Remastered-v1.4.7-macOS.zip

# Verify only new versions remain
Get-ChildItem TIB-Remastered-*.zip
```

---

### Step 6: Commit and Deploy

```bash
cd /c/Projects/TIBStar-Website

# Check what's changed
git status

# Add all changes
git add downloads/TIB-Remastered-v1.4.8-Windows.zip
git add downloads/TIB-Remastered-v1.4.8-macOS.zip
git add index.html

# Commit
git commit -m "Update to version 1.4.8

- Update Windows client to v1.4.8
- Update macOS client to v1.4.8
- Update website version numbers and dates

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# Push to GitHub
git push

# Deploy to Netlify
netlify deploy --prod --dir=.
```

---

## Verification

After deployment, verify everything is working:

### 1. Check Website

Visit: https://tibstar.com

Verify:
- ✓ Version numbers show new version (both Windows and macOS)
- ✓ Dates show current update date
- ✓ Download links work
- ✓ File sizes are correct

### 2. Download and Test

**Windows**:
1. Download `TIB-Remastered-v1.4.8-Windows.zip`
2. Extract and run `TIB-Recompiled.exe`
3. Check version in client (if displayed)
4. Verify connection to server works

**macOS** (if you have a Mac):
1. Download `TIB-Remastered-v1.4.8-macOS.zip`
2. Extract and move app to Applications
3. Right-click and Open (first time)
4. Verify connection to server works

### 3. Check Deployment

```bash
# Check latest Netlify deployment
cd /c/Projects/TIBStar-Website
netlify status

# View deploy logs
# Visit: https://app.netlify.com/projects/tibstar-website/deploys
```

---

## Version History

Track versions here for reference:

| Version | Date | Windows Size | macOS Size | Notes |
|---------|------|--------------|------------|-------|
| 1.4.7 | Jan 1, 2026 | 40 MB | 58 MB | Initial release with Mac support |
| 1.4.8 | Jan X, 2026 | XX MB | XX MB | [Description of changes] |

---

## Troubleshooting

### Windows Client Won't Run After Update

**Problem**: Old DLLs still in Managed folder

**Solution**:
```bash
# Clear and rebuild
rm -rf /c/Projects/TheInfiniteBlack/Build/TIB-Recompiled_Data/Managed/*
# Then rebuild all 3 assemblies and copy DLLs
```

### Mac Client Shows Wrong Version

**Problem**: Info.plist not updated

**Solution**:
Edit `Build-Mac/TIB-Recompiled.app/UnityPlayer.app/Contents/Info.plist`:
```xml
<key>CFBundleShortVersionString</key>
<string>1.4.8</string>
<key>CFBundleVersion</key>
<string>1.4.8</string>
```

### Website Shows Old Version After Deploy

**Problem**: Browser cache or CDN not updated

**Solution**:
1. Clear browser cache (Ctrl+Shift+R)
2. Wait 2-3 minutes for Netlify CDN to update
3. Check deployment status at https://app.netlify.com

### Download Links 404

**Problem**: Filename mismatch between index.html and actual file

**Solution**:
```bash
# Check actual filenames
ls -la /c/Projects/TIBStar-Website/downloads/

# Make sure index.html links match exactly
```

---

## Best Practices

1. **Always update BOTH platforms** - Even if you only changed Windows code, rebuild and deploy Mac too
2. **Use consistent version numbers** - Same version for both Windows and Mac
3. **Test before deploying** - Run both clients locally before packaging
4. **Document changes** - Update version history table above
5. **Clean up old versions** - Remove old ZIP files to save space
6. **Verify deployment** - Always test downloads from live site

---

## Emergency Rollback

If you need to rollback to previous version:

```bash
cd /c/Projects/TIBStar-Website

# Find previous commit
git log --oneline | head -10

# Revert to previous commit
git revert HEAD

# Or reset to specific commit (dangerous)
# git reset --hard <commit-hash>

# Push
git push

# Redeploy
netlify deploy --prod --dir=.
```

---

## Contact

For questions about the update process:
- Check `README.md` for general website info
- Check `C:\Projects\TheInfiniteBlack\SESSION_KNOWLEDGE_BASE.md` for build process
- Check `DEPLOYMENT_COMPLETE.md` for deployment info

---

**Last Updated**: January 1, 2026
**Current Version**: 1.4.7
**Next Version**: TBD
