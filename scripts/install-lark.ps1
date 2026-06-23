# install-lark.ps1 — 可选：安装飞书 CLI（lark-cli）并接入 Claude Code
# 用法：powershell -ExecutionPolicy Bypass -File install-lark.ps1
$ErrorActionPreference = 'Stop'

function Say($m)  { Write-Host "▶ $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "✓ $m" -ForegroundColor Green }
function Warn($m) { Write-Host "! $m" -ForegroundColor Yellow }
function Err($m)  { Write-Host "✗ $m" -ForegroundColor Red }

Write-Host ""
Say "安装飞书 CLI（lark-cli）"
Write-Host "  它把飞书 2500+ 接口收成 200+ 命令，并提供给 Claude Code 调用的 Skills。"
Write-Host "  官方文档： https://github.com/larksuite/cli"
Write-Host ""

if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
  Err "未检测到 Node.js / npx。请先安装 Node.js 18+（https://nodejs.org），再运行本脚本。"
  exit 1
}

Say "第 1 步：安装 lark-cli 本体…"
npx @larksuite/cli@latest install
if ($LASTEXITCODE -ne 0) { Err "安装失败，请检查网络后重试。"; exit 1 }
Ok "lark-cli 安装完成。"

Write-Host ""
Say "第 2 步：安装给 Claude Code 用的 Skills…"
npx skills add larksuite/cli -y -g
if ($LASTEXITCODE -ne 0) { Warn "Skills 安装未成功，可稍后手动重试：npx skills add larksuite/cli -y -g" }

Write-Host ""
Say "第 3 步：登录飞书账号（会打开浏览器授权）…"
Write-Host "  如不想现在登录，可关闭窗口跳过，之后随时运行： lark-cli auth login --recommend"
lark-cli auth login --recommend
if ($LASTEXITCODE -ne 0) { Warn "登录未完成，可稍后运行：lark-cli auth login --recommend" }

Write-Host ""
Ok "飞书 CLI 配置流程结束。本地备份说明见 docs\lark-cli.md。"
Write-Host ""
