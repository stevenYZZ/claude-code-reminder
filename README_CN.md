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

## 🎯 痛点问题

当你同时使用多个 Claude Code 处理不同项目时，可能会遇到：

🖥️ **在另一个屏幕写代码** → 不知道 Claude 已经完成  
📁 **管理多个终端** → 不确定哪个需要关注  
☕ **暂时离开工位** → 错过重要的确认提示  

## ✨ 解决方案

**Claude Code Reminder** 为你的终端赋予声音！获得即时语音通知：

- 🎵 **"backend 任务完成"** - 准确知道哪个项目完成了
- 🔊 **"frontend 等待确认"** - 再也不会错过提示
- 🎯 **自定义消息** - 每个通知都有清晰的上下文

## 🚀 快速开始

### Windows 安装 (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/install.ps1 | iex
```

### macOS 安装

```bash
curl -fsSL https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/install.sh | bash
```

## 📖 工作原理

想象一下管理多个 Claude Code 会话的场景：

```
┌─────────────────────────────────────────────────────┐
│ 终端 1: E:\backend                                 │
│ > claude "重构认证系统"                              │
│ 🔄 处理中...                                        │
├─────────────────────────────────────────────────────┤
│ 终端 2: E:\frontend                                │
│ > claude "优化首页性能"                              │
│ 🔄 处理中...                                        │
├─────────────────────────────────────────────────────┤
│ 终端 3: E:\docs                                    │
│ > claude "更新API文档"                              │
│ 🔄 处理中...                                        │
└─────────────────────────────────────────────────────┘

                     ↓ 稍后 ↓

     🔊 "backend: 任务完成"        ← 终端1完成了！
     🔊 "frontend: 等待确认"      ← 终端2需要你！
```

## 🎯 适用场景

| 使用场景 | 说明 |
|----------|------|
| **🖥️ 多终端管理** | 同时运行多个 Claude Code 会话 |
| **⏱️ 长时间任务** | 大型重构、测试套件或构建过程 |
| **🖥️ 多显示器** | 跨不同屏幕和工作区工作 |
| **🚀 效率提升** | 最大化 Claude Code 使用效率 |

## ⚙️ 核心特性

- ✅ **自动检测** - 适用于任何 Claude Code 命令
- ✅ **智能上下文** - 通知中包含工作目录信息
- ✅ **跨平台支持** - 原生支持 Windows 和 macOS
- ✅ **零配置** - 开箱即用
- ✅ **轻量级** - 极低的资源占用

## 🛠️ 高级配置

### 自定义语音设置

工具会自动检测系统语言：
- 🇨🇳 **中文系统** - 使用中文语音播报
- 🇺🇸 **英文系统** - 使用英文语音播报

### 支持的事件

| 事件类型 | 触发时机 |
|---------|---------|
| **Notification** | Claude Code 发送通知时 |
| **Stop** | 任务完成或停止时 |

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