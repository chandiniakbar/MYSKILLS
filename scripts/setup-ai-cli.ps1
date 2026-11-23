# Install prerequisites for OpenCode and OpenAI Codex CLI on Windows.
# Run in PowerShell. Re-open the terminal after installation if PATH changes.
$ErrorActionPreference = "Stop"
function Install-WingetPackage($Id) {
  $listed = winget list --id $Id --exact 2>$null
  if ($LASTEXITCODE -eq 0 -and ($listed -match $Id)) {
    Write-Host "$Id appears installed."
  } else {
    winget install --id $Id --exact --accept-package-agreements --accept-source-agreements
  }
}
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  throw "winget is unavailable. Install/update App Installer, then rerun."
}
Install-WingetPackage "Git.Git"
Install-WingetPackage "OpenJS.NodeJS.LTS"
Install-WingetPackage "GitHub.cli"
Write-Host "`nInstall coding agents:"
Write-Host "  npm install -g opencode-ai"
Write-Host "  npm install -g @openai/codex"
Write-Host "`nAuthenticate:"
Write-Host "  gh auth login"
Write-Host "  codex  # sign in with ChatGPT, or configure API access"
Write-Host "  opencode  # use /connect to configure provider"
Write-Host "Codex CLI can use ChatGPT sign-in or API credentials depending on access."
Write-Host "API usage may incur separate costs; never paste API keys into repository files."
