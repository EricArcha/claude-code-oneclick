#!/usr/bin/env bash
# install-lark.sh — 可选：安装飞书 CLI（lark-cli）并接入 Claude Code
# 用法：bash install-lark.sh
set -euo pipefail

BLUE='\033[1;34m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'; NC='\033[0m'
say()  { printf "${BLUE}▶ %s${NC}\n" "$1"; }
ok()   { printf "${GREEN}✓ %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}! %s${NC}\n" "$1"; }
err()  { printf "${RED}✗ %s${NC}\n" "$1"; }

echo ""
say "安装飞书 CLI（lark-cli）"
echo "  它把飞书 2500+ 接口收成 200+ 命令，并提供给 Claude Code 调用的 Skills。"
echo "  官方文档： https://github.com/larksuite/cli"
echo ""

if ! command -v npx >/dev/null 2>&1; then
  err "未检测到 Node.js / npx。请先安装 Node.js 18+（https://nodejs.org），再运行本脚本。"
  exit 1
fi

say "第 1 步：安装 lark-cli 本体…"
npx @larksuite/cli@latest install || { err "安装失败，请检查网络后重试。"; exit 1; }
ok "lark-cli 安装完成。"

echo ""
say "第 2 步：安装给 Claude Code 用的 Skills…"
npx skills add larksuite/cli -y -g || warn "Skills 安装未成功，可稍后手动重试：npx skills add larksuite/cli -y -g"

echo ""
say "第 3 步：登录飞书账号（会打开浏览器授权）…"
echo "  如不想现在登录，可按 Ctrl+C 跳过，之后随时运行： lark-cli auth login --recommend"
lark-cli auth login --recommend || warn "登录未完成，可稍后运行：lark-cli auth login --recommend"

echo ""
ok "飞书 CLI 配置流程结束。本地备份说明见 docs/lark-cli.md。"
echo ""
