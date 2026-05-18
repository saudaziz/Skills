param(
  [Parameter(Mandatory = $false)]
  [string]$RepoPath = ".",
  [Parameter(Mandatory = $false)]
  [string]$TemplateRoot = "",
  [switch]$Force
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($TemplateRoot)) {
  $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
  $TemplateRoot = Join-Path $scriptDir "..\templates"
}

function Write-Step([string]$msg) {
  Write-Host ("[bootstrap-repo] {0}" -f $msg)
}

function Ensure-Repo([string]$path) {
  if (-not (Test-Path (Join-Path $path ".git"))) {
    throw "Target is not a git repo: $path"
  }
}

function Ensure-Dir([string]$path) {
  if (-not (Test-Path $path)) {
    New-Item -ItemType Directory -Path $path -Force | Out-Null
  }
}

function Copy-IfMissing([string]$source, [string]$dest, [switch]$Overwrite) {
  Ensure-Dir (Split-Path -Parent $dest)
  if ((Test-Path $dest) -and -not $Overwrite) {
    Write-Step ("skip existing: {0}" -f $dest)
    return
  }
  Copy-Item -Path $source -Destination $dest -Force
  Write-Step ("wrote: {0}" -f $dest)
}

function Add-SnippetIfMissing([string]$targetFile, [string]$snippetFile, [string]$marker) {
  $snippet = Get-Content -Path $snippetFile -Raw
  if (-not (Test-Path $targetFile)) {
    Set-Content -Path $targetFile -Value $snippet
    Write-Step ("created: {0}" -f $targetFile)
    return
  }
  $content = Get-Content -Path $targetFile -Raw
  if ($content -match [Regex]::Escape($marker)) {
    Write-Step ("snippet exists: {0}" -f $targetFile)
    return
  }
  Add-Content -Path $targetFile -Value ("`r`n`r`n" + $snippet)
  Write-Step ("appended snippet: {0}" -f $targetFile)
}

$repo = (Resolve-Path $RepoPath).Path
$template = (Resolve-Path $TemplateRoot).Path

Ensure-Repo $repo

Write-Step ("repo: {0}" -f $repo)
Write-Step ("template: {0}" -f $template)

Copy-IfMissing (Join-Path $template "scripts\watch-session.ps1") (Join-Path $repo "scripts\watch-session.ps1") -Overwrite:$Force
Copy-IfMissing (Join-Path $template "scripts\new-issue-from-watch.ps1") (Join-Path $repo "scripts\new-issue-from-watch.ps1") -Overwrite:$Force
Copy-IfMissing (Join-Path $template "docs\qa\SESSION_WATCHER_WORKFLOW.md") (Join-Path $repo "docs\qa\SESSION_WATCHER_WORKFLOW.md") -Overwrite:$Force

Add-SnippetIfMissing (Join-Path $repo "AGENTS.md") (Join-Path $template "AGENTS.snippet.md") "## session watcher default"
Add-SnippetIfMissing (Join-Path $repo "README.md") (Join-Path $template "README_SNIPPET.md") "### Background Session Watcher (Default)"

Write-Step "done"
Write-Host ""
Write-Host "Run watcher with:"
Write-Host "powershell -ExecutionPolicy Bypass -File .\scripts\watch-session.ps1"
Write-Host ""
Write-Host "Generate issue drafts with:"
Write-Host "powershell -ExecutionPolicy Bypass -File .\scripts\new-issue-from-watch.ps1"
