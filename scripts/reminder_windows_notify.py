#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Claude Code Reminder for Windows - System Notification Version
Visual notifications when Claude Code needs attention
"""

import json
import sys
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

def send_notification(title, message):
    """发送系统通知"""
    try:
        # 尝试使用 plyer
        from plyer import notification
        
        # 根据事件类型选择图标
        icon_path = None  # 可以添加自定义图标路径
        
        notification.notify(
            title=title,
            message=message,
            app_name='Claude Code Reminder',
            timeout=10,  # 通知显示10秒
            app_icon=icon_path  # 可选的图标路径
        )
        return True
    except ImportError:
        # 如果 plyer 未安装，回退到 Windows 10 Toast 通知
        try:
            from win10toast import ToastNotifier
            toaster = ToastNotifier()
            toaster.show_toast(
                title,
                message,
                duration=10,
                threaded=True
            )
            return True
        except ImportError:
            # 如果都没安装，使用 Windows 原生通知
            try:
                import subprocess
                # 使用 PowerShell 的 BurntToast 模块（如果已安装）
                ps_cmd = f'''
                [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
                [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType = WindowsRuntime] | Out-Null
                
                $template = @"
                <toast>
                    <visual>
                        <binding template="ToastGeneric">
                            <text>{title}</text>
                            <text>{message}</text>
                        </binding>
                    </visual>
                    <audio src="ms-winsoundevent:Notification.Default"/>
                </toast>
"@
                
                $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
                $xml.LoadXml($template)
                $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
                [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Claude Code Reminder").Show($toast)
                '''
                
                subprocess.run(
                    ['powershell', '-WindowStyle', 'Hidden', '-Command', ps_cmd],
                    capture_output=True
                )
                return True
            except:
                pass
    
    return False

def speak_fallback(text):
    """语音播报作为后备方案"""
    try:
        import subprocess
        ps_cmd = f'''
        $voice = New-Object -ComObject SAPI.SpVoice
        $voice.Rate = 2
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
            titles = {
                'Notification': '⏸️ Claude Code 需要确认',
                'Stop': '✅ Claude Code 任务完成'
            }
            messages = {
                'Notification': f"{project} 项目等待您的确认",
                'Stop': f"{project} 项目的任务已完成"
            }
            voice_messages = {
                'Notification': f"{project} 等待确认",
                'Stop': f"{project} 任务完成"
            }
        else:
            titles = {
                'Notification': '⏸️ Claude Code Needs Attention',
                'Stop': '✅ Claude Code Task Completed'
            }
            messages = {
                'Notification': f"{project} project needs your confirmation",
                'Stop': f"{project} project task has been completed"
            }
            voice_messages = {
                'Notification': f"{project} needs confirmation",
                'Stop': f"{project} task completed"
            }
        
        title = titles.get(event)
        message = messages.get(event)
        voice_message = voice_messages.get(event)
        
        if title and message:
            # 优先尝试发送系统通知
            notification_sent = send_notification(title, message)
            
            # 如果通知发送失败，使用语音作为后备
            if not notification_sent and voice_message:
                speak_fallback(voice_message)
            
    except:
        # 静默失败，不影响Claude Code
        pass
    
    sys.exit(0)

if __name__ == "__main__":
    main()