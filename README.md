<div align="center">

# 🔔 Claude Code Overseer

### Let Claude Code call you when it needs you

[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS-blue)](https://github.com/stevenYZZ/claude-code-reminder)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Version](https://img.shields.io/badge/version-1.0.0-orange)](https://github.com/stevenYZZ/claude-code-reminder/releases)

*Never miss a Claude Code notification again!*

</div>

---

## 🎯 The Problem

When working with Claude Code across multiple projects, you might be:

🖥️ **Coding on another screen** → Missing when Claude finishes  
📁 **Managing multiple terminals** → Unsure which needs attention  
☕ **Taking a break** → Missing important confirmation prompts  

## ✨ The Solution

**Claude Code Overseer** gives your terminals a voice! Get instant audio notifications:

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
