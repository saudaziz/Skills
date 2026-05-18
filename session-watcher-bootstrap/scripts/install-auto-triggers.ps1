param()

$ErrorActionPreference = "Stop"

$profilePath = $PROFILE.CurrentUserAllHosts
$skillScripts = "$HOME/.codex/skills/session-watcher-bootstrap/scripts"

if (-not (Test-Path (Split-Path -Parent $profilePath))) {
  New-Item -ItemType Directory -Path (Split-Path -Parent $profilePath) -Force | Out-Null
}
if (-not (Test-Path $profilePath)) {
  New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

$marker = "# session-watcher-bootstrap aliases"
$content = Get-Content -Path $profilePath -Raw
if ($content -notmatch [Regex]::Escape($marker)) {
  Add-Content -Path $profilePath -Value @"

$marker
function gclonew {
  param([string]`$RepoUrl, [string]`$Destination = "")
  powershell -ExecutionPolicy Bypass -File "$skillScripts/git-clone-bootstrap.ps1" -RepoUrl `$RepoUrl -Destination `$Destination
}

function ginitw {
  param([string]`$RepoPath)
  powershell -ExecutionPolicy Bypass -File "$skillScripts/git-init-bootstrap.ps1" -RepoPath `$RepoPath
}
"@
  Write-Host "Aliases added to $profilePath"
}
else {
  Write-Host "Aliases already configured in $profilePath"
}

Write-Host "Reload shell or run: . $profilePath"
Write-Host "Use: gclonew <repo-url> [dest]"
Write-Host "Use: ginitw <repo-path>"
