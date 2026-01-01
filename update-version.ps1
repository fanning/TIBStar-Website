# TIB Client Version Update Script
# This script updates both Windows and Mac clients and the website simultaneously

param(
    [Parameter(Mandatory=$true)]
    [string]$NewVersion,

    [Parameter(Mandatory=$false)]
    [string]$UpdateDate = (Get-Date -Format "MMMM d, yyyy")
)

Write-Host "=== TIB Client Version Update Script ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Current Version: 1.4.7" -ForegroundColor Yellow
Write-Host "New Version: $NewVersion" -ForegroundColor Green
Write-Host "Update Date: $UpdateDate" -ForegroundColor Green
Write-Host ""

# Confirm with user
$confirm = Read-Host "This will update BOTH Windows and Mac clients. Continue? (y/n)"
if ($confirm -ne 'y') {
    Write-Host "Update cancelled." -ForegroundColor Red
    exit
}

Write-Host ""
Write-Host "Step 1: Updating client files..." -ForegroundColor Yellow
Write-Host ""

# Define paths
$projectRoot = "C:\Projects\TheInfiniteBlack"
$websiteRoot = "C:\Projects\TIBStar-Website"
$downloadsDir = "$websiteRoot\downloads"

# Check if new builds exist
$windowsBuildExists = Test-Path "$projectRoot\Build\TIB-Recompiled.exe"
$macBuildExists = Test-Path "$projectRoot\Build-Mac\TIB-Recompiled.app"

if (-not $windowsBuildExists) {
    Write-Host "ERROR: Windows build not found at $projectRoot\Build\TIB-Recompiled.exe" -ForegroundColor Red
    Write-Host "Please rebuild the Windows client first." -ForegroundColor Red
    exit 1
}

if (-not $macBuildExists) {
    Write-Host "ERROR: Mac build not found at $projectRoot\Build-Mac\TIB-Recompiled.app" -ForegroundColor Red
    Write-Host "Please rebuild the Mac client first." -ForegroundColor Red
    exit 1
}

Write-Host "✓ Windows build found" -ForegroundColor Green
Write-Host "✓ Mac build found" -ForegroundColor Green
Write-Host ""

# Remove old versioned files
Write-Host "Removing old versioned downloads..." -ForegroundColor Yellow
Get-ChildItem $downloadsDir -Filter "TIB-Remastered-v*.zip" | Remove-Item -Force
Write-Host "✓ Old downloads removed" -ForegroundColor Green
Write-Host ""

# Package Windows client
Write-Host "Packaging Windows client..." -ForegroundColor Yellow
$windowsZipPath = "$downloadsDir\TIB-Remastered-v$NewVersion-Windows.zip"
Compress-Archive -Path "$projectRoot\Build\*" -DestinationPath $windowsZipPath -Force
$windowsSize = [math]::Round((Get-Item $windowsZipPath).Length / 1MB, 0)
Write-Host "✓ Windows client packaged: $windowsSize MB" -ForegroundColor Green
Write-Host ""

# Package Mac client
Write-Host "Packaging Mac client..." -ForegroundColor Yellow
$macZipPath = "$downloadsDir\TIB-Remastered-v$NewVersion-macOS.zip"
Compress-Archive -Path "$projectRoot\Build-Mac\TIB-Recompiled.app" -DestinationPath $macZipPath -Force
$macSize = [math]::Round((Get-Item $macZipPath).Length / 1MB, 0)
Write-Host "✓ Mac client packaged: $macSize MB" -ForegroundColor Green
Write-Host ""

# Update index.html
Write-Host "Step 2: Updating website..." -ForegroundColor Yellow
Write-Host ""

$indexPath = "$websiteRoot\index.html"
$indexContent = Get-Content $indexPath -Raw

# Update version numbers
$indexContent = $indexContent -replace 'Version \d+\.\d+\.\d+', "Version $NewVersion"

# Update dates
$indexContent = $indexContent -replace 'Updated: [^<]+', "Updated: $UpdateDate"

# Update download links
$indexContent = $indexContent -replace 'TIB-Remastered-v[\d.]+\-Windows\.zip', "TIB-Remastered-v$NewVersion-Windows.zip"
$indexContent = $indexContent -replace 'TIB-Remastered-v[\d.]+\-macOS\.zip', "TIB-Remastered-v$NewVersion-macOS.zip"

# Update file sizes
$indexContent = $indexContent -replace 'Size: ~\d+ MB</p>\s+<p class="updated">Updated: [^<]+</p>\s+</div>\s+<a href="downloads/TIB-Remastered-v[\d.]+-Windows\.zip"', "Size: ~$windowsSize MB</p>`n                            <p class=`"updated`">Updated: $UpdateDate</p>`n                        </div>`n                        <a href=`"downloads/TIB-Remastered-v$NewVersion-Windows.zip`""

$indexContent = $indexContent -replace '(<h4>macOS Client</h4>\s+<p class="version">Version [\d.]+[^<]*</p>\s+<p class="size">)Size: ~\d+ MB', "`$1Size: ~$macSize MB"

# Save updated index.html
Set-Content $indexPath $indexContent -NoNewline
Write-Host "✓ index.html updated" -ForegroundColor Green
Write-Host ""

# Show summary
Write-Host "Step 3: Summary" -ForegroundColor Yellow
Write-Host ""
Write-Host "Files created:" -ForegroundColor White
Write-Host "  - $windowsZipPath ($windowsSize MB)" -ForegroundColor Gray
Write-Host "  - $macZipPath ($macSize MB)" -ForegroundColor Gray
Write-Host ""
Write-Host "Website updated:" -ForegroundColor White
Write-Host "  - Version: $NewVersion" -ForegroundColor Gray
Write-Host "  - Date: $UpdateDate" -ForegroundColor Gray
Write-Host ""

# Git operations
Write-Host "Step 4: Git operations" -ForegroundColor Yellow
Write-Host ""

$gitConfirm = Read-Host "Commit and push to GitHub? (y/n)"
if ($gitConfirm -eq 'y') {
    Set-Location $websiteRoot

    Write-Host "Adding files to git..." -ForegroundColor Gray
    git add downloads/TIB-Remastered-v$NewVersion-Windows.zip
    git add downloads/TIB-Remastered-v$NewVersion-macOS.zip
    git add index.html

    Write-Host "Committing changes..." -ForegroundColor Gray
    $commitMessage = @"
Update to version $NewVersion

- Update Windows client to v$NewVersion ($windowsSize MB)
- Update macOS client to v$NewVersion ($macSize MB)
- Update website version numbers and dates
- Updated: $UpdateDate

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
"@

    git commit -m $commitMessage

    Write-Host "Pushing to GitHub..." -ForegroundColor Gray
    git push

    Write-Host "✓ Committed and pushed to GitHub" -ForegroundColor Green
    Write-Host ""
}

# Netlify deployment
Write-Host "Step 5: Netlify deployment" -ForegroundColor Yellow
Write-Host ""

$deployConfirm = Read-Host "Deploy to Netlify? (y/n)"
if ($deployConfirm -eq 'y') {
    Write-Host "Deploying to Netlify..." -ForegroundColor Gray
    Set-Location $websiteRoot
    netlify deploy --prod --dir=.
    Write-Host "✓ Deployed to Netlify" -ForegroundColor Green
    Write-Host ""
}

Write-Host ""
Write-Host "=== Update Complete! ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Version $NewVersion is now live!" -ForegroundColor Green
Write-Host "View at: https://tibstar.com" -ForegroundColor Cyan
Write-Host ""
