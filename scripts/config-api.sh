#!/usr/bin/env bash
# config-api.sh — 配置你自己的 API（让 Claude Code 走你的中转/服务商，跳过官方登录）
# 可重复运行：随时重跑即可更换新的 API 服务。
# 用法：bash config-api.sh
set -euo pipefail

BLUE='\033[1;34m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'; NC='\033[0m'
say()  { printf "${BLUE}▶ %s${NC}\n" "$1"; }
ok()   { printf "${GREEN}✓ %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}! %s${NC}\n" "$1"; }
err()  { printf "${RED}✗ %s${NC}\n" "$1"; }

SETTINGS_DIR="$HOME/.claude"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

echo ""
say "配置 Claude Code 的 API（你自己的服务商 / 中转地址）"
echo "  设置成功后，Claude Code 会用你填的地址和密钥，不再需要官方登录。"
echo "  这一步随时可以再运行一次来更换服务。"
echo ""

# 读取用户输入
read -r -p "请粘贴 API 地址（Base URL，例如 https://你的中转地址）: " BASE_URL
# 读密钥时不回显，更安全
read -r -s -p "请粘贴 API 密钥（Key / Token，输入时不显示）: " AUTH_TOKEN
echo ""

if [ -z "${BASE_URL:-}" ] || [ -z "${AUTH_TOKEN:-}" ]; then
  err "地址或密钥为空，已取消。请重新运行本脚本。"
  exit 1
fi

mkdir -p "$SETTINGS_DIR"
[ -f "$SETTINGS_FILE" ] || echo '{}' > "$SETTINGS_FILE"

# 优先用 python3 安全地合并 JSON（不破坏已有配置）
if command -v python3 >/dev/null 2>&1; then
  BASE_URL="$BASE_URL" AUTH_TOKEN="$AUTH_TOKEN" SETTINGS_FILE="$SETTINGS_FILE" python3 <<'PY'
import json, os, sys
f = os.environ["SETTINGS_FILE"]
try:
    with open(f, "r", encoding="utf-8") as fh:
        data = json.load(fh)
    if not isinstance(data, dict):
        data = {}
except Exception:
    data = {}
env = data.get("env")
if not isinstance(env, dict):
    env = {}
env["ANTHROPIC_BASE_URL"] = os.environ["BASE_URL"]
env["ANTHROPIC_AUTH_TOKEN"] = os.environ["AUTH_TOKEN"]
# 避免与 token 冲突：若之前设过 API_KEY，移除（AUTH_TOKEN 已覆盖其用途）
env.pop("ANTHROPIC_API_KEY", None)
data["env"] = env
with open(f, "w", encoding="utf-8") as fh:
    json.dump(data, fh, ensure_ascii=False, indent=2)
    fh.write("\n")
PY
  ok "已合并写入：$SETTINGS_FILE"
else
  # 回退：没有 python3 时直接写入（会覆盖整个文件，仅保留 env）
  warn "未检测到 python3，使用简单写入模式（将只保留 env 配置）。"
  cat > "$SETTINGS_FILE" <<EOF
{
  "env": {
    "ANTHROPIC_BASE_URL": "$BASE_URL",
    "ANTHROPIC_AUTH_TOKEN": "$AUTH_TOKEN"
  }
}
EOF
  ok "已写入：$SETTINGS_FILE"
fi

# 回显（密钥打码）
MASKED="${AUTH_TOKEN:0:4}****${AUTH_TOKEN: -4}"
echo ""
ok "配置完成！"
echo "    API 地址：$BASE_URL"
echo "    API 密钥：$MASKED （已打码显示）"
echo ""
echo "现在可以直接输入  claude  启动了。若 claude 正在运行，请重启它使配置生效。"
echo "想换别的服务？随时再运行一次本脚本即可。"
echo ""
