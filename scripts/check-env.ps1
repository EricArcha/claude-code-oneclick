# check-env.ps1 — 一键体检：看看你的电脑已经装好了哪些、还差哪些
# 用法：powershell -ExecutionPolicy Bypass -File check-env.ps1
$ErrorActionPreference = 'SilentlyContinue'

$settingsFile = Join-Path $HOME ".claude\settings.json"
$doneCC = $false; $doneApi = $false; $doneSearch = $false

Write-Host ""
Write-Host "🩺 Claude Code 环境体检" -ForegroundColor White
Write-Host "────────────────────────────────────"

# 1) Claude Code
if (Get-Command claude -ErrorAction SilentlyContinue) {
  $ver = (claude --version 2>$null); if (-not $ver) { $ver = "已安装" }
  Write-Host "✓ 第 1 步  Claude Code 已安装（$ver）" -ForegroundColor Green
  $doneCC = $true
} else {
  Write-Host "✗ 第 1 步  还没装 Claude Code  → 运行 install-cc 脚本" -ForegroundColor Red
}

# 2) 自有 API 配置
if ((Test-Path $settingsFile) -and (Select-String -Path $settingsFile -Pattern "ANTHROPIC_BASE_URL" -Quiet)) {
  if (Select-String -Path $settingsFile -Pattern "ANTHROPIC_MODEL" -Quiet) {
    Write-Host "✓ 第 2 步  已配置自己的 API（地址 + 模型已设置）" -ForegroundColor Green
  } else {
    Write-Host "✓ 第 2 步  已配置 API 地址" -ForegroundColor Green -NoNewline
    Write-Host "（建议补设模型名，重跑 config-api 即可）" -ForegroundColor Yellow
  }
  $doneApi = $true
} else {
  Write-Host "✗ 第 2 步  还没配置自己的 API  → 运行 config-api 脚本" -ForegroundColor Red
}

# 3) 搜索 MCP
if ($doneCC) {
  $mcp = (claude mcp list 2>$null) -join "`n"
  if ($mcp -match "(?i)tavily|exa") {
    $names = @(); if ($mcp -match "(?i)tavily") { $names += "Tavily" }; if ($mcp -match "(?i)exa") { $names += "Exa" }
    Write-Host ("✓ 第 3 步  已配置联网搜索（" + ($names -join " ") + "）") -ForegroundColor Green
    $doneSearch = $true
  } else {
    Write-Host "✗ 第 3 步  还没配置联网搜索  → 运行 setup-search-mcp 脚本" -ForegroundColor Red
  }
} else {
  Write-Host "… 第 3 步  需先装好 Claude Code 才能检查搜索配置" -ForegroundColor Yellow
}

# 可选项
if (Get-Command lark-cli -ErrorAction SilentlyContinue) { Write-Host "✓ 可选    飞书 CLI 已安装" -ForegroundColor Green }
else { Write-Host "○ 可选    飞书 CLI 未安装（不影响主流程）" -ForegroundColor Yellow }

# cc-switch 安装名/路径在不同打包里写法不一（CC Switch / cc-switch），
# winget(MSI, user 域) 默认装到 %LocalAppData%\Programs\CC Switch。用通配匹配多处常见位置。
$switchPaths = @(
  "$env:LOCALAPPDATA\Programs\*[Ss]witch*",
  "$env:ProgramFiles\*CC*[Ss]witch*",
  "${env:ProgramFiles(x86)}\*CC*[Ss]witch*"
)
$hasSwitch = (Get-Command cc-switch -ErrorAction SilentlyContinue) -or ($switchPaths | Where-Object { Test-Path $_ })
if ($hasSwitch) {
  Write-Host "✓ 可选    cc-switch 已安装" -ForegroundColor Green
} else { Write-Host "○ 可选    cc-switch 未安装（不影响主流程）" -ForegroundColor Yellow }

Write-Host "────────────────────────────────────"

$core = @($doneCC, $doneApi, $doneSearch | Where-Object { $_ }).Count
if ($core -eq 3) {
  Write-Host ""
  Write-Host "   ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★" -ForegroundColor Green
  Write-Host "       🎉  YOU ARE A CC GENIUS!  🎉" -ForegroundColor Green
  Write-Host "   ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★ ☆ ★" -ForegroundColor Green
  Write-Host ""
  Write-Host "  三步全部完成，你的 Claude Code 已经满血上线 🚀"
  Write-Host "  现在打开终端输入  claude  开始你的第一段对话吧！"
} else {
  Write-Host ""
  Write-Host "进度：核心 3 步已完成 $core/3。按上面 ✗ 的提示继续即可。"
}
Write-Host ""
