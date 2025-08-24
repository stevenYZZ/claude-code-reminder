# Claude Code Reminder - Windows Installation
param([switch]$Uninstall)

$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$HOOK_FILE = "$CLAUDE_DIR\overseer.py"
$SETTINGS = "$CLAUDE_DIR\settings.json"
$GITHUB_RAW = "https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master"

if ($Uninstall) {
    Write-Host "Uninstalling Claude Code Reminder..." -ForegroundColor Yellow
    if (Test-Path $HOOK_FILE) { 
        Remove-Item $HOOK_FILE -Force 
        Write-Host "✓ Hook script removed" -ForegroundColor Green
    }
    # Clean settings.json
    if (Test-Path $SETTINGS) {
        $settings = Get-Content $SETTINGS -Raw | ConvertFrom-Json
        if ($settings.hooks.Notification) { $settings.hooks.PSObject.Properties.Remove("Notification") }
        if ($settings.hooks.Stop) { $settings.hooks.PSObject.Properties.Remove("Stop") }
        $settings | ConvertTo-Json -Depth 10 | Set-Content $SETTINGS -Encoding UTF8
        Write-Host "✓ Settings cleaned" -ForegroundColor Green
    }
    Write-Host "✓ Uninstall complete" -ForegroundColor Green
    exit
}

# Check Claude Code
if (!(Test-Path $CLAUDE_DIR)) {
    Write-Host "Error: Claude Code not found at $CLAUDE_DIR" -ForegroundColor Red
    Write-Host "Please install Claude Code first: https://claude.ai/download" -ForegroundColor Yellow
    exit 1
}

Write-Host "Installing Claude Code Reminder..." -ForegroundColor Cyan

# Download Windows version
try {
    $scriptUrl = "$GITHUB_RAW/scripts/overseer_windows.py"
    Invoke-WebRequest -Uri $scriptUrl -OutFile $HOOK_FILE -ErrorAction Stop
    Write-Host "✓ Downloaded overseer script" -ForegroundColor Green
} catch {
    # Fallback: embed the script
    Write-Host "Using embedded script..." -ForegroundColor Yellow
    $scriptContent = @'
#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Claude Code Reminder for Windows"""

import json
import sys
import subprocess
import os
import locale

# Windows编码修复
sys.stdout.reconfigure(encoding='utf-8')
sys.stderr.reconfigure(encoding='utf-8')
os.environ['PYTHONIOENCODING'] = 'utf-8'

def get_project_name():
    try:
        cwd = os.getcwd()
        project = os.path.basename(cwd)
        if not project or project in ['/', '\\', 'root', 'home']:
            return "Claude"
        return project
    except:
        return "Claude"

def detect_language():
    try:
        lang = locale.getdefaultlocale()[0]
        if lang and 'zh' in lang.lower():
            return 'zh'
        return 'en'
    except:
        return 'en'

def speak(text, lang='zh'):
    try:
        rate = 2 if lang == 'zh' else 1
        ps_cmd = f'''
        $voice = New-Object -ComObject SAPI.SpVoice
        $voice.Rate = {rate}
        $voice.Speak("{text}", 1)
        '''
        cmd = f'start /b "" powershell -NoProfile -WindowStyle Hidden -Command "{ps_cmd}"'
        subprocess.Popen(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, creationflags=0x08000000)
    except:
        pass

def main():
    try:
        data = json.load(sys.stdin)
        event = data.get("hook_event_name", "")
        
        if event not in ["Notification", "Stop"]:
            sys.exit(0)
        
        project = get_project_name()
        lang = detect_language()
        
        if lang == 'zh':
            messages = {
                'Notification': f"{project} 等待确认",
                'Stop': f"{project} 任务完成"
            }
        else:
            messages = {
                'Notification': f"{project} needs confirmation",
                'Stop': f"{project} task completed"
            }
        
        message = messages.get(event)
        if message:
            speak(message, lang)
    except:
        pass
    
    sys.exit(0)

if __name__ == "__main__":
    main()
'@
    Set-Content -Path $HOOK_FILE -Value $scriptContent -Encoding UTF8
}

# Update settings.json
$settings = if (Test-Path $SETTINGS) { 
    Get-Content $SETTINGS -Raw | ConvertFrom-Json 
} else { 
    @{ "`$schema" = "https://json.schemastore.org/claude-code-settings.json" }
}

if (-not $settings.hooks) { 
    $settings | Add-Member -NotePropertyName "hooks" -NotePropertyValue @{} -Force
}

$hookCmd = "python `"$($HOOK_FILE.Replace('\', '/'))`""
$hookConfig = @(@{hooks=@(@{type="command";command=$hookCmd;timeout=1})})

$settings.hooks.Notification = $hookConfig
$settings.hooks.Stop = $hookConfig

$settings | ConvertTo-Json -Depth 10 | Set-Content $SETTINGS -Encoding UTF8
Write-Host "✓ Settings updated" -ForegroundColor Green

# Test
Write-Host "`n✅ Installation complete!" -ForegroundColor Green
Write-Host "`nTesting voice notification..." -ForegroundColor Yellow
echo '{"hook_event_name":"Stop"}' | python $HOOK_FILE
Write-Host "You should hear 'Claude task completed'" -ForegroundColor Gray

Write-Host "`nTo uninstall: .\install.ps1 -Uninstall" -ForegroundColor Cyan