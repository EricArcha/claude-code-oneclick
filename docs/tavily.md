# Tavily 本地备份说明

> 用途：给 Claude Code 配置「实时联网搜索」能力。
> 当官网打不开时，照本文也能完成配置。最新信息以官方为准。

## 一句话
Tavily 是为 AI 优化的**实时网页检索**服务：返回干净、最新、可直接喂给 AI 的搜索结果。适合「查最新消息 / 找事实 / 做 RAG」。

## 免费额度
- 每月 **1000 次 API Credits**，**免信用卡**。

## 注册拿 Key（3 步）
1. 打开 <https://app.tavily.com> 注册并登录。
2. 进入控制台首页（<https://app.tavily.com/home>）。
3. 复制页面上的 **API Key**（形如 `tvly-...`）。

## 配置到 Claude Code
推荐用本项目一键脚本（自动执行下面的命令）：
- macOS / Linux：
  ```bash
  bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/setup-search-mcp.sh)
  ```
- Windows（PowerShell）：
  ```powershell
  irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/setup-search-mcp.ps1 | iex
  ```

手动方式（远程 HTTP，把 `<KEY>` 换成你的 Key）：
```bash
claude mcp add tavily-remote --scope user --transport http "https://mcp.tavily.com/mcp/?tavilyApiKey=<KEY>"
```

验证：
```bash
claude mcp list
```

## 移除 / 重配
```bash
claude mcp remove tavily-remote
```

## 官方链接
- 官网：<https://www.tavily.com>
- 文档：<https://docs.tavily.com>
- MCP 文档：<https://docs.tavily.com/documentation/mcp>
- MCP 源码：<https://github.com/tavily-ai/tavily-mcp>
- 远程 MCP 端点：`https://mcp.tavily.com/mcp/`
- 本地 npm 包（备选）：`npx -y tavily-mcp`

## Tavily vs Exa 怎么选？
- **查最新、要事实** → Tavily。
- **找相似、做研究** → Exa（见 [exa.md](./exa.md)）。
- 两个都配也不冲突，让 Claude Code 按需调用。
