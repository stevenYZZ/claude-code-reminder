#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Claude Code Overseer for macOS
Voice notifications when Claude Code needs attention
"""

import json
import sys
import subprocess
import os
import locale

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

def detect_language():
    """Detect system language"""
    try:
        lang = locale.getdefaultlocale()[0]
        if lang and 'zh' in lang.lower():
            return 'zh'
        return 'en'
    except:
        return 'en'

def speak(text, lang='en'):
    """macOS voice notification using say command"""
    try:
        # Choose voice and rate based on language
        if lang == 'zh':
            # Chinese voice (if available)
            voice_args = ['-v', 'Ting-Ting', '-r', '200']
        else:
            # Default English voice
            voice_args = ['-r', '200']
        
        subprocess.Popen(
            ['say'] + voice_args + [text],
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
        
        # Get project name and language
        project = get_project_name()
        lang = detect_language()
        
        # Generate message
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
        # Silent fail
        pass
    
    sys.exit(0)

if __name__ == "__main__":
    main()