param(
  [string]$TargetRoot = ".",
  [string]$DevelopBase = "main"
)

$ErrorActionPreference = "Stop"

$root = Resolve-Path $TargetRoot
Set-Location $root

if (-not (Test-Path ".git")) {
  git init | Out-Null
}

$hasDevelop = git branch --list develop
if ([string]::IsNullOrWhiteSpace($hasDevelop)) {
  $hasBase = git branch --list $DevelopBase
  if ([string]::IsNullOrWhiteSpace($hasBase)) {
    try {
      git checkout -b develop | Out-Null
    } catch {
      git checkout --orphan develop | Out-Null
    }
  } else {
    git checkout -b develop $DevelopBase | Out-Null
  }
} else {
  git checkout develop | Out-Null
}

$stateDir = Join-Path $root "DevTasks/state"
New-Item -ItemType Directory -Force -Path $stateDir | Out-Null

$templateDir = Join-Path $root "DevTasks/templates"
Copy-Item -LiteralPath (Join-Path $templateDir "plan_of_action.md") -Destination (Join-Path $stateDir "PLAN_OF_ACTION.md") -Force
Copy-Item -LiteralPath (Join-Path $templateDir "qa_baseline_log.md") -Destination (Join-Path $stateDir "QA_BASELINE_LOG.md") -Force
Copy-Item -LiteralPath (Join-Path $templateDir "task_board.md") -Destination (Join-Path $stateDir "TASK_BOARD.md") -Force
Copy-Item -LiteralPath (Join-Path $templateDir "plan_hygiene.md") -Destination (Join-Path $stateDir "PLAN_HYGIENE.md") -Force

Write-Host "DevTasks initialized at $root"
Write-Host "Active branch: $(git branch --show-current)"
Write-Host "State files created under DevTasks/state"
