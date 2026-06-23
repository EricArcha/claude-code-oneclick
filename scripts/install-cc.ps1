# install-cc.ps1 — 一键安装 / 升级最新版 Claude Code（Windows）
# 用法（在 PowerShell 中）：powershell -ExecutionPolicy Bypass -File install-cc.ps1
$ErrorActionPreference = 'Stop'

function Say($m)  { Write-Host "▶ $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "✓ $m" -ForegroundColor Green }
function Warn($m) { Write-Host "! $m" -ForegroundColor Yellow }
function Err($m)  { Write-Host "✗ $m" -ForegroundColor Red }

Write-Host ""
Say "开始安装最新版 Claude Code…"
Write-Host "  （这一步会从官方地址下载并安装，可能需要 1~3 分钟，请耐心等待）"
Write-Host ""

# 已安装则提示（原生安装包会自动后台更新）
$existing = Get-Command claude -ErrorAction SilentlyContinue
if ($existing) {
  $cur = (claude --version 2>$null)
  Ok "检测到已安装 Claude Code（版本：$cur）"
  Write-Host "  原生安装版本会自动在后台更新，通常无需手动操作。继续即可强制重装。"
  Write-Host ""
}

# 官方原生安装脚本（来源：https://code.claude.com/docs/en/setup.md）
try {
  Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
  Ok "安装脚本执行完成。"
} catch {
  Err "官方安装脚本执行失败：$($_.Exception.Message)"
  Write-Host "  备选方案（需先装好 Node.js 18+）："
  Write-Host "    npm install -g @anthropic-ai/claude-code"
  exit 1
}

Write-Host ""
$found = Get-Command claude -ErrorAction SilentlyContinue
if ($found) {
  $ver = (claude --version 2>$null)
  Ok "Claude Code 安装成功！版本：$ver"
  Write-Host ""
  Write-Host "下一步：配置你自己的 API（运行 config-api.ps1），然后输入 claude 启动。"
} else {
  Warn "安装似乎完成，但当前窗口还找不到 claude 命令。"
  Write-Host "  请【关闭并重新打开 PowerShell】后输入：claude --version"
}
Write-Host ""
