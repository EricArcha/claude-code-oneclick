<div align="center">

**中文** ｜ [English](README.en.md)

# 🚀 Claude Code 一键安装引导

给「电脑小白 / AI 新手」的保姆级安装配置引导 —— 装好 · 配自有 API · 联网搜索

![Platform](https://img.shields.io/badge/平台-Windows%20%7C%20macOS-CC785C?style=flat-square)
![Setup](https://img.shields.io/badge/安装-一键完成-3F7A4E?style=flat-square)
![Beginner](https://img.shields.io/badge/小白-友好-E8A04C?style=flat-square)
[![Powered by Claude Code](https://img.shields.io/badge/Powered%20by-Claude%20Code-CC785C?style=flat-square&logo=anthropic&logoColor=white)](https://claude.com/claude-code)
[![Live Guide](https://img.shields.io/website?url=https%3A%2F%2Fericarcha.github.io%2Fclaude-code-oneclick%2F&style=flat-square&label=%E5%9C%A8%E7%BA%BF%E5%BC%95%E5%AF%BC&up_message=online&up_color=3F7A4E&down_message=building)](https://ericarcha.github.io/claude-code-oneclick/)
[![Stars](https://img.shields.io/github/stars/EricArcha/claude-code-oneclick?style=flat-square&color=CC785C)](https://github.com/EricArcha/claude-code-oneclick/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/EricArcha/claude-code-oneclick?style=flat-square&color=E8A04C)](https://github.com/EricArcha/claude-code-oneclick/commits/main)

### 🌐 [点此在线打开图文引导 →](https://ericarcha.github.io/claude-code-oneclick/)

无需下载，浏览器直接看（带 Windows / macOS 切换与一键复制）

</div>

专为新手而做——**通俗、一键、可重复**，复制 → 粘贴 → 回车就行。

**装完这三步，你将得到：**

- ✅ 一个能**读写文件、跑命令**的 AI 助手，住在你自己的电脑里
- ✅ 用**你自己的 API**，跳过官方登录，随时换服务商
- ✅ 会**联网搜索**最新资料，不再只靠记忆

> ⏱️ 全程约 5 分钟 · 只需复制粘贴 · 免费起步

---

## 开始之前 · 先学会「打开终端」

下面每一步，都是把一行命令**复制**进一个叫「终端」的小窗口、再按**回车**。

- **macOS** —— 叫「终端 / Terminal」：按住 `⌘ Command` 再按 `空格`，输入「终端」或「terminal」，回车。
- **Windows** —— 用「PowerShell」：按左下角 `⊞ Win` 键，输入「powershell」，点「Windows PowerShell」打开。

**怎么运行命令？** 复制命令 → 在终端里粘贴（macOS 按 `⌘V`；Windows 的 PowerShell 里点**右键**或 `Ctrl+V`）→ 按回车。
（`cmd` 也是命令窗口，但本引导请统一用 **PowerShell**。）

---

## 先做个「体检」（推荐）

看看你的电脑已装好哪些、还差哪些，已完成的步骤可直接跳过。三步全做完会有小彩蛋 🎉

```bash
# macOS / Linux
bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/check-env.sh)
```
```powershell
# Windows（PowerShell）
irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/check-env.ps1 | iex
```

---

## 第 1 步 · 安装最新版 Claude Code

原生安装版以后会自动更新，无需手动升级。

```bash
# macOS / Linux
curl -fsSL https://claude.ai/install.sh | bash
```
```powershell
# Windows（PowerShell）
irm https://claude.ai/install.ps1 | iex
```
装完后**关闭并重新打开**终端，输入 `claude --version` 看到版本号就成功了。

装不上？备选方案（需 Node.js 18+）：`npm install -g @anthropic-ai/claude-code`

---

## 第 2 步 · 配置你自己的 API（跳过官方登录，可重复运行）

运行脚本后先选「从服务商列表选」还是「自定义」：

- **选服务商**（推荐小白）→ 只需输入 API Key，地址和模型名自动填好
- **自定义** → 手动输入地址、密钥、模型名（清楚自己在用什么）

内置服务商预设：

| 服务商 | 模型名 | 备注 |
|--------|--------|------|
| DeepSeek（深度求索） | `deepseek-v4-pro[1m]` | V4 Pro+Flash 均 1M 上下文，`[1m]` 是 CC 长上下文标记 |
| Kimi（月之暗面） | `kimi-k2.7-code` | |
| 智谱 GLM | `glm-5.1` | |
| 阿里百炼 | 无需指定 | 百炼自动路由，不设模型名 |
| 豆包 Seed | `doubao-seed-2-0-code-preview-latest` | |
| MiniMax | `MiniMax-M2.7` | |

> **模型名是什么？** 告诉 Claude Code 该调用哪个模型。不设模型名可能导致启动报错——服务商不认识 CC 的默认模型名。脚本会自动把模型名 + 地址 + 密钥一起写进配置文件。

```bash
# macOS / Linux
bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/config-api.sh)
```
```powershell
# Windows（PowerShell）
irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/config-api.ps1 | iex
```

> 进阶：想在多个 API 间图形化一键切换，见第 5 步的 **cc-switch**。

更多服务商的模型名与配置参数见 [`docs/llm-providers.md`](docs/llm-providers.md)。

---

## 第 3 步 · 给它装上「联网搜索」

先免费注册拿 Key（任选其一或都拿）：

| 服务 | 擅长 | 免费额度 | 注册 |
|------|------|----------|------|
| **Tavily** | 实时网页检索（查最新/找事实） | 每月 1000 次、免信用卡 | <https://app.tavily.com> |
| **Exa** | 语义搜索（找相似/做研究） | 新号送 $10 额度 | <https://dashboard.exa.ai> |

```bash
# macOS / Linux
bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/setup-search-mcp.sh)
```
```powershell
# Windows（PowerShell）
irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/setup-search-mcp.ps1 | iex
```

> 官网打不开拿不到 Key？**别卡在这**——先跳过，本地备份说明见 [`docs/tavily.md`](docs/tavily.md)、[`docs/exa.md`](docs/exa.md)，回头再配。

三步完成，输入 `claude` 即可开始第一段对话。**You are a CC Genius! 🎉**

---

## 可选 · 进阶增强

### 第 4 步 · 飞书 CLI（需 Node.js）
把飞书文档、表格、日历等接进 Claude Code。详见 [`docs/lark-cli.md`](docs/lark-cli.md)。
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-lark.sh)      # macOS/Linux
irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-lark.ps1 | iex             # Windows
```

### 第 5 步 · cc-switch（图形界面切换后台 API）
详见 [`docs/cc-switch.md`](docs/cc-switch.md)。
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-cc-switch.sh) # macOS/Linux
irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-cc-switch.ps1 | iex         # Windows
```

---

## 仓库结构

```
claude-code-oneclick/
├── index.html            # 网页版引导（门面，双击即开）
├── scripts/              # 一键脚本（.sh = macOS/Linux，.ps1 = Windows）
│   ├── check-env.*       # 环境体检 + 彩蛋
│   ├── install-cc.*      # 安装 Claude Code
│   ├── config-api.*      # 配置自有 API（可重复运行）
│   ├── setup-search-mcp.* # 配置 Tavily / Exa 搜索
│   ├── install-lark.*    # 可选：飞书 CLI
│   └── install-cc-switch.* # 可选：cc-switch
├── docs/                 # 各工具本地备份文档（防官网打不开堵塞）
│   └── tavily.md · exa.md · lark-cli.md · cc-switch.md
├── README.md             # 中文说明（默认）
└── README.en.md          # English
```

## 常见问题

- **会泄露我的密钥吗？** 不会。密钥只写在你本机的 `~/.claude/settings.json`，本仓库与脚本不上传、不收集任何密钥。
- **可以换 API 服务商吗？** 可以，随时重跑第 2 步的命令即可覆盖。
- **某一步官网打不开怎么办？** 先跳过，去 `docs/` 看对应本地备份，回头再配，不影响其它步骤。

## 安全说明
所有命令均来自官方渠道；脚本仅做安装与本地配置，不收集、不上传任何凭据。
