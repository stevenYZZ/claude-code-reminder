# Claude Code Reminder - Windows Installation
param([switch]$Uninstall)

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
        
        # Save
        $settings | ConvertTo-Json -Depth 10 | Set-Content $SETTINGS
    }
    
    # Remove hook file
    if (Test-Path $HOOK_FILE) { Remove-Item $HOOK_FILE -Force }
    
    Write-Host "✓ Uninstall complete" -ForegroundColor Green
    exit
}

# Check Claude Code
if (!(Test-Path $CLAUDE_DIR)) {
    Write-Host "Error: Claude Code not found" -ForegroundColor Red
    exit 1
}

Write-Host "Installing Claude Code Reminder..." -ForegroundColor Cyan

# Download hook script from GitHub
try {
    $scriptUrl = "https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/scripts/reminder_windows.py"
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
$hookConfig = @(@{
    hooks = @(@{
        type = "command"
        command = "python `"$($HOOK_FILE.Replace('\', '/'))`""
        timeout = 1
    })
})

Add-Member -InputObject $settings.hooks -NotePropertyName "Stop" -NotePropertyValue $hookConfig -Force
Add-Member -InputObject $settings.hooks -NotePropertyName "Notification" -NotePropertyValue $hookConfig -Force

# Save settings  
$settings | ConvertTo-Json -Depth 10 | Set-Content "$env:USERPROFILE\.claude\settings.json"
Write-Host "✓ Settings updated" -ForegroundColor Green

Write-Host "`n✅ Installation complete!" -ForegroundColor Green
Write-Host "Claude Code will now announce when tasks complete." -ForegroundColor Cyan
Write-Host "`nTo uninstall: .\install.ps1 -Uninstall" -ForegroundColor Gray