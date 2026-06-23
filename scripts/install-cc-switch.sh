#!/usr/bin/env bash
# install-cc-switch.sh — 可选：安装 cc-switch（图形界面，便捷切换 Claude Code 后台 API）
# 用法：bash install-cc-switch.sh
set -euo pipefail

BLUE='\033[1;34m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
say()  { printf "${BLUE}▶ %s${NC}\n" "$1"; }
ok()   { printf "${GREEN}✓ %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}! %s${NC}\n" "$1"; }

echo ""
say "安装 cc-switch（图形界面 App）"
echo "  作用：一键切换 Claude Code / Codex / Gemini 等工具的后台 API，统一管理 MCP。"
echo "  官网： https://ccswitch.io     源码： https://github.com/farion1231/cc-switch"
echo ""

if command -v brew >/dev/null 2>&1; then
  say "检测到 Homebrew，正在安装…"
  if brew install --cask cc-switch; then
    ok "cc-switch 安装完成！在「启动台 / 应用程序」里打开即可。"
  else
    warn "Homebrew 安装失败。请到发布页手动下载 .dmg： https://github.com/farion1231/cc-switch/releases"
  fi
else
  warn "未检测到 Homebrew。请到发布页手动下载安装包（选 macOS 的 .dmg）："
  echo "    https://github.com/farion1231/cc-switch/releases"
fi
echo ""
echo "提示：cc-switch 是「高级可选项」。只想用一个固定 API 的话，config-api.sh 就够了。"
echo "本地备份说明见 docs/cc-switch.md。"
echo ""
