#!/usr/bin/env bash
# install-cc.sh — 一键安装 / 升级最新版 Claude Code（macOS / Linux）
# 用法：bash install-cc.sh
set -euo pipefail

BLUE='\033[1;34m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'; NC='\033[0m'
say()  { printf "${BLUE}▶ %s${NC}\n" "$1"; }
ok()   { printf "${GREEN}✓ %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}! %s${NC}\n" "$1"; }
err()  { printf "${RED}✗ %s${NC}\n" "$1"; }

echo ""
say "开始安装最新版 Claude Code…"
echo "  （这一步会从官方地址下载并安装，可能需要 1~3 分钟，请耐心等待）"
echo ""

# 已安装则提示（原生安装包会自动后台更新，一般无需手动升级）
if command -v claude >/dev/null 2>&1; then
  CUR="$(claude --version 2>/dev/null || echo '未知')"
  ok "检测到已安装 Claude Code（版本：$CUR）"
  echo "  原生安装版本会自动在后台更新，通常无需手动操作。"
  echo "  如需强制重装，继续即可。"
  echo ""
fi

# 官方原生安装脚本（来源：https://code.claude.com/docs/en/setup.md）
if curl -fsSL https://claude.ai/install.sh | bash; then
  ok "安装脚本执行完成。"
else
  err "官方安装脚本执行失败。"
  echo "  备选方案（需先装好 Node.js 18+）："
  echo "    npm install -g @anthropic-ai/claude-code"
  exit 1
fi

# 让当前终端能立刻找到 claude（新装时 PATH 可能还没刷新）
export PATH="$HOME/.local/bin:$PATH"

echo ""
if command -v claude >/dev/null 2>&1; then
  VER="$(claude --version 2>/dev/null || echo '已安装')"
  ok "Claude Code 安装成功！版本：$VER"
  echo ""
  echo "下一步：配置你自己的 API（运行 config-api.sh），然后输入 claude 启动。"
else
  warn "安装似乎完成，但当前终端还找不到 claude 命令。"
  echo "  请【关闭并重新打开终端】后输入：claude --version"
  echo "  若仍找不到，把这行加到 ~/.zshrc 再重开终端："
  echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
fi
echo ""
