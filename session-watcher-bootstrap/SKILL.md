---
name: session-watcher-bootstrap
description: Bootstrap watcher/session logging defaults for a repo, multiple repos, or new repos with reusable scripts and templates.
---

# Session Watcher Bootstrap Skill

Use this skill when the user asks to set up watcher/session logging defaults in a repo, across multiple repos, or for all future projects.

## What this skill provides
- Repo bootstrap script: `scripts/bootstrap-repo.ps1`
- Multi-repo bootstrap script: `scripts/bootstrap-all-repos.ps1`
- Clone wrapper with auto-bootstrap: `scripts/git-clone-bootstrap.ps1`
- Init wrapper with auto-bootstrap: `scripts/git-init-bootstrap.ps1`
- PowerShell alias installer: `scripts/install-auto-triggers.ps1`
- Reusable templates for `AGENTS.md`, `README.md`, watcher scripts, and QA workflow docs.

## Usage

### Bootstrap current repo
```powershell
powershell -ExecutionPolicy Bypass -File "$HOME/.codex/skills/session-watcher-bootstrap/scripts/bootstrap-repo.ps1" -RepoPath (Get-Location)
```

### Bootstrap all repos under a workspace root
```powershell
powershell -ExecutionPolicy Bypass -File "$HOME/.codex/skills/session-watcher-bootstrap/scripts/bootstrap-all-repos.ps1" -Root "D:\Code"
```

### Auto-bootstrap while cloning
```powershell
powershell -ExecutionPolicy Bypass -File "$HOME/.codex/skills/session-watcher-bootstrap/scripts/git-clone-bootstrap.ps1" -RepoUrl "https://github.com/org/repo.git" -Destination "repo"
```

### Auto-bootstrap while creating a new repo
```powershell
powershell -ExecutionPolicy Bypass -File "$HOME/.codex/skills/session-watcher-bootstrap/scripts/git-init-bootstrap.ps1" -RepoPath "D:\Code\new-repo"
```

### Install convenient global aliases (gclonew/ginitw)
```powershell
powershell -ExecutionPolicy Bypass -File "$HOME/.codex/skills/session-watcher-bootstrap/scripts/install-auto-triggers.ps1"
. $PROFILE.CurrentUserAllHosts
```

Then use:
```powershell
gclonew https://github.com/org/repo.git repo
ginitw D:\Code\another-new-repo
```

### Force overwrite template-managed files
```powershell
powershell -ExecutionPolicy Bypass -File "$HOME/.codex/skills/session-watcher-bootstrap/scripts/bootstrap-repo.ps1" -RepoPath (Get-Location) -Force
```

## Behavior
- Adds if missing:
  - `scripts/watch-session.ps1`
  - `scripts/new-issue-from-watch.ps1`
  - `docs/qa/SESSION_WATCHER_WORKFLOW.md`
  - `AGENTS.md` watcher section
  - `README.md` watcher section
- Does not duplicate sections if already present.
- Keeps edits minimal and reversible.

## Notes
- This is intentionally repo-local output, but globally invokable from your CLI.
- Works for Codex workflows; generated repo files are usable from Gemini CLI and Claude CLI.

