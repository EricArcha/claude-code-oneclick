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

Write-Host ""
Say "配置 Claude Code 的 API（你自己的服务商 / 中转地址）"
Write-Host "  设置成功后，Claude Code 会用你填的地址和密钥，不再需要官方登录。"
Write-Host "  这一步随时可以再运行一次来更换服务。"
Write-Host ""

$baseUrl = Read-Host "请粘贴 API 地址（Base URL，例如 https://你的中转地址）"
# 读密钥时不回显
$secure  = Read-Host "请粘贴 API 密钥（Key / Token，输入时不显示）" -AsSecureString
$authToken = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
  [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))

if ([string]::IsNullOrWhiteSpace($baseUrl) -or [string]::IsNullOrWhiteSpace($authToken)) {
  Err "地址或密钥为空，已取消。请重新运行本脚本。"
  exit 1
}

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
$env['ANTHROPIC_BASE_URL']   = $baseUrl
$env['ANTHROPIC_AUTH_TOKEN'] = $authToken
$env.Remove('ANTHROPIC_API_KEY') | Out-Null
$data['env'] = $env

($data | ConvertTo-Json -Depth 20) | Set-Content -Path $settingsFile -Encoding UTF8
Ok "已合并写入：$settingsFile"

# 回显（密钥打码）
$masked = if ($authToken.Length -ge 8) { $authToken.Substring(0,4) + "****" + $authToken.Substring($authToken.Length-4) } else { "****" }
Write-Host ""
Ok "配置完成！"
Write-Host "    API 地址：$baseUrl"
Write-Host "    API 密钥：$masked （已打码显示）"
Write-Host ""
Write-Host "现在可以直接输入  claude  启动了。若 claude 正在运行，请重启它使配置生效。"
Write-Host "想换别的服务？随时再运行一次本脚本即可。"
Write-Host ""
