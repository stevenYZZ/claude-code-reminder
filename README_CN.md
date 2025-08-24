# Claude Code Reminder

让 Claude Code 在需要你时主动"喊"你。

## 解决什么问题？

使用 Claude Code 时，你可能：

- 在另一个屏幕写代码，不知道 Claude 完成了
- 开了多个终端，不知道哪个需要处理
- 切换去看其他东西，错过了确认提示

现在，Claude 会语音告诉你：

- "backend 任务完成" - 知道哪个项目完成了
- "frontend 等待确认" - 立即去处理

## 特别适合

- 同时运行多个 Claude Code 终端
- 需要长时间运行的任务（如大型重构）
- 多显示器工作环境
- 想最大化 Claude 使用效率的人

## 安装

**Windows (PowerShell):**

```powershell
iwr -useb https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/install.ps1 | iex
```

**macOS:**

```bash
curl -fsSL https://raw.githubusercontent.com/stevenYZZ/claude-code-reminder/master/install.sh | bash
```

## 工作原理

```
终端1: E:\backend> claude "重构认证模块"
终端2: E:\frontend> claude "优化首页"  
终端3: E:\docs> claude "更新API文档"

[稍后...]
🔊 "backend 任务完成"    <- 终端1完成了
🔊 "frontend 等待确认"   <- 终端2需要你
```

## 卸载

```bash
# Windows
.\install.ps1 -Uninstall

# macOS  
./install.sh --uninstall
```

---

灵感来自 [@vista8](https://twitter.com/vista8) 的 zelda-claude-code 项目。
