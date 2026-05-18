# Session Watcher Bootstrap Skill

This package bootstraps watcher/session logging defaults for one repo, many repos, or newly created repos.

## Repository Layout

- `session-watcher-bootstrap/SKILL.md`: Skill behavior and usage contract.
- `session-watcher-bootstrap/scripts/bootstrap-repo.ps1`: Bootstrap a single repository.
- `session-watcher-bootstrap/scripts/bootstrap-all-repos.ps1`: Bootstrap many repositories under one root.
- `session-watcher-bootstrap/scripts/git-clone-bootstrap.ps1`: Clone + bootstrap wrapper.
- `session-watcher-bootstrap/scripts/git-init-bootstrap.ps1`: Init + bootstrap wrapper.
- `session-watcher-bootstrap/scripts/install-auto-triggers.ps1`: Installs global PowerShell aliases.
- `session-watcher-bootstrap/scripts/install-codex-skill.ps1`: Installs this skill into local Codex skills folder.
- `session-watcher-bootstrap/templates/`: Reusable snippets and watcher scripts.

## Install From GitHub

```powershell
git clone https://github.com/saudaziz/Skills.git
cd .\Skills
powershell -ExecutionPolicy Bypass -File .\session-watcher-bootstrap\scripts\install-codex-skill.ps1
```

After install, invoke it using `$session-watcher-bootstrap` in Codex prompts.

## Script Usage

From repo root:

```powershell
powershell -ExecutionPolicy Bypass -File .\session-watcher-bootstrap\scripts\bootstrap-repo.ps1 -RepoPath (Get-Location)
```

```powershell
powershell -ExecutionPolicy Bypass -File .\session-watcher-bootstrap\scripts\bootstrap-all-repos.ps1 -Root "D:\Code"
```

```powershell
powershell -ExecutionPolicy Bypass -File .\session-watcher-bootstrap\scripts\git-clone-bootstrap.ps1 -RepoUrl "https://github.com/org/repo.git" -Destination "repo"
```

```powershell
powershell -ExecutionPolicy Bypass -File .\session-watcher-bootstrap\scripts\git-init-bootstrap.ps1 -RepoPath "D:\Code\new-repo"
```

## Notes

- Template-managed files are inserted only if missing unless `-Force` is used.
- Generated watcher outputs are repo-local and can be used from Codex, Gemini CLI, or Claude CLI.
