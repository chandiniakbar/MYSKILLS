# Sequential audit runner for repositories. Does not auto-commit, push, or deploy.
# First install OpenCode and authenticate a model provider, then run this script.
param(
  [string]$Workspace = "$HOME\AIProjects",
  [string[]]$Repos = @(
    "chandiniakbar/MYSKILLS",
    "chandiniakbar/remix-of-local-connect-hub"
  )
)
$ErrorActionPreference = "Stop"
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { throw "GitHub CLI (gh) not installed." }
if (-not (Get-Command opencode -ErrorAction SilentlyContinue)) { throw "OpenCode CLI not installed. Run npm install -g opencode-ai." }
New-Item -ItemType Directory -Force -Path $Workspace | Out-Null

$prompt = @'
Perform a careful repository audit ONLY. Do not edit files, commit, push, deploy, delete data, or expose secrets.
Inspect the project structure, README, package scripts, routes, UI, backend integrations, TODOs, test coverage, security, accessibility, and production readiness.
Do not read or output secret values from .env, credentials, tokens, or key files. Report if secret files are tracked and recommend rotation if exposure is possible.
Create a concise audit report in your response with:
1. project summary and stack
2. verified incomplete tasks, sorted P0/P1/P2
3. risks/blockers and evidence (file paths)
4. suggested implementation plan split into small milestones
5. commands to validate changes.
Do not assume mock data is real. Mark any unverified conclusions.
'@

foreach ($full in $Repos) {
  $name = ($full -split "/")[-1]
  $path = Join-Path $Workspace $name
  if (-not (Test-Path (Join-Path $path ".git"))) {
    gh repo clone $full $path
    if ($LASTEXITCODE -ne 0) { Write-Warning "Clone failed: $full"; continue }
  }
  Write-Host "`n===== AUDIT: $full =====" -ForegroundColor Cyan
  Push-Location $path
  try {
    opencode run $prompt
  } finally {
    Pop-Location
  }
}
