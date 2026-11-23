# Windows AI CLI Toolkit

A local development workflow using GitHub + OpenAI Codex CLI and OpenCode.

## Install
1. Open PowerShell and run `scripts/setup-ai-cli.ps1`.
2. Restart PowerShell if PATH does not refresh.
3. Install both agents:
   `npm install -g @openai/codex`
   `npm install -g opencode-ai`
4. Authenticate GitHub: `gh auth login`.
5. Run `codex` and sign in with ChatGPT where available, or configure API access.
6. Run `opencode`, then `/connect` to configure a provider.

Model access may be subject to subscription limits or separate API usage fees. Do not store credentials in project files.

## Audit only
Run a Codex audit (default):
```powershell
.\scripts\audit-repositories.ps1
```
Or use OpenCode:
```powershell
.\scripts\audit-repositories.ps1 -Agent opencode
```
The script clones selected repos under `$HOME\AIProjects` and runs a read-only audit prompt. It does not edit, commit, push, deploy or delete. Pass a custom list with `-Repos @("owner/repo")`.

## Build workflow
After reviewing the audit, run Codex or OpenCode interactively in the repo. Work one prioritized task at a time, require tests/build/lint, review diffs, use a feature branch, and keep merge/deployment manual.
