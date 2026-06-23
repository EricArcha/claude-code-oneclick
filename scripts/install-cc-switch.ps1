# install-cc-switch.ps1 — 可选：安装 cc-switch（图形界面，便捷切换 Claude Code 后台 API）
# 用法：powershell -ExecutionPolicy Bypass -File install-cc-switch.ps1
$ErrorActionPreference = 'Stop'

function Say($m)  { Write-Host "▶ $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "✓ $m" -ForegroundColor Green }
function Warn($m) { Write-Host "! $m" -ForegroundColor Yellow }

Write-Host ""
Say "安装 cc-switch（图形界面 App）"
Write-Host "  作用：一键切换 Claude Code / Codex / Gemini 等工具的后台 API，统一管理 MCP。"
Write-Host "  官网： https://ccswitch.io     源码： https://github.com/farion1231/cc-switch"
Write-Host ""

if (Get-Command winget -ErrorAction SilentlyContinue) {
  Say "检测到 winget，尝试安装…"
  # 用官方包标识 farion1231.CC-Switch（-e 精确匹配），避免按名字 "cc-switch" 搜出歧义或匹配不到
  winget install --id farion1231.CC-Switch -e --accept-source-agreements --accept-package-agreements
  if ($LASTEXITCODE -eq 0) {
    Ok "安装完成！在开始菜单里打开 cc-switch 即可。"
  } else {
    Warn "winget 未能安装（可能未上架）。请到发布页手动下载 .msi 安装包："
    Write-Host "    https://github.com/farion1231/cc-switch/releases"
  }
} else {
  Warn "未检测到 winget。请到发布页手动下载安装包（选 Windows 的 .msi）："
  Write-Host "    https://github.com/farion1231/cc-switch/releases"
}
Write-Host ""
Write-Host "提示：cc-switch 是「高级可选项」。只想用一个固定 API 的话，config-api.ps1 就够了。"
Write-Host "本地备份说明见 docs\cc-switch.md。"
Write-Host ""
