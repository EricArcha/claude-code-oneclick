#!/usr/bin/env bash
# config-api.sh — 配置你自己的 API（让 Claude Code 走你的中转/服务商，跳过官方登录）
# 可重复运行：随时重跑即可更换新的 API 服务。
# 用法：bash config-api.sh
set -euo pipefail

BLUE='\033[1;34m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; RED='\033[1;31m'; BOLD='\033[1m'; NC='\033[0m'
say()  { printf "${BLUE}▶ %s${NC}\n" "$1"; }
ok()   { printf "${GREEN}✓ %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}! %s${NC}\n" "$1"; }
err()  { printf "${RED}✗ %s${NC}\n" "$1"; }
bold() { printf "${BOLD}%s${NC}" "$1"; }

SETTINGS_DIR="$HOME/.claude"
SETTINGS_FILE="$SETTINGS_DIR/settings.json"

# ===== PROVIDER PRESETS =====
# 同步更新 config-api.ps1 中的 $providersJson。
# 数据来源：cc-switch claudeProviderPresets.ts + 各服务商官方文档
# https://github.com/farion1231/cc-switch/blob/main/src/config/claudeProviderPresets.ts
PROVIDERS_JSON=$(cat <<'EOF'
{
  "deepseek": {
    "name": "DeepSeek（深度求索）",
    "api_key_url": "https://platform.deepseek.com/api_keys",
    "env": {
      "ANTHROPIC_BASE_URL": "https://api.deepseek.com/anthropic",
      "ANTHROPIC_MODEL": "deepseek-v4-pro[1m]",
      "ANTHROPIC_DEFAULT_HAIKU_MODEL": "deepseek-v4-flash[1m]",
      "ANTHROPIC_DEFAULT_SONNET_MODEL": "deepseek-v4-pro[1m]",
      "ANTHROPIC_DEFAULT_OPUS_MODEL": "deepseek-v4-pro[1m]",
      "CLAUDE_CODE_SUBAGENT_MODEL": "deepseek-v4-flash[1m]",
      "CLAUDE_CODE_EFFORT_LEVEL": "max"
    }
  },
  "kimi": {
    "name": "Kimi（月之暗面）",
    "api_key_url": "https://platform.moonshot.cn/console?aff=cc-switch",
    "env": {
      "ANTHROPIC_BASE_URL": "https://api.moonshot.cn/anthropic",
      "ANTHROPIC_MODEL": "kimi-k2.7-code",
      "ANTHROPIC_DEFAULT_HAIKU_MODEL": "kimi-k2.7-code",
      "ANTHROPIC_DEFAULT_SONNET_MODEL": "kimi-k2.7-code",
      "ANTHROPIC_DEFAULT_OPUS_MODEL": "kimi-k2.7-code"
    }
  },
  "zhipu": {
    "name": "智谱 GLM",
    "api_key_url": "https://www.bigmodel.cn/claude-code?ic=RRVJPB5SII",
    "env": {
      "ANTHROPIC_BASE_URL": "https://open.bigmodel.cn/api/anthropic",
      "ANTHROPIC_MODEL": "glm-5.1",
      "ANTHROPIC_DEFAULT_HAIKU_MODEL": "glm-5.1",
      "ANTHROPIC_DEFAULT_SONNET_MODEL": "glm-5.1",
      "ANTHROPIC_DEFAULT_OPUS_MODEL": "glm-5.1"
    }
  },
  "bailian": {
    "name": "阿里百炼",
    "api_key_url": "https://bailian.console.aliyun.com",
    "env": {
      "ANTHROPIC_BASE_URL": "https://dashscope.aliyuncs.com/apps/anthropic"
    }
  },
  "doubao": {
    "name": "豆包 Seed",
    "api_key_url": "https://console.volcengine.com/ark/region:ark+cn-beijing/apiKey",
    "env": {
      "ANTHROPIC_BASE_URL": "https://ark.cn-beijing.volces.com/api/compatible",
      "ANTHROPIC_MODEL": "doubao-seed-2-0-code-preview-latest",
      "ANTHROPIC_DEFAULT_HAIKU_MODEL": "doubao-seed-2-0-code-preview-latest",
      "ANTHROPIC_DEFAULT_SONNET_MODEL": "doubao-seed-2-0-code-preview-latest",
      "ANTHROPIC_DEFAULT_OPUS_MODEL": "doubao-seed-2-0-code-preview-latest"
    }
  },
  "minimax": {
    "name": "MiniMax",
    "api_key_url": "https://platform.minimaxi.com/subscribe/coding-plan",
    "env": {
      "ANTHROPIC_BASE_URL": "https://api.minimaxi.com/anthropic",
      "ANTHROPIC_MODEL": "MiniMax-M2.7",
      "ANTHROPIC_DEFAULT_HAIKU_MODEL": "MiniMax-M2.7",
      "ANTHROPIC_DEFAULT_SONNET_MODEL": "MiniMax-M2.7",
      "ANTHROPIC_DEFAULT_OPUS_MODEL": "MiniMax-M2.7"
    }
  }
}
EOF
)

echo ""
say "配置 Claude Code 的 API（你自己的服务商 / 中转地址）"
echo "  设置成功后，Claude Code 会用你填的地址和密钥，不再需要官方登录。"
echo "  这一步随时可以再运行一次来更换服务。"
echo ""

# ===== 路径选择 =====
echo "  你想怎么配置？"
echo "    [1] 从服务商列表选（推荐 · 地址和模型名自动填好，只需输入 API Key）"
echo "    [2] 自定义输入（手动输入地址、密钥、模型名）"
echo ""
read -r -p "  你的选择 [1-2，默认 1]: " PATH_CHOICE
PATH_CHOICE="${PATH_CHOICE:-1}"
echo ""

if [ "$PATH_CHOICE" = "2" ]; then
  # ===== 路径二：自定义输入 =====
  say "自定义配置"
  read -r -p "请粘贴 API 地址（Base URL，例如 https://api.deepseek.com/anthropic）: " BASE_URL
  read -r -s -p "请粘贴 API 密钥（Key / Token，输入时不显示）: " AUTH_TOKEN
  echo ""

  if [ -z "${BASE_URL:-}" ] || [ -z "${AUTH_TOKEN:-}" ]; then
    err "地址或密钥为空，已取消。请重新运行本脚本。"
    exit 1
  fi

  read -r -p "请粘贴模型名称（例如 deepseek-v4-pro[1m]，不清楚可先回车跳过）: " MODEL_NAME
  if [ -n "${MODEL_NAME:-}" ]; then
    echo "  → 将设置默认模型为 ${MODEL_NAME}（同时覆盖 Haiku/Sonnet/Opus 三级默认）"
  else
    warn "未指定模型名。某些服务商可能需要你手动设模型名才能正常启动。"
    echo "  若启动报错，重跑本脚本补填模型名即可。"
  fi
  echo ""

  MODE="custom"
  # 这两个变量会传给 python3
  export BASE_URL AUTH_TOKEN MODEL_NAME MODE

else
  # ===== 路径一：服务商菜单 =====
  echo "  请选择你的 API 服务商："
  echo "  ─────────────────────────────────────────────"
  echo "  [1] DeepSeek（深度求索）— deepseek-v4-pro[1m]"
  echo "  [2] Kimi（月之暗面）  — kimi-k2.7-code"
  echo "  [3] 智谱 GLM          — glm-5.1"
  echo "  [4] 阿里百炼           — 自动路由，无需指定模型"
  echo "  [5] 豆包 Seed          — doubao-seed-2-0-code-preview-latest"
  echo "  [6] MiniMax            — MiniMax-M2.7"
  echo "  ─────────────────────────────────────────────"
  echo ""

  read -r -p "  你的选择 [1-6]: " PROVIDER_NUM

  case "$PROVIDER_NUM" in
    1) PROVIDER="deepseek" ;;
    2) PROVIDER="kimi" ;;
    3) PROVIDER="zhipu" ;;
    4) PROVIDER="bailian" ;;
    5) PROVIDER="doubao" ;;
    6) PROVIDER="minimax" ;;
    *)
      err "无效选择（$PROVIDER_NUM），请输入 1-6。"
      exit 1
      ;;
  esac

  # 从 JSON 提取该服务商的 name 和 api_key_url（用 python3）
  P_NAME=$(echo "$PROVIDERS_JSON" | python3 -c "
import json,sys
d=json.load(sys.stdin)
print(d['$PROVIDER']['name'])
" 2>/dev/null || echo "$PROVIDER")

  P_KEY_URL=$(echo "$PROVIDERS_JSON" | python3 -c "
import json,sys
d=json.load(sys.stdin)
print(d['$PROVIDER'].get('api_key_url',''))
" 2>/dev/null || echo "")

  echo ""
  say "已选择：${P_NAME}"
  if [ -n "$P_KEY_URL" ]; then
    echo "  获取 API Key：${P_KEY_URL}"
  fi
  echo ""

  read -r -s -p "请粘贴 API 密钥（Key / Token，输入时不显示）: " AUTH_TOKEN
  echo ""

  if [ -z "${AUTH_TOKEN:-}" ]; then
    err "API 密钥为空，已取消。请重新运行本脚本。"
    exit 1
  fi

  MODE="provider"
  export PROVIDER PROVIDERS_JSON AUTH_TOKEN MODE
fi

# ===== 写入 settings.json =====
mkdir -p "$SETTINGS_DIR"
[ -f "$SETTINGS_FILE" ] || echo '{}' > "$SETTINGS_FILE"

# 优先用 python3 安全地合并 JSON（不破坏已有配置）
if command -v python3 >/dev/null 2>&1; then
  SETTINGS_FILE="$SETTINGS_FILE" python3 <<'PY'
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

mode = os.environ.get("MODE", "custom")

if mode == "provider":
    # 从预设 JSON 合并
    provider_code = os.environ.get("PROVIDER", "")
    providers_json_str = os.environ.get("PROVIDERS_JSON", "{}")
    providers = json.loads(providers_json_str)
    preset = providers.get(provider_code, {})
    preset_env = preset.get("env", {})

    # 写入预设的所有 env vars
    for k, v in preset_env.items():
        env[k] = v
    # 覆盖用户输入的密钥
    env["ANTHROPIC_AUTH_TOKEN"] = os.environ["AUTH_TOKEN"]

else:
    # 自定义模式
    env["ANTHROPIC_BASE_URL"] = os.environ["BASE_URL"]
    env["ANTHROPIC_AUTH_TOKEN"] = os.environ["AUTH_TOKEN"]

    model = os.environ.get("MODEL_NAME", "").strip()
    if model:
        env["ANTHROPIC_MODEL"] = model
        env["ANTHROPIC_DEFAULT_HAIKU_MODEL"] = model
        env["ANTHROPIC_DEFAULT_SONNET_MODEL"] = model
        env["ANTHROPIC_DEFAULT_OPUS_MODEL"] = model

# 避免与旧版 ANTHROPIC_API_KEY 冲突
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

  if [ "$MODE" = "provider" ]; then
    warn "简单模式不支持服务商预设，将改用自定义模式。请手动输入。"
    read -r -p "请粘贴 API 地址（Base URL）: " BASE_URL
    read -r -s -p "请粘贴 API 密钥（Key / Token）: " AUTH_TOKEN
    echo ""
    if [ -z "${BASE_URL:-}" ] || [ -z "${AUTH_TOKEN:-}" ]; then
      err "地址或密钥为空，已取消。"
      exit 1
    fi
  fi

  # 构建 JSON（bash 3 兼容，不用 jq）
  MODEL_NAME="${MODEL_NAME:-}"
  if [ -n "$MODEL_NAME" ]; then
    cat > "$SETTINGS_FILE" <<INNEREOF
{
  "env": {
    "ANTHROPIC_BASE_URL": "$BASE_URL",
    "ANTHROPIC_AUTH_TOKEN": "$AUTH_TOKEN",
    "ANTHROPIC_MODEL": "$MODEL_NAME",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "$MODEL_NAME",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "$MODEL_NAME",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "$MODEL_NAME"
  }
}
INNEREOF
  else
    cat > "$SETTINGS_FILE" <<INNEREOF
{
  "env": {
    "ANTHROPIC_BASE_URL": "$BASE_URL",
    "ANTHROPIC_AUTH_TOKEN": "$AUTH_TOKEN"
  }
}
INNEREOF
  fi
  ok "已写入：$SETTINGS_FILE"
fi

# ===== 回显总结 =====
echo ""
ok "配置完成！"

if [ "$MODE" = "provider" ]; then
  echo "   服务商：${P_NAME:-$PROVIDER}"
  # 提取预设中的模型名用于显示
  P_MODEL=$(echo "$PROVIDERS_JSON" | python3 -c "
import json,sys
d=json.load(sys.stdin)
p=d.get('$PROVIDER',{}).get('env',{})
m=p.get('ANTHROPIC_MODEL','（未指定，由服务商自动路由）')
print(m)
" 2>/dev/null || echo "（自动路由）")
  echo "   模型名：${P_MODEL}"
else
  echo "   API 地址：$BASE_URL"
  if [ -n "${MODEL_NAME:-}" ]; then
    echo "   模型名：$MODEL_NAME"
  else
    echo "   模型名：（未指定）"
  fi
fi

# 密钥打码
AUTH_TOKEN="${AUTH_TOKEN:-}"
if [ ${#AUTH_TOKEN} -ge 8 ]; then
  MASKED="${AUTH_TOKEN:0:4}****${AUTH_TOKEN: -4}"
else
  MASKED="****"
fi
echo "   API 密钥：${MASKED}（已打码显示）"
echo ""
echo "现在可以直接输入  claude  启动了。若 claude 正在运行，请重启它使配置生效。"
echo "想换别的服务？随时再运行一次本脚本即可。"
echo ""
