<div align="center">

[English](README.md) | [简体中文](README_CN.md)

# 🔔 Claude Code Reminder

### 让 Claude Code 在需要你时主动"喊"你

[![平台](https://img.shields.io/badge/平台-Windows%20%7C%20macOS-blue)](https://github.com/stevenYZZ/claude-code-reminder)
[![许可证](https://img.shields.io/badge/许可证-MIT-green)](LICENSE)
[![版本](https://img.shields.io/badge/版本-1.0.0-orange)](https://github.com/stevenYZZ/claude-code-reminder/releases)

*再也不错过 Claude Code 的任何通知！*

</div>

---

## 🎯 真实痛点

如果你也同时开5个 Claude Code，一定懂这种痛苦：

🔄 **每隔几分钟就要挨个检查：**

```
终端1：还在跑吗？❌ 还在跑
终端2：完成了吗？❌ 还在跑  
终端3：这个呢？✅ 终于找到一个！
终端4：等等...10分钟前就完成了 😭
```

⏱️ **每天浪费在"切换查看"的时间 ≥ 30分钟**

🤯 **结果就是：** Claude 在那闲着，你在这瞎找着

## ✨ 我的解决方案

让 Claude Code 主动通知你！**Claude Code Reminder** 提供两种通知方式：

### 🆕 系统通知（默认推荐）
- 📱 **Windows 10/11 原生通知** - 现代化的弹窗通知，带图标
- 🎯 **视觉提醒** - 不打断工作流，一眼看清哪个项目需要处理
- 🔕 **遵循勿扰模式** - 跟随 Windows 通知设置

### 🔊 语音通知（经典版）
- 🗣️ **"backend 任务完成"** - 语音播报具体项目名
- 🌍 **中英双语** - 自动识别系统语言
- ⚡ **适合离开屏幕** - 在别处工作时也不会错过

## 🚀 快速开始

### Windows 安装 (PowerShell)

```powershell
# 默认：系统通知版（推荐）
iwr -useb https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/install.ps1 | iex

# 可选：安装依赖以获得最佳体验
pip install plyer
```

### macOS 安装

```bash
curl -fsSL https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/install.sh | bash
```

### 高级选项

```powershell
# 使用语音通知版本
.\install_notify.ps1 -Voice

# 自动安装依赖
.\install_notify.ps1 -InstallDeps
```

## 📖 实际效果

之前的工作流程 😫：

```
你：开5个终端同时跑任务
你：切到终端1看看... 没完成
你：切到终端2看看... 还在跑
你：切到终端3看看... 还在跑
你：算了先干别的...
（10分钟后）
你：再看看终端1... 卧槽，早就完成了！
```

现在的工作流程 😎：

```
你：开5个终端同时跑任务
你：专心写其他代码
🔊："backend 任务完成"
你：立即切换处理
🔊："frontend 等待确认"  
你：马上去确认
效率直接拉满！
```

## 🎯 谁需要这个工具？

✅ **你是 Claude Code 多开党** - 同时跑3个以上终端
✅ **经常跑长任务** - 重构、测试、批量处理
✅ **多屏工作** - Claude 在副屏，经常忘记看
✅ **追求效率** - 不想浪费时间在切换查看上

## ⚙️ 为什么选择这个？

- 🎯 **双通知模式** - 系统通知或语音播报，随你选择
- 📱 **现代化体验** - Windows 原生通知，美观不突兀
- 🚀 **30秒安装** - 一行命令搞定，不用配置
- 🌍 **中英双语** - 自动识别系统语言
- 💡 **超轻量** - 不影响 Claude Code 性能
- 🆓 **完全开源** - 代码透明，放心使用
- 🔄 **智能降级** - 缺少依赖时自动回退

## 手动配置

如果脚本无法正常工作：

### 步骤 1：复制脚本

将对应脚本从 `scripts/` 复制到 `~/.claude/reminder.py`：
- **Windows（通知版）**: `scripts/reminder_windows_notify.py`（推荐）
- **Windows（语音版）**: `scripts/reminder_windows.py`
- **macOS**: `scripts/reminder_macos.py`  
- **Linux**: `scripts/reminder_linux.py`

### 步骤 2：更新设置

在 `~/.claude/settings.json` 中添加：

```json
{
  "hooks": {
    "Stop": [{"hooks": [{"type": "command", "command": "python ~/.claude/reminder.py", "timeout": 1}]}],
    "Notification": [{"hooks": [{"type": "command", "command": "python ~/.claude/reminder.py", "timeout": 1}]}]
  }
}
```

Windows 用户使用 `python`，macOS/Linux 使用 `python3`，并将路径改为完整 Windows 路径格式如 `C:/Users/USERNAME/.claude/reminder.py`

### 步骤 3：测试

运行任意 Claude Code 命令并等待完成，你应该能听到语音提醒！

### 常见问题

**Q: 没有听到声音怎么办？**
- Windows：确保系统音量已开启，SAPI 服务正常
- macOS：检查系统偏好设置中的语音功能
- 检查 Python 是否正确安装：在命令行运行 `python --version`

**Q: 如何自定义语音？**
- 修改脚本中的 `Rate` 值调整语速（0-10，默认2）
- macOS 可更换 `voice` 参数使用不同语音

## 🗑️ 卸载

### Windows

```powershell
.\install.ps1 -Uninstall
```

### macOS

```bash
./install.sh --uninstall
```

## 🤝 贡献

欢迎贡献！你可以：

- 🐛 报告问题
- 💡 提出新功能建议
- 🔧 提交 Pull Request

## 📄 许可证

MIT 许可证 - 可自由用于你的项目！

## 🙏 致谢

特别感谢 [@vista8](https://twitter.com/vista8) 的 zelda-claude-code 项目带来的灵感。

---

<div align="center">

**为 Claude Code 社区用 ❤️ 制作**

[报告问题](https://github.com/stevenYZZ/claude-code-reminder/issues) · [功能建议](https://github.com/stevenYZZ/claude-code-reminder/issues)

</div>
