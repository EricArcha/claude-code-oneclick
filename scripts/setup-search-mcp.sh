#!/usr/bin/env bash
# setup-search-mcp.sh — 一键给 Claude Code 配置联网搜索能力（Tavily / Exa）
# 用法：bash setup-search-mcp.sh
set -euo pipefail

BLUE='\033[1;34m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'; NC='\033[0m'
say()  { printf "${BLUE}▶ %s${NC}\n" "$1"; }
ok()   { printf "${GREEN}✓ %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}! %s${NC}\n" "$1"; }
err()  { printf "${RED}✗ %s${NC}\n" "$1"; }

if ! command -v claude >/dev/null 2>&1; then
  err "还没找到 claude 命令。请先运行 install-cc.sh 安装 Claude Code，再回来配置搜索。"
  exit 1
fi

echo ""
say "给 Claude Code 装上「联网搜索」"
cat <<'TXT'
  搜索有两家免费服务，可以都配，也可以只配一个：

  • Tavily —— 实时网页检索，把最新、干净的事实喂给 AI。适合「查最新消息/事实」。
      免费额度：每月 1000 次，免信用卡。
      注册拿 Key： https://app.tavily.com
  • Exa  —— 语义/神经搜索，按「意思」找相似内容和研究资料。适合「做研究/找相似」。
      免费额度：新账号注册赠送 $10 额度。
      注册拿 Key： https://dashboard.exa.ai

  拿不到 Key 也别卡住——可以先跳过，本地备份说明在 docs/tavily.md、docs/exa.md，回头再配。
TXT
echo ""

# ---------- Tavily ----------
read -r -p "现在配置 Tavily 吗？(y/N) " DO_TAVILY
if [[ "${DO_TAVILY:-N}" =~ ^[Yy]$ ]]; then
  read -r -s -p "粘贴你的 Tavily API Key（输入时不显示）: " TAVILY_KEY; echo ""
  if [ -n "${TAVILY_KEY:-}" ]; then
    claude mcp remove tavily-remote >/dev/null 2>&1 || true
    if claude mcp add tavily-remote --scope user --transport http \
        "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_KEY}"; then
      ok "Tavily 已配置完成。"
    else
      err "Tavily 配置失败，请检查 Key 后重试。"
    fi
  else
    warn "未输入 Key，跳过 Tavily。"
  fi
fi
echo ""

# ---------- Exa ----------
read -r -p "现在配置 Exa 吗？(y/N) " DO_EXA
if [[ "${DO_EXA:-N}" =~ ^[Yy]$ ]]; then
  read -r -s -p "粘贴你的 Exa API Key（输入时不显示）: " EXA_KEY; echo ""
  if [ -n "${EXA_KEY:-}" ]; then
    claude mcp remove exa >/dev/null 2>&1 || true
    # 本地方式（需要 Node.js，npx 会自动下载 exa-mcp-server），避开浏览器授权，对新手更稳
    if claude mcp add exa --scope user --env "EXA_API_KEY=${EXA_KEY}" -- npx -y exa-mcp-server; then
      ok "Exa 已配置完成。"
    else
      err "Exa 配置失败。可能是未安装 Node.js；或改用远程方式：claude mcp add exa --transport http https://mcp.exa.ai/mcp"
    fi
  else
    warn "未输入 Key，跳过 Exa。"
  fi
fi

echo ""
say "当前已配置的 MCP 服务："
claude mcp list || true
echo ""
ok "搞定！重启 claude 后，在对话里就能让它联网搜索了。"
echo ""
