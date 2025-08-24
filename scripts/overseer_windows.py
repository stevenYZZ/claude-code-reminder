#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Claude Code Overseer for Windows
Voice notifications when Claude Code needs attention
"""

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
    """获取当前项目名"""
    try:
        cwd = os.getcwd()
        project = os.path.basename(cwd)
        if not project or project in ['/', '\\', 'root', 'home']:
            return "Claude"
        return project
    except:
        return "Claude"

def detect_language():
    """检测系统语言"""
    try:
        lang = locale.getdefaultlocale()[0]
        if lang and 'zh' in lang.lower():
            return 'zh'
        return 'en'
    except:
        return 'en'

def speak(text, lang='zh'):
    """Windows语音播报"""
    try:
        # 中文语速稍快，英文正常
        rate = 2 if lang == 'zh' else 1
        
        # PowerShell调用SAPI
        ps_cmd = f'''
        $voice = New-Object -ComObject SAPI.SpVoice
        $voice.Rate = {rate}
        $voice.Speak("{text}", 1)
        '''
        
        # 后台运行，无窗口
        cmd = f'start /b "" powershell -NoProfile -WindowStyle Hidden -Command "{ps_cmd}"'
        
        subprocess.Popen(
            cmd,
            shell=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            creationflags=0x08000000  # CREATE_NO_WINDOW
        )
    except:
        pass

def main():
    try:
        # 读取Claude Code事件
        data = json.load(sys.stdin)
        event = data.get("hook_event_name", "")
        
        # 只处理关键事件
        if event not in ["Notification", "Stop"]:
            sys.exit(0)
        
        # 获取项目名和语言
        project = get_project_name()
        lang = detect_language()
        
        # 生成消息
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
        # 静默失败，不影响Claude Code
        pass
    
    sys.exit(0)

if __name__ == "__main__":
    main()