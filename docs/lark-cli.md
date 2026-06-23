# 飞书 CLI（lark-cli）本地备份说明

> 用途：把飞书（Lark）的能力接进 Claude Code，优化工作流。可选项，不影响主流程。
> 当官网打不开时，照本文也能完成配置。最新信息以官方为准。

## 一句话
`lark-cli` 是飞书官方命令行工具（larksuite 团队维护，「为人类与 AI Agent 而生」）：把飞书开放平台 2500+ 接口收成 200+ 条命令，覆盖消息(IM)、文档、多维表格(Base)、表格、日历、邮件、任务、会议、知识库、通讯录、云盘等约 11 个业务域；并提供可被 Claude Code / Cursor / Gemini CLI 加载的 **AI Agent Skills**。Go 编写，MIT 许可。

## 前置条件
- 需要 **Node.js 18+**（用于 `npx`）。没有就先装：<https://nodejs.org>

## 安装（3 步）
推荐用本项目一键脚本：
- macOS / Linux：
  ```bash
  bash <(curl -fsSL https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-lark.sh)
  ```
- Windows（PowerShell）：
  ```powershell
  irm https://raw.githubusercontent.com/EricArcha/claude-code-oneclick/main/scripts/install-lark.ps1 | iex
  ```

手动方式：
```bash
# 1) 安装本体（官方推荐的一键安装）
npx @larksuite/cli@latest install

# 2) 安装给 Claude Code 用的 Skills
npx skills add larksuite/cli -y -g

# 3) 登录飞书账号（浏览器授权）
lark-cli auth login --recommend
```
（也可用 `npm install -g @larksuite/cli` 全局安装本体。）

## 验证
```bash
lark-cli --help
```

## 官方链接
- 源码仓库：<https://github.com/larksuite/cli>
- 官方介绍页：<https://www.feishu.cn/feishu-cli>
- npm 包：`@larksuite/cli`

## 提示
- 安装后，飞书相关的 Skills 会出现在 Claude Code 的技能列表里，可直接让 Claude 调用（发消息、读写文档/表格、查日历等）。
- 身份切换用 `--as`；首次使用如遇权限/scope 报错，重跑 `lark-cli auth login` 并按提示授权。
