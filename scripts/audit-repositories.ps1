# Sequential repository audit runner; audit-only, no edits/commits/push/deploy.
param(
  [string]$Workspace = "$HOME\AIProjects",
  [ValidateSet("codex","opencode")][string]$Agent = "codex",
  [string[]]$Repos = @("chandiniakbar/MYSKILLS","chandiniakbar/remix-of-local-connect-hub")
)
$ErrorActionPreference = "Stop"
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw "GitHub CLI (gh) is missing." }
if (-not (Get-Command $Agent -ErrorAction SilentlyContinue)) { throw "$Agent CLI is missing. Run setup-ai-cli.ps1 and install it." }
New-Item -ItemType Directory -Force -Path $Workspace | Out-Null
$prompt = @'
Audit this repository ONLY. Do not modify files, commit, push, deploy, delete data, or expose secrets.
Review structure, README, scripts, dependencies, routes, UI, backend, TODOs, tests, security, accessibility and production readiness.
Do not open, print or copy secret values from .env, credentials, tokens, or keys. Note tracked sensitive files and advise rotation if exposure is possible.
Respond with: verified project summary; incomplete tasks sorted P0/P1/P2 with file evidence; blockers and risks; milestone implementation plan; test/build/lint commands; clear uncertainty labels. Never present sample data as real.
'@
foreach ($full in $Repos) {
  $repoName = ($full -split "/")[-1]
  $dir = Join-Path $Workspace $repoName
  if (-not (Test-Path (Join-Path $dir ".git"))) {
    gh repo clone $full $dir
    if ($LASTEXITCODE -ne 0) { Write-Warning "Clone failed: $full"; continue }
  }
  Write-Host "`n===== $Agent AUDIT: $full =====" -ForegroundColor Cyan
  Push-Location $dir
  try {
    if ($Agent -eq "codex") { codex exec --sandbox read-only --ask-for-approval never $prompt }
    else { opencode run $prompt }
  } finally { Pop-Location }
}
