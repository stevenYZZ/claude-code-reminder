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

# Create hook script
$hookScript = @'
#!/usr/bin/env python
# -*- coding: utf-8 -*-
import json, sys, subprocess, os, locale

# Windows encoding fix
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')

def main():
    try:
        data = json.load(sys.stdin)
        if data.get("hook_event_name") == "Stop":
            # Get project name
            project = os.path.basename(os.getcwd()) or "Claude"
            
            # Detect language
            lang = 'zh' if 'zh' in (locale.getdefaultlocale()[0] or '').lower() else 'en'
            text = f"{project} 任务完成" if lang == 'zh' else f"{project} task completed"
            
            # Speak
            ps_cmd = f'$v=New-Object -ComObject SAPI.SpVoice;$v.Rate=2;$v.Speak("{text}")'
            subprocess.Popen(['powershell', '-Command', ps_cmd], 
                           stdout=subprocess.DEVNULL, 
                           stderr=subprocess.DEVNULL)
    except:
        pass
    sys.exit(0)

if __name__ == "__main__":
    main()
'@

# Save hook script
$hookScript | Set-Content $HOOK_FILE
Write-Host "✓ Created hook script" -ForegroundColor Green

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

# Add Stop hook
$hookConfig = @(@{
    hooks = @(@{
        type = "command"
        command = "python `"$($HOOK_FILE.Replace('\', '/'))`""
        timeout = 1
    })
})

Add-Member -InputObject $settings.hooks -NotePropertyName "Stop" -NotePropertyValue $hookConfig -Force

# Save settings  
$settings | ConvertTo-Json -Depth 10 | Set-Content "$env:USERPROFILE\.claude\settings.json"
Write-Host "✓ Settings updated" -ForegroundColor Green

Write-Host "`n✅ Installation complete!" -ForegroundColor Green
Write-Host "Claude Code will now announce when tasks complete." -ForegroundColor Cyan
Write-Host "`nTo uninstall: .\install.ps1 -Uninstall" -ForegroundColor Gray