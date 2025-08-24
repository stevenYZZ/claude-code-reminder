#!/bin/bash
# Claude Code Reminder - macOS/Linux Installation

CLAUDE_DIR="$HOME/.claude"
HOOK_FILE="$CLAUDE_DIR/reminder.py"
SETTINGS="$CLAUDE_DIR/settings.json"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# Uninstall
if [[ "$1" == "--uninstall" ]] || [[ "$1" == "-u" ]]; then
    echo -e "${YELLOW}Uninstalling Claude Code Reminder...${NC}"
    
    # Backup before uninstall
    if [ -f "$SETTINGS" ]; then
        BACKUP_FILE="$SETTINGS.uninstall_backup_$(date +%Y%m%d_%H%M%S)"
        cp "$SETTINGS" "$BACKUP_FILE"
        echo -e "${GREEN}✓ Backed up settings to: $BACKUP_FILE${NC}"
        
        # Remove hooks
        python3 -c "
import json
with open('$SETTINGS', 'r') as f:
    settings = json.load(f)
if 'hooks' in settings:
    settings['hooks'].pop('Stop', None)
    settings['hooks'].pop('Notification', None)
with open('$SETTINGS', 'w') as f:
    json.dump(settings, f, indent=2)
"
    fi
    
    # Remove hook file
    [ -f "$HOOK_FILE" ] && rm -f "$HOOK_FILE"
    
    echo -e "${GREEN}✓ Uninstall complete${NC}"
    exit 0
fi

# Check Claude Code
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${RED}Error: Claude Code not found${NC}"
    exit 1
fi

echo -e "${CYAN}Installing Claude Code Reminder...${NC}"

# Download hook script from GitHub
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    SCRIPT_URL="https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/scripts/reminder_macos.py"
else
    # Linux
    SCRIPT_URL="https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/scripts/reminder_linux.py"
fi

if curl -fsSL "$SCRIPT_URL" -o "$HOOK_FILE"; then
    echo -e "${GREEN}✓ Downloaded hook script from GitHub${NC}"
else
    echo -e "${RED}Error: Failed to download script from GitHub${NC}"
    echo -e "${YELLOW}Please check your internet connection${NC}"
    exit 1
fi

chmod +x "$HOOK_FILE"
echo -e "${GREEN}✓ Created hook script${NC}"

# Backup existing settings
if [ -f "$SETTINGS" ]; then
    BACKUP_FILE="$SETTINGS.backup_$(date +%Y%m%d_%H%M%S)"
    cp "$SETTINGS" "$BACKUP_FILE"
    echo -e "${GREEN}✓ Backed up settings to: $BACKUP_FILE${NC}"
fi

# Update settings
python3 << EOF
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

# Add Stop and Notification hooks
hookConfig = [{
    "hooks": [{
        "type": "command",
        "command": "python3 \"$HOOK_FILE\"",
        "timeout": 1
    }]
}]

settings['hooks']['Stop'] = hookConfig
settings['hooks']['Notification'] = hookConfig

with open(settings_path, 'w') as f:
    json.dump(settings, f, indent=2)
EOF

echo -e "${GREEN}✓ Settings updated${NC}"

echo -e "\n${GREEN}✅ Installation complete!${NC}"
echo -e "${CYAN}Claude Code will now announce when tasks complete.${NC}"
echo -e "\n${GRAY}To uninstall: ./install.sh --uninstall${NC}"