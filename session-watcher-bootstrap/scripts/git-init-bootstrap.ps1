param(
  [Parameter(Mandatory = $true)]
  [string]$RepoPath,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$bootstrapRepo = Join-Path $scriptDir "bootstrap-repo.ps1"

if (-not (Test-Path $bootstrapRepo)) {
  throw "Missing bootstrap-repo.ps1: $bootstrapRepo"
}

if (-not (Test-Path $RepoPath)) {
  New-Item -ItemType Directory -Path $RepoPath -Force | Out-Null
}

$resolved = (Resolve-Path $RepoPath).Path
Push-Location $resolved
try {
  if (-not (Test-Path ".git")) {
    git init | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "git init failed" }
  }

  if ($Force) {
    powershell -ExecutionPolicy Bypass -File $bootstrapRepo -RepoPath $resolved -Force
  }
  else {
    powershell -ExecutionPolicy Bypass -File $bootstrapRepo -RepoPath $resolved
  }
}
finally {
  Pop-Location
}

Write-Host ""
Write-Host ("[init-bootstrap] ready: {0}" -f $resolved)
