<div align="center">

[中文](README.md) ｜ **English**

# 🚀 Claude Code One-Click Installer & Guide

A hand-holding setup guide for total beginners — install · use your own API · add web search

![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS-CC785C?style=flat-square)
![Setup](https://img.shields.io/badge/Setup-One--Click-3F7A4E?style=flat-square)
![Beginner](https://img.shields.io/badge/Beginner-Friendly-E8A04C?style=flat-square)
[![Powered by Claude Code](https://img.shields.io/badge/Powered%20by-Claude%20Code-CC785C?style=flat-square&logo=anthropic&logoColor=white)](https://claude.com/claude-code)
[![Live Guide](https://img.shields.io/website?url=https%3A%2F%2Fericarcha.github.io%2Fclaude-code-oneclick%2F&style=flat-square&label=Live%20Guide&up_message=online&up_color=3F7A4E&down_message=building)](https://ericarcha.github.io/claude-code-oneclick/)
[![Stars](https://img.shields.io/github/stars/EricArcha/claude-code-oneclick?style=flat-square&color=CC785C)](https://github.com/EricArcha/claude-code-oneclick/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/EricArcha/claude-code-oneclick?style=flat-square&color=E8A04C)](https://github.com/EricArcha/claude-code-oneclick/commits/main)

### 🌐 [Open the visual guide in your browser →](https://ericarcha.github.io/claude-code-oneclick/)

No download needed — it opens right in the browser (with a Windows / macOS switch and one-click copy).

</div>

Installing and configuring Claude Code can feel intimidating for newcomers. This repo turns it into a **plain-language, one-click, repeatable** guide. Copy → paste → Enter, and in three steps you'll have an AI that lives on your computer and can actually do things for you.

---

## 0. First, learn to open a terminal

Every step below is just: **copy** one line of command into a little window called a "terminal", then press **Enter**.

- **macOS** — it's called "Terminal": press `⌘ Command` + `Space`, type "terminal", hit Enter.
- **Windows** — use "PowerShell": press the `⊞ Win` key, type "powershell", click "Windows PowerShell".

**How to run a command?** Copy it → paste into the terminal (macOS: `⌘V`; Windows PowerShell: **right-click** or `Ctrl+V`) → press Enter.
(`cmd` is also a command window, but please use **PowerShell** for this guide.)

---

## Start with a "health check" (recommended)

See what's already installed and what's missing — finished steps can be skipped. Finish all three steps for a little easter egg 🎉

```bash
# macOS / Linux
bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/check-env.sh)
```
```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/check-env.ps1 | iex
```

---

## Step 1 · Install the latest Claude Code

The native install auto-updates in the background later — no manual upgrades needed.

```bash
# macOS / Linux
curl -fsSL https://claude.ai/install.sh | bash
```
```powershell
# Windows (PowerShell)
irm https://claude.ai/install.ps1 | iex
```
After installing, **close and reopen** the terminal, then run `claude --version` — if you see a version number, you're set.

Trouble installing? Fallback (needs Node.js 18+): `npm install -g @anthropic-ai/claude-code`

---

## Step 2 · Configure your own API (skip the official login, re-runnable)

Paste your **API base URL** and **key** when prompted. The script safely writes them into `~/.claude/settings.json` (it won't touch your other settings, and the key is never echoed). **Want to switch providers? Just run it again.**

```bash
# macOS / Linux
bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/config-api.sh)
```
```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/config-api.ps1 | iex
```

> Advanced: to switch between multiple APIs from a GUI, see **cc-switch** in Step 5.

---

## Step 3 · Add web search

First grab a free key (either one, or both):

| Service | Best for | Free tier | Sign up |
|---------|----------|-----------|---------|
| **Tavily** | Real-time web retrieval (latest / facts) | 1,000 calls/month, no credit card | <https://app.tavily.com> |
| **Exa** | Semantic search (similar content / research) | $10 credit for new accounts | <https://dashboard.exa.ai> |

```bash
# macOS / Linux
bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/setup-search-mcp.sh)
```
```powershell
# Windows (PowerShell)
irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/setup-search-mcp.ps1 | iex
```

> Can't reach the sites to get a key? **Don't get stuck here** — skip it for now; local backup notes are in [`docs/tavily.md`](docs/tavily.md) and [`docs/exa.md`](docs/exa.md). Come back later.

Three steps done — type `claude` to start your first conversation. **You are a CC Genius! 🎉**

---

## Optional · Power-ups

### Step 4 · Feishu / Lark CLI (needs Node.js)
Bring Feishu docs, sheets, calendar, etc. into Claude Code. See [`docs/lark-cli.md`](docs/lark-cli.md).
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-lark.sh)      # macOS/Linux
irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-lark.ps1 | iex             # Windows
```

### Step 5 · cc-switch (GUI to switch backend APIs)
See [`docs/cc-switch.md`](docs/cc-switch.md).
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-cc-switch.sh) # macOS/Linux
irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-cc-switch.ps1 | iex         # Windows
```

---

## Repository structure

```
claude-code-oneclick/
├── index.html            # The visual guide (landing page, double-click to open)
├── scripts/              # One-click scripts (.sh = macOS/Linux, .ps1 = Windows)
│   ├── check-env.*       # Environment health check + easter egg
│   ├── install-cc.*      # Install Claude Code
│   ├── config-api.*      # Configure your own API (re-runnable)
│   ├── setup-search-mcp.* # Configure Tavily / Exa search
│   ├── install-lark.*    # Optional: Feishu/Lark CLI
│   └── install-cc-switch.* # Optional: cc-switch
├── docs/                 # Local backup docs for each tool (in case sites are blocked)
│   └── tavily.md · exa.md · lark-cli.md · cc-switch.md
├── README.md             # Chinese (default)
└── README.en.md          # English
```

## FAQ

- **Will my key leak?** No. The key is only written to your local `~/.claude/settings.json`; this repo and its scripts never upload or collect any keys.
- **Can I change API providers?** Yes — just re-run the Step 2 command to overwrite.
- **A site won't open during a step?** Skip it, read the matching backup in `docs/`, and come back later. It won't block the other steps.

## Security note
All commands come from official sources; the scripts only install and configure locally — they collect and upload nothing.
