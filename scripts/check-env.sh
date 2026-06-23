#!/usr/bin/env bash
# check-env.sh — 一键体检：看看你的电脑已经装好了哪些、还差哪些
# 用法：bash check-env.sh
set -uo pipefail

BLUE='\033[1;34m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'; BOLD='\033[1m'; NC='\033[0m'
SETTINGS_FILE="$HOME/.claude/settings.json"

done_cc=0; done_api=0; done_search=0; has_lark=0; has_switch=0

echo ""
printf "${BOLD}🩺 Claude Code 环境体检${NC}\n"
echo "────────────────────────────────────"

# 1) Claude Code
if command -v claude >/dev/null 2>&1; then
  VER="$(claude --version 2>/dev/null || echo '已安装')"
  printf "${GREEN}✓${NC} 第 1 步  Claude Code 已安装（%s）\n" "$VER"
  done_cc=1
else
  printf "${RED}✗${NC} 第 1 步  还没装 Claude Code  → 运行 install-cc 脚本\n"
fi

# 2) 自有 API 配置
if [ -f "$SETTINGS_FILE" ] && grep -q "ANTHROPIC_BASE_URL" "$SETTINGS_FILE" 2>/dev/null; then
  if grep -q "ANTHROPIC_MODEL" "$SETTINGS_FILE" 2>/dev/null; then
    printf "${GREEN}✓${NC} 第 2 步  已配置自己的 API（地址 + 模型已设置）\n"
  else
    printf "${GREEN}✓${NC} 第 2 步  已配置 API 地址（${YELLOW}建议补设模型名，重跑 config-api 即可${NC}）\n"
  fi
  done_api=1
else
  printf "${RED}✗${NC} 第 2 步  还没配置自己的 API  → 运行 config-api 脚本\n"
fi

# 3) 搜索 MCP（Tavily / Exa）
if [ "$done_cc" -eq 1 ]; then
  MCP_LIST="$(claude mcp list 2>/dev/null || true)"
  if echo "$MCP_LIST" | grep -qiE "tavily|exa"; then
    printf "${GREEN}✓${NC} 第 3 步  已配置联网搜索（"
    echo "$MCP_LIST" | grep -qi tavily && printf "Tavily "
    echo "$MCP_LIST" | grep -qi exa && printf "Exa"
    printf "）\n"
    done_search=1
  else
    printf "${RED}✗${NC} 第 3 步  还没配置联网搜索  → 运行 setup-search-mcp 脚本\n"
  fi
else
  printf "${YELLOW}…${NC} 第 3 步  需先装好 Claude Code 才能检查搜索配置\n"
fi

# 可选项
command -v lark-cli >/dev/null 2>&1 && { has_lark=1; printf "${GREEN}✓${NC} 可选    飞书 CLI 已安装\n"; } \
  || printf "${YELLOW}○${NC} 可选    飞书 CLI 未安装（不影响主流程）\n"

# cc-switch 的安装名/路径在不同版本与平台上写法不一：
#   macOS  → /Applications/CC Switch.app（官方 cask 产物，大写+空格）
#   Linux  → DEB/RPM 多为 /usr/bin/cc-switch（PATH 兜底）或桌面入口
# 用大小写不敏感通配逐个判断，避免某个通配未命中时把字面量传给 ls 造成误判。
for _d in \
  /Applications/*[Ss]witch*.app \
  "$HOME"/Applications/*[Ss]witch*.app \
  /usr/share/applications/*[Cc][Cc]*[Ss]witch* \
  "$HOME"/.local/share/applications/*[Cc][Cc]*[Ss]witch*; do
  [ -e "$_d" ] && has_switch=1
done
command -v cc-switch >/dev/null 2>&1 && has_switch=1
if [ "$has_switch" -eq 1 ]; then
  printf "${GREEN}✓${NC} 可选    cc-switch 已安装\n"
else
  printf "${YELLOW}○${NC} 可选    cc-switch 未安装（不影响主流程）\n"
fi

echo "────────────────────────────────────"

CORE=$((done_cc + done_api + done_search))
if [ "$CORE" -eq 3 ]; then
  echo ""
  printf "${GREEN}${BOLD}"
  cat <<'EGG'
   ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★
       🎉  YOU ARE A CC GENIUS!  🎉
   ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★
EGG
  printf "${NC}"
  echo ""
  echo "  三步全部完成，你的 Claude Code 已经满血上线 🚀"
  echo "  现在打开终端输入  claude  开始你的第一段对话吧！"
else
  echo ""
  printf "进度：核心 3 步已完成 ${BOLD}%s/3${NC}。按上面 ✗ 的提示继续即可。\n" "$CORE"
fi
echo ""
