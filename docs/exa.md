# Exa 本地备份说明

> 用途：给 Claude Code 配置「语义 / 神经搜索」能力。
> 当官网打不开时，照本文也能完成配置。最新信息以官方为准。

## 一句话
Exa 是基于神经网络（embeddings）的**语义搜索**引擎：理解查询「含义」，找出概念上相似的网页，并有论文、公司、人物、GitHub 代码等专门索引。适合「做研究 / 找相似内容 / 发现式检索」。

## 免费额度
- 新账号完成 onboarding 赠送 **$10 额度**。
- 绑定支付方式后，每个自然月初再送 **$7 额度**（当月有效）。
- 官网亦以「每月最多约 20,000 次请求免费」描述同一额度（两种说法是同一份免费额度，不叠加）。

## 注册拿 Key（3 步）
1. 打开 <https://dashboard.exa.ai> 注册并登录（onboarding：<https://dashboard.exa.ai/onboarding>）。
2. 进入 **API Keys** 页：<https://dashboard.exa.ai/api-keys>。
3. 复制你的 **API Key**。

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

手动方式 A —— 本地运行（需要 Node.js，对新手更稳，避免浏览器授权）：
```bash
claude mcp add exa --scope user --env EXA_API_KEY=<KEY> -- npx -y exa-mcp-server
```

手动方式 B —— 远程端点（备选）：
```bash
claude mcp add exa --transport http https://mcp.exa.ai/mcp
```

验证：
```bash
claude mcp list
```

## 移除 / 重配
```bash
claude mcp remove exa
```

## 官方链接
- 官网：<https://exa.ai>
- 文档：<https://exa.ai/docs>（`docs.exa.ai` 会跳转到这里）
- MCP 文档：<https://exa.ai/docs/reference/exa-mcp>
- 控制台：<https://dashboard.exa.ai>
- 远程 MCP 端点：`https://mcp.exa.ai/mcp`
- 本地 npm 包：`npx -y exa-mcp-server`（需环境变量 `EXA_API_KEY`）

## Exa vs Tavily 怎么选？
- **找相似、做研究** → Exa。
- **查最新、要事实** → Tavily（见 [tavily.md](./tavily.md)）。
- 两个都配也不冲突。
