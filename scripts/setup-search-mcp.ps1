# setup-search-mcp.ps1 — 一键给 Claude Code 配置联网搜索能力（Tavily / Exa）
# 用法：powershell -ExecutionPolicy Bypass -File setup-search-mcp.ps1
$ErrorActionPreference = 'Stop'

function Say($m)  { Write-Host "▶ $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "✓ $m" -ForegroundColor Green }
function Warn($m) { Write-Host "! $m" -ForegroundColor Yellow }
function Err($m)  { Write-Host "✗ $m" -ForegroundColor Red }

if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  Err "还没找到 claude 命令。请先运行 install-cc.ps1 安装 Claude Code，再回来配置搜索。"
  exit 1
}

function Read-Key($name) {
  $secure = Read-Host "粘贴你的 $name API Key（输入时不显示）" -AsSecureString
  return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
}

Write-Host ""
Say "给 Claude Code 装上「联网搜索」"
@"
  搜索有两家免费服务，可以都配，也可以只配一个：

  • Tavily —— 实时网页检索，把最新、干净的事实喂给 AI。适合「查最新消息/事实」。
      免费额度：每月 1000 次，免信用卡。   注册拿 Key： https://app.tavily.com
  • Exa  —— 语义/神经搜索，按「意思」找相似内容和研究资料。适合「做研究/找相似」。
      免费额度：新账号赠送 `$10 额度。       注册拿 Key： https://dashboard.exa.ai

  拿不到 Key 也别卡住——可以先跳过，本地备份说明在 docs\tavily.md、docs\exa.md，回头再配。
"@ | Write-Host
Write-Host ""

# ---------- Tavily ----------
$doTavily = Read-Host "现在配置 Tavily 吗？(y/N)"
if ($doTavily -match '^[Yy]$') {
  $tavilyKey = Read-Key "Tavily"
  if (-not [string]::IsNullOrWhiteSpace($tavilyKey)) {
    claude mcp remove tavily-remote 2>$null | Out-Null
    $url = "https://mcp.tavily.com/mcp/?tavilyApiKey=$tavilyKey"
    claude mcp add tavily-remote --scope user --transport http $url
    if ($LASTEXITCODE -eq 0) { Ok "Tavily 已配置完成。" } else { Err "Tavily 配置失败，请检查 Key 后重试。" }
  } else { Warn "未输入 Key，跳过 Tavily。" }
}
Write-Host ""

# ---------- Exa ----------
$doExa = Read-Host "现在配置 Exa 吗？(y/N)"
if ($doExa -match '^[Yy]$') {
  $exaKey = Read-Key "Exa"
  if (-not [string]::IsNullOrWhiteSpace($exaKey)) {
    claude mcp remove exa 2>$null | Out-Null
    # 本地方式（需要 Node.js，npx 自动下载 exa-mcp-server），避开浏览器授权，对新手更稳
    claude mcp add exa --scope user --env "EXA_API_KEY=$exaKey" -- npx -y exa-mcp-server
    if ($LASTEXITCODE -eq 0) { Ok "Exa 已配置完成。" }
    else { Err "Exa 配置失败。可能未装 Node.js；或改用远程：claude mcp add exa --transport http https://mcp.exa.ai/mcp" }
  } else { Warn "未输入 Key，跳过 Exa。" }
}

Write-Host ""
Say "当前已配置的 MCP 服务："
claude mcp list
Write-Host ""
Ok "搞定！重启 claude 后，在对话里就能让它联网搜索了。"
Write-Host ""
