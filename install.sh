#!/bin/bash
# Claude Code Reminder - macOS/Linux Installation

CLAUDE_DIR="$HOME/.claude"
HOOK_FILE="$CLAUDE_DIR/overseer.py"
SETTINGS="$CLAUDE_DIR/settings.json"
GITHUB_RAW="https://raw.githubusercontent.com/yourusername/claude-code-reminder/main"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Uninstall
if [[ "$1" == "--uninstall" ]] || [[ "$1" == "-u" ]]; then
    echo -e "${YELLOW}Uninstalling Claude Code Reminder...${NC}"
    if [ -f "$HOOK_FILE" ]; then
        rm -f "$HOOK_FILE"
        echo -e "${GREEN}✓ Hook script removed${NC}"
    fi
    # Clean settings.json
    if [ -f "$SETTINGS" ]; then
        python3 -c "
import json
try:
    with open('$SETTINGS', 'r') as f:
        settings = json.load(f)
    if 'hooks' in settings:
        settings['hooks'].pop('Notification', None)
        settings['hooks'].pop('Stop', None)
    with open('$SETTINGS', 'w') as f:
        json.dump(settings, f, indent=2)
    print('✓ Settings cleaned')
except:
    pass
"
    fi
    echo -e "${GREEN}✓ Uninstall complete${NC}"
    exit 0
fi

# Check Claude Code
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${RED}Error: Claude Code not found at $CLAUDE_DIR${NC}"
    echo -e "${YELLOW}Please install Claude Code first: https://claude.ai/download${NC}"
    exit 1
fi

echo -e "${CYAN}Installing Claude Code Reminder...${NC}"

# Detect OS and download appropriate script
if [[ "$OSTYPE" == "darwin"* ]]; then
    SCRIPT_NAME="overseer_macos.py"
    PYTHON_CMD="python3"
else
    SCRIPT_NAME="overseer_linux.py"
    PYTHON_CMD="python3"
fi

# Download script
SCRIPT_URL="$GITHUB_RAW/scripts/$SCRIPT_NAME"
if command -v curl &> /dev/null; then
    curl -fsSL "$SCRIPT_URL" -o "$HOOK_FILE" 2>/dev/null && \
    echo -e "${GREEN}✓ Downloaded $SCRIPT_NAME${NC}" || {
        echo -e "${YELLOW}Using embedded script...${NC}"
        # Fallback: embed the appropriate script
        if [[ "$OSTYPE" == "darwin"* ]]; then
            cat > "$HOOK_FILE" << 'EOF'
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Claude Code Reminder for macOS"""

import json
import sys
import subprocess
import os
import locale

def get_project_name():
    try:
        cwd = os.getcwd()
        project = os.path.basename(cwd)
        if not project or project in ['/', 'root', 'home']:
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

def speak(text, lang='en'):
    try:
        if lang == 'zh':
            voice_args = ['-v', 'Ting-Ting', '-r', '200']
        else:
            voice_args = ['-r', '200']
        subprocess.Popen(['say'] + voice_args + [text], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
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
EOF
        else
            # Linux version
            cat > "$HOOK_FILE" << 'EOF'
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Claude Code Reminder for Linux"""

import json
import sys
import subprocess
import os

def get_project_name():
    try:
        cwd = os.getcwd()
        project = os.path.basename(cwd)
        if not project or project in ['/', 'root', 'home']:
            return "Claude"
        return project
    except:
        return "Claude"

def speak(text):
    try:
        subprocess.Popen(['espeak', '-s', '160', text], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return
    except:
        pass
    try:
        subprocess.Popen(['spd-say', text], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except:
        pass

def main():
    try:
        data = json.load(sys.stdin)
        event = data.get("hook_event_name", "")
        
        if event not in ["Notification", "Stop"]:
            sys.exit(0)
        
        project = get_project_name()
        messages = {
            'Notification': f"{project} needs confirmation",
            'Stop': f"{project} task completed"
        }
        
        message = messages.get(event)
        if message:
            speak(message)
    except:
        pass
    
    sys.exit(0)

if __name__ == "__main__":
    main()
EOF
        fi
    }
fi

chmod +x "$HOOK_FILE"

# Update settings.json
$PYTHON_CMD << EOF
import json
import os

settings_path = "$SETTINGS"
settings = {}

if os.path.exists(settings_path):
    with open(settings_path, 'r') as f:
        settings = json.load(f)
else:
    settings = {"\$schema": "https://json.schemastore.org/claude-code-settings.json"}

if 'hooks' not in settings:
    settings['hooks'] = {}

hook_config = [{
    "hooks": [{
        "type": "command",
        "command": "$PYTHON_CMD \"$HOOK_FILE\"",
        "timeout": 3
    }]
}]

settings['hooks']['Notification'] = hook_config
settings['hooks']['Stop'] = hook_config

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)

print("✓ Settings updated")
EOF

# Test
echo -e "\n${GREEN}✅ Installation complete!${NC}"
echo -e "\n${YELLOW}Testing voice notification...${NC}"
echo '{"hook_event_name":"Stop"}' | $PYTHON_CMD "$HOOK_FILE"
echo -e "${GRAY}You should hear 'Claude task completed'${NC}"

echo -e "\n${CYAN}To uninstall: ./install.sh --uninstall${NC}"