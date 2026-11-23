# Windows AI coding-agent setup (PowerShell)
# Run in a normal PowerShell window. Review commands before executing.
$ErrorActionPreference = "Stop"

function Install-WingetPackage($Id) {
  $found = winget list --id $Id --exact 2>$null
  if ($LASTEXITCODE -eq 0 -and ($found -match $Id)) {
    Write-Host "$Id appears installed."
  } else {
    winget install --id $Id --exact --accept-package-agreements --accept-source-agreements
  }
}

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  throw "winget is not available. Install/update App Installer from Microsoft Store, then rerun."
}

Install-WingetPackage "Git.Git"
Install-WingetPackage "OpenJS.NodeJS.LTS"
Install-WingetPackage "GitHub.cli"

Write-Host "`nIf PATH has not refreshed, close and reopen PowerShell."
Write-Host "Next, run these commands:"
Write-Host "  npm install -g opencode-ai"
Write-Host "  gh auth login"
Write-Host "  opencode"
Write-Host "Inside OpenCode, use /connect to configure an AI provider."
Write-Host "Models/providers may have their own subscription or API costs."
