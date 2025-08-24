<div align="center">

[English](README.md) | [简体中文](README_CN.md)

# 🔔 Claude Code Reminder

### Let Claude Code call you when it needs you

[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS-blue)](https://github.com/stevenYZZ/claude-code-reminder)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-orange)](https://github.com/stevenYZZ/claude-code-reminder/releases)

*Never miss a Claude Code notification again!*

</div>

---

## 🎯 The Problem

Running multiple Claude Code terminals? You know the pain:

🔄 **The Endless Check Loop:**
```
Tab 1: Still running? ❌
Tab 2: Done yet? ❌  
Tab 3: Finally! ✅
Tab 4: Wait... finished 10 minutes ago 😭
```

⏱️ **Daily time wasted switching between terminals: 30+ minutes**

🤯 **The result:** Constant context switching, missed completions, and idle Claude instances  

## ✨ The Solution

**Claude Code Reminder** gives your terminals a voice! Get instant audio notifications:

- 🎵 **"backend task completed"** - Know exactly which project is done
- 🔊 **"frontend needs confirmation"** - Never miss a prompt again
- 🎯 **Custom messages** - Clear context for every notification

## 🚀 Quick Start

### Windows Installation (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/install.ps1 | iex
```

### macOS Installation

```bash
curl -fsSL https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/install.sh | bash
```

## 📖 How It Works

Imagine managing multiple Claude Code sessions:

```
┌─────────────────────────────────────────────────────┐
│ Terminal 1: ~/backend                              │
│ > claude "refactor authentication system"          │
│ 🔄 Working...                                      │
├─────────────────────────────────────────────────────┤
│ Terminal 2: ~/frontend                             │
│ > claude "optimize homepage performance"           │
│ 🔄 Working...                                      │
├─────────────────────────────────────────────────────┤
│ Terminal 3: ~/docs                                 │
│ > claude "update API documentation"                │
│ 🔄 Working...                                      │
└─────────────────────────────────────────────────────┘

                     ↓ Later ↓

     🔊 "backend: task completed"        ← Terminal 1 done!
     🔊 "frontend: needs confirmation"   ← Terminal 2 needs you!
```

## 🎯 Perfect For

| Use Case | Description |
|----------|-------------|
| **🖥️ Multi-Terminal** | Running multiple Claude Code sessions simultaneously |
| **⏱️ Long Tasks** | Large refactoring, test suites, or build processes |
| **🖥️ Multi-Monitor** | Working across different screens and workspaces |
| **🚀 Productivity** | Maximizing efficiency with Claude Code |

## ⚙️ Features

- ✅ **Automatic Detection** - Works with any Claude Code command
- ✅ **Smart Context** - Includes working directory in notifications
- ✅ **Cross-Platform** - Native support for Windows and macOS
- ✅ **Zero Config** - Works out of the box
- ✅ **Lightweight** - Minimal resource usage

## Manual Configuration

If the installation script doesn't work:

### Step 1: Copy Hook Script

Copy the appropriate script from `scripts/` to `~/.claude/reminder.py`:
- **Windows**: `scripts/reminder_windows.py`
- **macOS**: `scripts/reminder_macos.py`  
- **Linux**: `scripts/reminder_linux.py`

### Step 2: Update settings.json

Add to your `~/.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [{"hooks": [{"type": "command", "command": "python ~/.claude/reminder.py", "timeout": 1}]}],
    "Notification": [{"hooks": [{"type": "command", "command": "python ~/.claude/reminder.py", "timeout": 1}]}]
  }
}
```

Use `python3` on macOS/Linux, and full Windows paths like `C:/Users/USERNAME/.claude/reminder.py`.

## 🗑️ Uninstallation

### Windows
```powershell
.\install.ps1 -Uninstall
```

### macOS
```bash
./install.sh --uninstall
```

## 🤝 Contributing

Contributions are welcome! Feel free to:

- 🐛 Report bugs
- 💡 Suggest new features
- 🔧 Submit pull requests

## 📄 License

MIT License - feel free to use this in your projects!

## 🙏 Acknowledgments

Special thanks to [@vista8](https://twitter.com/vista8) for the inspiration from the zelda-claude-code project.

---

<div align="center">

**Made with ❤️ for the Claude Code community**

[Report Bug](https://github.com/stevenYZZ/claude-code-reminder/issues) · [Request Feature](https://github.com/stevenYZZ/claude-code-reminder/issues)

</div>
