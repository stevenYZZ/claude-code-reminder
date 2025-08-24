# Claude Code Reminder

Let Claude Code call you when it needs you.

## What problem does it solve?

When using Claude Code, you might be:

- Coding on another screen, unaware that Claude has finished
- Running multiple terminals, not knowing which one needs attention
- Checking other things and missing confirmation prompts

Now, Claude will tell you via voice:

- "backend task completed" - Know which project is done
- "frontend needs confirmation" - Handle it immediately

## Perfect for

- Running multiple Claude Code terminals simultaneously
- Long-running tasks (like large refactoring)
- Multi-monitor setups
- Anyone wanting to maximize Claude efficiency

## Installation

**Windows (PowerShell):**

```powershell
iwr -useb https://raw.githubusercontent.com/yourusername/claude-code-reminder/main/install.ps1 | iex
```

**macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/claude-code-reminder/main/install.sh | bash
```

## How it works

```
Terminal 1: ~/backend> claude "refactor auth"
Terminal 2: ~/frontend> claude "optimize homepage"  
Terminal 3: ~/docs> claude "update API"

[Later...]
🔊 "backend task completed"     <- Terminal 1 done
🔊 "frontend needs confirmation" <- Terminal 2 needs you
```

## Uninstall

```bash
# Windows
.\install.ps1 -Uninstall

# macOS  
./install.sh --uninstall
```

---

Inspired by [@vista8](https://twitter.com/vista8)'s zelda-claude-code project.
