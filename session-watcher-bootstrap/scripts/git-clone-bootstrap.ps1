param(
  [Parameter(Mandatory = $true)]
  [string]$RepoUrl,
  [Parameter(Mandatory = $false)]
  [string]$Destination = "",
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$bootstrapRepo = Join-Path $scriptDir "bootstrap-repo.ps1"

if (-not (Test-Path $bootstrapRepo)) {
  throw "Missing bootstrap-repo.ps1: $bootstrapRepo"
}

if ([string]::IsNullOrWhiteSpace($Destination)) {
  git clone $RepoUrl
}
else {
  git clone $RepoUrl $Destination
}

if ($LASTEXITCODE -ne 0) {
  throw "git clone failed"
}

$repoPath = ""
if (-not [string]::IsNullOrWhiteSpace($Destination)) {
  $repoPath = (Resolve-Path $Destination).Path
}
else {
  $name = [System.IO.Path]::GetFileNameWithoutExtension($RepoUrl)
  if ($name -eq "") { throw "Cannot infer repo folder from URL; pass -Destination." }
  $repoPath = (Resolve-Path $name).Path
}

if ($Force) {
  powershell -ExecutionPolicy Bypass -File $bootstrapRepo -RepoPath $repoPath -Force
}
else {
  powershell -ExecutionPolicy Bypass -File $bootstrapRepo -RepoPath $repoPath
}

Write-Host ""
Write-Host ("[clone-bootstrap] ready: {0}" -f $repoPath)
