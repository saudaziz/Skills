$ErrorActionPreference = "Stop"

param(
  [int]$Tail = 200
)

$root = (Get-Location).Path
$watchLog = Join-Path $root ".devshop\runtime-logs\qa-watch.log"
$issuesDir = Join-Path $root ".devshop\issues"

if (-not (Test-Path $watchLog)) {
  throw "Watcher log not found: $watchLog"
}

New-Item -ItemType Directory -Path $issuesDir -Force | Out-Null

$lines = Get-Content -Path $watchLog -Tail $Tail
$hits = $lines | Where-Object { $_ -match "\[(ERROR|CRITICAL)\]" }

if (-not $hits) {
  Write-Host "No ERROR/CRITICAL lines found in last $Tail entries."
  exit 0
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$out = Join-Path $issuesDir ("issue-draft-{0}.md" -f $stamp)

$body = @()
$body += "# Watcher Issue Draft"
$body += ""
$body += "Generated: $(Get-Date -Format s)"
$body += "Source: .devshop/runtime-logs/qa-watch.log"
$body += ""
$body += "## Findings"
$body += ""
foreach ($h in $hits) { $body += "- $h" }
$body += ""
$body += "## Suggested Repro"
$body += ""
$body += "1. Navigate full flow: intake -> blueprint -> review -> approve -> execution."
$body += "2. Note exact timestamp when failure appears in UI."
$body += "3. Correlate with .devshop/artifacts/logs/runtime.jsonl entries around that timestamp."

Set-Content -Path $out -Value ($body -join "`r`n")
Write-Host ("Issue draft created: {0}" -f $out)
