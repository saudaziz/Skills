param(
  [Parameter(Mandatory = $true)]
  [string]$Root,
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$bootstrapRepo = Join-Path $scriptDir "bootstrap-repo.ps1"

if (-not (Test-Path $bootstrapRepo)) {
  throw "Missing bootstrap-repo.ps1: $bootstrapRepo"
}

$rootPath = (Resolve-Path $Root).Path
Write-Host ("[bootstrap-all] scanning: {0}" -f $rootPath)

$repos = Get-ChildItem -Path $rootPath -Directory -Recurse -Force -ErrorAction SilentlyContinue |
  Where-Object { Test-Path (Join-Path $_.FullName ".git") } |
  Select-Object -ExpandProperty FullName

if (-not $repos) {
  Write-Host "[bootstrap-all] no repositories found"
  exit 0
}

$ok = 0
$fail = 0
foreach ($repo in $repos) {
  Write-Host ("[bootstrap-all] repo: {0}" -f $repo)
  try {
    if ($Force) {
      powershell -ExecutionPolicy Bypass -File $bootstrapRepo -RepoPath $repo -Force
    }
    else {
      powershell -ExecutionPolicy Bypass -File $bootstrapRepo -RepoPath $repo
    }
    $ok++
  }
  catch {
    Write-Host ("[bootstrap-all] failed: {0}" -f $_.Exception.Message)
    $fail++
  }
}

Write-Host ""
Write-Host ("[bootstrap-all] complete. success={0} fail={1}" -f $ok, $fail)
