#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Claude Code Reminder for macOS
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

def get_chinese_voice():
    """Detect available Chinese voice"""
    try:
        result = subprocess.run(['say', '-v', '?'], capture_output=True, text=True)
        voices = result.stdout.lower()
        if 'tingting' in voices:
            return 'Tingting'
        elif 'ting-ting' in voices:
            return 'Ting-Ting'
        elif '丁丁' in voices or 'ding' in voices:
            return '丁丁'
    except:
        pass
    return None

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
        # Choose voice based on language
        if lang == 'zh':
            # Try to get available Chinese voice
            chinese_voice = get_chinese_voice()
            if chinese_voice:
                subprocess.call(['say', '-v', chinese_voice, text])
            else:
                # Fallback to default voice
                subprocess.call(['say', text])
        else:
            # English voice (female voice for consistency)
            subprocess.call(['say', '-v', 'Samantha', text])
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
