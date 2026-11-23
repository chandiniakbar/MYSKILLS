# Windows AI CLI Toolkit

A Lovable-credit-free local workflow using GitHub + OpenCode CLI.

## Setup
1. Open PowerShell and run `scripts/setup-ai-cli.ps1`.
2. Close/reopen PowerShell to refresh PATH.
3. Run `npm install -g opencode-ai`.
4. Run `gh auth login` and authenticate to GitHub.
5. Run `opencode`, then `/connect` to configure your model provider. AI inference may still incur provider fees.

## Audit repositories first
Run:

```powershell
.\scripts\audit-repositories.ps1
```

This clones the selected repos to `$HOME\AIProjects` and runs an audit-only prompt. It does not write changes, commit, push, or deploy. You may edit the `Repos` parameter to include additional repos.

## Implementation workflow
After reviewing each audit report, start OpenCode in that repo interactively and give it one P1 task at a time. Require it to run relevant tests/build/lint, review the diff, and create a feature branch. Do not permit secrets or production changes. Keep merges/deploys manual.
