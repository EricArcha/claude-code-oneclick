# config-api.ps1 — 配置你自己的 API（让 Claude Code 走你的中转/服务商，跳过官方登录）
# 可重复运行：随时重跑即可更换新的 API 服务。
# 用法：powershell -ExecutionPolicy Bypass -File config-api.ps1
$ErrorActionPreference = 'Stop'

function Say($m)  { Write-Host "▶ $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "✓ $m" -ForegroundColor Green }
function Warn($m) { Write-Host "! $m" -ForegroundColor Yellow }
function Err($m)  { Write-Host "✗ $m" -ForegroundColor Red }

$settingsDir  = Join-Path $HOME ".claude"
$settingsFile = Join-Path $settingsDir "settings.json"

# ===== PROVIDER PRESETS =====
# 同步更新 config-api.sh 中的 PROVIDERS_JSON。
# 数据来源：cc-switch claudeProviderPresets.ts + 各服务商官方文档
# https://github.com/farion1231/cc-switch/blob/main/src/config/claudeProviderPresets.ts
$providersJson = @'
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
'@

Write-Host ""
Say "配置 Claude Code 的 API（你自己的服务商 / 中转地址）"
Write-Host "  设置成功后，Claude Code 会用你填的地址和密钥，不再需要官方登录。"
Write-Host "  这一步随时可以再运行一次来更换服务。"
Write-Host ""

# ===== 路径选择 =====
Write-Host "  你想怎么配置？"
Write-Host "    [1] 从服务商列表选（推荐 · 地址和模型名自动填好，只需输入 API Key）"
Write-Host "    [2] 自定义输入（手动输入地址、密钥、模型名）"
Write-Host ""
$pathChoice = Read-Host "  你的选择 [1-2，默认 1]"
if ([string]::IsNullOrWhiteSpace($pathChoice)) { $pathChoice = "1" }
Write-Host ""

$mode = ""
$providerCode = ""
$providerName = ""
$baseUrl = ""
$authToken = ""
$modelName = ""

if ($pathChoice -eq "2") {
  # ===== 路径二：自定义输入 =====
  Say "自定义配置"
  $baseUrl = Read-Host "请粘贴 API 地址（Base URL，例如 https://api.deepseek.com/anthropic）"
  $secure = Read-Host "请粘贴 API 密钥（Key / Token，输入时不显示）" -AsSecureString
  $authToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))

  if ([string]::IsNullOrWhiteSpace($baseUrl) -or [string]::IsNullOrWhiteSpace($authToken)) {
    Err "地址或密钥为空，已取消。请重新运行本脚本。"
    exit 1
  }

  $modelName = Read-Host "请粘贴模型名称（例如 deepseek-v4-pro[1m]，不清楚可先回车跳过）"
  if (-not [string]::IsNullOrWhiteSpace($modelName)) {
    Write-Host "  → 将设置默认模型为 $modelName（同时覆盖 Haiku/Sonnet/Opus 三级默认）"
  } else {
    Warn "未指定模型名。某些服务商可能需要你手动设模型名才能正常启动。"
    Write-Host "  若启动报错，重跑本脚本补填模型名即可。"
  }
  Write-Host ""
  $mode = "custom"

} else {
  # ===== 路径一：服务商菜单 =====
  Write-Host "  请选择你的 API 服务商："
  Write-Host "  ─────────────────────────────────────────────"
  Write-Host "  [1] DeepSeek（深度求索）— deepseek-v4-pro[1m]"
  Write-Host "  [2] Kimi（月之暗面）  — kimi-k2.7-code"
  Write-Host "  [3] 智谱 GLM          — glm-5.1"
  Write-Host "  [4] 阿里百炼           — 自动路由，无需指定模型"
  Write-Host "  [5] 豆包 Seed          — doubao-seed-2-0-code-preview-latest"
  Write-Host "  [6] MiniMax            — MiniMax-M2.7"
  Write-Host "  ─────────────────────────────────────────────"
  Write-Host ""

  $num = Read-Host "  你的选择 [1-6]"

  switch ($num) {
    "1" { $providerCode = "deepseek" }
    "2" { $providerCode = "kimi" }
    "3" { $providerCode = "zhipu" }
    "4" { $providerCode = "bailian" }
    "5" { $providerCode = "doubao" }
    "6" { $providerCode = "minimax" }
    default {
      Err "无效选择（$num），请输入 1-6。"
      exit 1
    }
  }

  $providers = $providersJson | ConvertFrom-Json
  $preset = $providers.$providerCode
  $providerName = $preset.name
  $keyUrl = $preset.api_key_url

  Write-Host ""
  Say "已选择：$providerName"
  if ($keyUrl) {
    Write-Host "  获取 API Key：$keyUrl"
  }
  Write-Host ""

  $secure = Read-Host "请粘贴 API 密钥（Key / Token，输入时不显示）" -AsSecureString
  $authToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))

  if ([string]::IsNullOrWhiteSpace($authToken)) {
    Err "API 密钥为空，已取消。请重新运行本脚本。"
    exit 1
  }

  $mode = "provider"
}

# ===== 写入 settings.json =====
if (-not (Test-Path $settingsDir)) { New-Item -ItemType Directory -Path $settingsDir | Out-Null }

# 读取已有配置（不破坏其他设置）
$data = [ordered]@{}
if (Test-Path $settingsFile) {
  try {
    $raw = Get-Content -Raw -Path $settingsFile
    if ($raw.Trim().Length -gt 0) {
      $obj = $raw | ConvertFrom-Json
      foreach ($p in $obj.PSObject.Properties) { $data[$p.Name] = $p.Value }
    }
  } catch { Warn "原配置无法解析，将重新生成。" }
}

# 合并 env 块
$env = [ordered]@{}
if ($data.Contains('env') -and $data['env']) {
  foreach ($p in $data['env'].PSObject.Properties) { $env[$p.Name] = $p.Value }
}

if ($mode -eq "provider") {
  # 从预设 JSON 合并
  $presetEnv = $preset.env
  foreach ($p in $presetEnv.PSObject.Properties) {
    $env[$p.Name] = $p.Value
  }
  $env['ANTHROPIC_AUTH_TOKEN'] = $authToken
  $modelName = $presetEnv['ANTHROPIC_MODEL']
  if (-not $modelName) { $modelName = "（未指定，由服务商自动路由）" }

} else {
  # 自定义模式
  $env['ANTHROPIC_BASE_URL'] = $baseUrl
  $env['ANTHROPIC_AUTH_TOKEN'] = $authToken

  if (-not [string]::IsNullOrWhiteSpace($modelName)) {
    $env['ANTHROPIC_MODEL'] = $modelName
    $env['ANTHROPIC_DEFAULT_HAIKU_MODEL'] = $modelName
    $env['ANTHROPIC_DEFAULT_SONNET_MODEL'] = $modelName
    $env['ANTHROPIC_DEFAULT_OPUS_MODEL'] = $modelName
  }
}

# 避免与旧版 ANTHROPIC_API_KEY 冲突
$env.Remove('ANTHROPIC_API_KEY') | Out-Null

$data['env'] = $env

($data | ConvertTo-Json -Depth 20) | Set-Content -Path $settingsFile -Encoding UTF8
Ok "已合并写入：$settingsFile"

# ===== 回显总结 =====
Write-Host ""
Ok "配置完成！"

if ($mode -eq "provider") {
  Write-Host "   服务商：$providerName"
  Write-Host "   模型名：$modelName"
} else {
  Write-Host "   API 地址：$baseUrl"
  if (-not [string]::IsNullOrWhiteSpace($modelName)) {
    Write-Host "   模型名：$modelName"
  } else {
    Write-Host "   模型名：（未指定）"
  }
}

# 密钥打码
if ($authToken.Length -ge 8) {
  $masked = $authToken.Substring(0,4) + "****" + $authToken.Substring($authToken.Length-4)
} else {
  $masked = "****"
}
Write-Host "   API 密钥：${masked}（已打码显示）"
Write-Host ""
Write-Host "现在可以直接输入  claude  启动了。若 claude 正在运行，请重启它使配置生效。"
Write-Host "想换别的服务？随时再运行一次本脚本即可。"
Write-Host ""
