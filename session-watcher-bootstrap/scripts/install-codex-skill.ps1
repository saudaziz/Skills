param(
  [string]$CodexSkillsHome = "$env:USERPROFILE/.codex/skills",
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$source = Resolve-Path "./session-watcher-bootstrap"
$target = Join-Path $CodexSkillsHome "session-watcher-bootstrap"

if ((Test-Path $target) -and -not $Force) {
  throw "Target already exists: $target. Re-run with -Force to overwrite."
}

New-Item -ItemType Directory -Force -Path $CodexSkillsHome | Out-Null
if (Test-Path $target) { Remove-Item -Recurse -Force $target }
Copy-Item -Recurse -Force -Path $source -Destination $target

Write-Host "Installed session-watcher-bootstrap skill to $target"
Write-Host "Restart your CLI session if it caches skills."
