#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Claude Code Overseer for Linux
Voice notifications when Claude Code needs attention
"""

import json
import sys
import subprocess
import os

def get_project_name():
    """Get current project name"""
    try:
        cwd = os.getcwd()
        project = os.path.basename(cwd)
        if not project or project in ['/', 'root', 'home']:
            return "Claude"
        return project
    except:
        return "Claude"

def speak(text):
    """Linux voice notification using espeak or spd-say"""
    # Try espeak first
    try:
        subprocess.Popen(
            ['espeak', '-s', '160', text],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        return
    except:
        pass
    
    # Fallback to spd-say
    try:
        subprocess.Popen(
            ['spd-say', text],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
    except:
        pass

def main():
    try:
        # Read Claude Code event
        data = json.load(sys.stdin)
        event = data.get("hook_event_name", "")
        
        # Only handle key events
        if event not in ["Notification", "Stop"]:
            sys.exit(0)
        
        # Get project name
        project = get_project_name()
        
        # Generate message (English only for Linux)
        messages = {
            'Notification': f"{project} needs confirmation",
            'Stop': f"{project} task completed"
        }
        
        message = messages.get(event)
        if message:
            speak(message)
            
    except:
        # Silent fail
        pass
    
    sys.exit(0)

if __name__ == "__main__":
    main()