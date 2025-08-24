# Claude Code Reminder - Windows Installation with Notification Support
param(
    [switch]$Uninstall,
    [switch]$Voice,  # 使用语音版本
    [switch]$InstallDeps  # 安装Python依赖
)

$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$HOOK_FILE = "$CLAUDE_DIR\reminder.py"
$SETTINGS = "$CLAUDE_DIR\settings.json"

# Uninstall
if ($Uninstall) {
    Write-Host "Uninstalling Claude Code Reminder..." -ForegroundColor Yellow
    
    # Backup before uninstall
    if (Test-Path $SETTINGS) {
        $backupFile = "$SETTINGS.uninstall_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Copy-Item $SETTINGS $backupFile
        Write-Host "✓ Backed up settings to: $backupFile" -ForegroundColor Green
        
        # Remove hooks
        $settings = Get-Content $SETTINGS -Raw | ConvertFrom-Json
        if ($settings.hooks.Stop) { $settings.hooks.PSObject.Properties.Remove("Stop") }
        if ($settings.hooks.Notification) { $settings.hooks.PSObject.Properties.Remove("Notification") }
        
        # Save with proper formatting
        $tempJson = $settings | ConvertTo-Json -Depth 10
        $tempFile = "$env:TEMP\claude_settings_temp.json"
        $tempJson | Out-File -FilePath $tempFile -Encoding UTF8
        
        python -c @"
import json
with open(r'$tempFile', 'r', encoding='utf-8-sig') as f:
    data = json.load(f)
with open(r'$env:USERPROFILE\.claude\settings.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
"@
        
        Remove-Item $tempFile
    }
    
    # Remove hook file
    if (Test-Path $HOOK_FILE) { Remove-Item $HOOK_FILE -Force }
    
    Write-Host "✓ Uninstall complete" -ForegroundColor Green
    exit
}

# Check Claude Code
if (!(Test-Path $CLAUDE_DIR)) {
    Write-Host "Error: Claude Code not found at $CLAUDE_DIR" -ForegroundColor Red
    exit 1
}

Write-Host "Installing Claude Code Reminder..." -ForegroundColor Cyan

# Install Python dependencies if requested
if ($InstallDeps) {
    Write-Host "Installing Python dependencies..." -ForegroundColor Yellow
    pip install plyer --quiet
    Write-Host "✓ Dependencies installed" -ForegroundColor Green
}

# Choose script version
if ($Voice) {
    $scriptUrl = "https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/scripts/reminder_windows.py"
    Write-Host "→ Using voice notification version" -ForegroundColor Cyan
} else {
    $scriptUrl = "https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/scripts/reminder_windows_notify.py"
    Write-Host "→ Using system notification version (recommended)" -ForegroundColor Cyan
    Write-Host "  Tip: Install plyer for best experience: pip install plyer" -ForegroundColor Gray
}

# Download hook script from GitHub
try {
    Invoke-WebRequest -Uri $scriptUrl -OutFile $HOOK_FILE -UseBasicParsing
    Write-Host "✓ Downloaded hook script from GitHub" -ForegroundColor Green
} catch {
    Write-Host "Error: Failed to download script from GitHub" -ForegroundColor Red
    Write-Host "Please check your internet connection" -ForegroundColor Yellow
    exit 1
}

# Backup existing settings
if (Test-Path $SETTINGS) {
    $backupFile = "$SETTINGS.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $SETTINGS $backupFile
    Write-Host "✓ Backed up settings to: $backupFile" -ForegroundColor Green
}

# Update settings
$settings = if (Test-Path $SETTINGS) { 
    Get-Content $SETTINGS -Raw | ConvertFrom-Json 
} else { 
    [PSCustomObject]@{"$schema" = "https://json.schemastore.org/claude-code-settings.json"}
}

# Ensure hooks exist
if (-not $settings.PSObject.Properties["hooks"]) {
    Add-Member -InputObject $settings -NotePropertyName "hooks" -NotePropertyValue ([PSCustomObject]@{}) -Force
}

# Add Stop and Notification hooks
$hookConfig = @(
    @{
        hooks = @(
            @{
                type = "command"
                command = "python `"$HOOK_FILE`""
                timeout = 1
            }
        )
    }
)

Add-Member -InputObject $settings.hooks -NotePropertyName "Stop" -NotePropertyValue $hookConfig -Force
Add-Member -InputObject $settings.hooks -NotePropertyName "Notification" -NotePropertyValue $hookConfig -Force

# Save settings with proper JSON formatting using Python
$tempJson = $settings | ConvertTo-Json -Depth 10
$tempFile = "$env:TEMP\claude_settings_temp.json"
$tempJson | Out-File -FilePath $tempFile -Encoding UTF8

python -c @"
import json
with open(r'$tempFile', 'r', encoding='utf-8-sig') as f:
    data = json.load(f)
with open(r'$env:USERPROFILE\.claude\settings.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
"@

Remove-Item $tempFile
Write-Host "✓ Settings updated" -ForegroundColor Green

Write-Host "`n✅ Installation complete!" -ForegroundColor Green

if (-not $Voice) {
    Write-Host "`n📢 Using system notification mode" -ForegroundColor Cyan
    Write-Host "   Claude Code will show Windows notifications when tasks complete." -ForegroundColor Gray
    Write-Host "   For best experience, install: pip install plyer" -ForegroundColor Yellow
} else {
    Write-Host "`n🔊 Using voice notification mode" -ForegroundColor Cyan
    Write-Host "   Claude Code will announce when tasks complete." -ForegroundColor Gray
}

Write-Host "`nTo uninstall: .\install_notify.ps1 -Uninstall" -ForegroundColor Gray
Write-Host "To switch modes: .\install_notify.ps1 -Voice" -ForegroundColor Gray