$ErrorActionPreference = "Stop"

$root = (Get-Location).Path
$runtimeDir = Join-Path $root ".devshop\runtime-logs"
$artifactDir = Join-Path $root ".devshop\artifacts\logs"
$artifactLog = Join-Path $artifactDir "runtime.jsonl"
$watchLog = Join-Path $runtimeDir "qa-watch.log"
$maxBytes = 10MB

New-Item -ItemType Directory -Path $runtimeDir -Force | Out-Null
New-Item -ItemType Directory -Path $artifactDir -Force | Out-Null
if (-not (Test-Path $artifactLog)) { New-Item -ItemType File -Path $artifactLog -Force | Out-Null }

function Rotate-LogIfNeeded {
  if (Test-Path $watchLog) {
    $size = (Get-Item $watchLog).Length
    if ($size -ge $maxBytes) {
      $bak = "$watchLog.1"
      if (Test-Path $bak) { Remove-Item $bak -Force }
      Move-Item -Path $watchLog -Destination $bak -Force
    }
  }
}

function Severity([string]$line) {
  if ($line -match 'CRITICAL|panic|fatal|unhandled|ERR_CONNECTION_REFUSED') { return 'CRITICAL' }
  if ($line -match 'ERROR|Failed to|No active session found|Http failure during parsing|status_code.?[:=].?404|status_code.?[:=].?409') { return 'ERROR' }
  if ($line -match 'WARN|Trying to reconnect|timeout|retry') { return 'WARN' }
  return 'INFO'
}

function Emit([string]$source, [string]$pattern, [string]$line) {
  Rotate-LogIfNeeded
  $sev = Severity $line
  $msg = "[{0}] [{1}] [src:{2}] [match:{3}] {4}" -f (Get-Date).ToString("s"), $sev, $source, $pattern, $line
  Add-Content -Path $watchLog -Value $msg
  Write-Output $msg
}

$patterns = @(
  "Trying to reconnect",
  "No active session found",
  "ERR_CONNECTION_REFUSED",
  "Http failure during parsing",
  "Failed to",
  "status_code",
  "404",
  "409",
  "timeout",
  "retry"
)

$targets = @(
  (Join-Path $runtimeDir "api.out.log"),
  (Join-Path $runtimeDir "api.err.log"),
  (Join-Path $runtimeDir "ui.out.log"),
  (Join-Path $runtimeDir "ui.err.log"),
  (Join-Path $runtimeDir "ng.out.log"),
  (Join-Path $runtimeDir "ng.err.log"),
  $artifactLog
)

foreach ($t in $targets) {
  if (-not (Test-Path $t)) { New-Item -ItemType File -Path $t -Force | Out-Null }
}

Emit "watcher" "startup" "Watcher started"
Emit "watcher" "sources" ($targets -join ", ")

foreach ($t in $targets) {
  Start-Job -ScriptBlock {
    param($path, $watchPath, $matchPatterns)

    function Severity([string]$line) {
      if ($line -match 'CRITICAL|panic|fatal|unhandled|ERR_CONNECTION_REFUSED') { return 'CRITICAL' }
      if ($line -match 'ERROR|Failed to|No active session found|Http failure during parsing|status_code.?[:=].?404|status_code.?[:=].?409') { return 'ERROR' }
      if ($line -match 'WARN|Trying to reconnect|timeout|retry') { return 'WARN' }
      return 'INFO'
    }

    Get-Content -Path $path -Wait | ForEach-Object {
      $line = $_
      foreach ($p in $matchPatterns) {
        if ($line -match $p) {
          $sev = Severity $line
          $msg = "[{0}] [{1}] [src:{2}] [match:{3}] {4}" -f (Get-Date).ToString("s"), $sev, $path, $p, $line
          Add-Content -Path $watchPath -Value $msg
        }
      }
    }
  } -ArgumentList $t, $watchLog, $patterns | Out-Null
}

Write-Host "Watcher running. Press Ctrl+C to stop."
while ($true) { Start-Sleep -Seconds 5 }
