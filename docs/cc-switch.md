# cc-switch 本地备份说明

> 用途：在多个后台 API / 多个 AI 编码工具之间一键切换。可选 · 进阶项，不影响主流程。
> 当官网打不开时，照本文也能完成安装。最新信息以官方为准。

## 一句话
`cc-switch` 是一个**跨平台图形界面桌面 App**（Tauri 2 + React + Rust），一站式管理多个 AI 编码工具——Claude Code、Claude Desktop、Codex、Gemini CLI、OpenCode 等。核心能力：一键切换服务商 / API 配置、统一管理 MCP、多套系统提示词预设、Skills 发现与安装、配置备份恢复、API 端点测速、本地代理网关与故障转移、用量看板，以及 `ccswitch://` 深链。

## 什么时候需要它？
- 只用**一个固定 API** → 本项目的 `config-api` 脚本就够了，不必装它。
- 需要**经常在多家 API / 多个工具间来回切** → cc-switch 的图形界面更省心。

## 安装
推荐用本项目一键脚本：
- macOS / Linux：
  ```bash
  bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-cc-switch.sh)
  ```
- Windows（PowerShell）：
  ```powershell
  irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-cc-switch.ps1 | iex
  ```

手动方式：
- **macOS**：`brew install --cask cc-switch`，或从发布页下载 `.dmg`。
- **Windows 10+**：从发布页下载 `.msi` 安装，或便携版 ZIP。
- **Arch Linux**：`paru -S cc-switch-bin`。
- **其他 Linux**：发布页有 DEB / RPM / AppImage。

发布页：<https://github.com/farion1231/cc-switch/releases>

## 平台支持
Windows 10+、macOS 12+、主流 Linux（Ubuntu 22.04+ / Debian 11+ / Fedora 34+）。

## 官方链接
- 官网：<https://ccswitch.io>
- 源码仓库：<https://github.com/farion1231/cc-switch>
- （社区 CLI/TUI 分支，进阶可了解：<https://github.com/saladday/cc-switch-cli>）

## 提示
安装后从「应用程序 / 启动台」（macOS）或「开始菜单」（Windows）打开，在图形界面里添加并切换你的多套 API 配置即可。
