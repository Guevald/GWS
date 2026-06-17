# setup.ps1 — GWS environment setup
# Run once per machine: .\setup.ps1
#
# What this does:
#   1. Verifies gws.exe is accessible (in PATH or local to this repo)
#   2. Verifies Google Cloud SDK (gcloud) is accessible
#   3. Reminds you to authenticate with gcloud if not done yet
#
# Binaries are NOT in this repo — transfer from another machine or
# follow the download instructions in GWS.md.

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── State tracking ───────────────────────────────────────────────────────────

$_stateFile = "$PSScriptRoot\.setup_state.json"
$_state = [ordered]@{}
if (Test-Path $_stateFile) {
    try {
        $raw = Get-Content $_stateFile -Raw | ConvertFrom-Json
        $raw.PSObject.Properties | ForEach-Object { $_state[$_.Name] = $_.Value }
    } catch {}
}

function Test-StepDone([string]$name) { return $_state.ContainsKey($name) }

function Register-Step([string]$name) {
    $now = Get-Date -Format 'yyyy-MM-ddTHH:mm:ss'
    if ($_state.ContainsKey($name)) {
        $_state[$name].runs++
        $_state[$name].lastRun = $now
    } else {
        $_state[$name] = [PSCustomObject]@{ firstRun = $now; lastRun = $now; runs = 1; machine = $env:COMPUTERNAME }
    }
}

function Save-SetupState {
    [PSCustomObject]$_state | ConvertTo-Json -Depth 3 | Set-Content $_stateFile -Encoding UTF8
}

function Show-SetupHints {
    $cutoff = (Get-Date).AddDays(-30)
    $stable = @()
    foreach ($k in $_state.Keys) {
        $s = $_state[$k]
        $runs = if ($s.PSObject.Properties['runs']) { $s.runs } else { 0 }
        $first = if ($s.PSObject.Properties['firstRun']) { [datetime]$s.firstRun } else { [datetime]::Now }
        if ($runs -ge 3 -and $first -lt $cutoff) { $stable += $k }
    }
    if ($stable.Count -eq 0) { return }
    Write-Host ""
    Write-Host "=== Setup cleanup hints ===" -ForegroundColor Magenta
    Write-Host "These steps have run 3+ times over 30+ days — consider removing them from setup.ps1:"
    foreach ($k in $stable) {
        $s = $_state[$k]
        $date = $s.firstRun.Substring(0, 10)
        Write-Host "  $k  (x$($s.runs), since $date, machine: $($s.machine))" -ForegroundColor DarkGray
    }
}

# ── Checks ───────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "=== GWS setup — machine: $env:COMPUTERNAME ===" -ForegroundColor Cyan

# Check gws CLI
Write-Host ""
Write-Host "--- gws CLI" -ForegroundColor Yellow
$gwsCmd = Get-Command gws -ErrorAction SilentlyContinue
if ($gwsCmd) {
    $gwsVer = & gws --version 2>&1
    Write-Host "  Found: $($gwsCmd.Source)"
    Write-Host "  Version: $gwsVer"
    Register-Step "gws_verified"
} else {
    # Try repo-local binary
    $localBin = "$PSScriptRoot\google-workspace-cli-x86_64-pc-windows-msvc\gws.exe"
    if (Test-Path $localBin) {
        Write-Host "  Found local binary: $localBin"
        Write-Host "  Not in PATH — add it with:"
        Write-Host "    [Environment]::SetEnvironmentVariable('PATH', `$env:PATH + ';$(Split-Path $localBin)', 'User')"
        Write-Host "  Then restart your terminal."
    } else {
        Write-Host "  gws not found." -ForegroundColor Red
        Write-Host "  Download from: https://github.com/googleworkspace/cli/releases"
        Write-Host "  Extract and add the binary folder to your User PATH."
        Write-Host "  See GWS.md for full instructions."
    }
}

# Check gcloud SDK
Write-Host ""
Write-Host "--- Google Cloud SDK (gcloud)" -ForegroundColor Yellow
$gcloudCmd = Get-Command gcloud -ErrorAction SilentlyContinue
if ($gcloudCmd) {
    $gcloudVer = & gcloud --version 2>&1 | Select-Object -First 1
    Write-Host "  Found: $($gcloudCmd.Source)"
    Write-Host "  Version: $gcloudVer"
    Register-Step "gcloud_verified"
} else {
    Write-Host "  gcloud not found." -ForegroundColor Red
    Write-Host "  Download from: https://cloud.google.com/sdk/docs/install"
    Write-Host "  Or use the bundled installer in google-cloud-cli-windows-x86_64/"
    Write-Host "  See GWS.md for full instructions."
}

# One-time: auth reminder
if (-not (Test-StepDone "auth_reminder_shown")) {
    Write-Host ""
    Write-Host "--- Authentication reminder (shown once)" -ForegroundColor Yellow
    Write-Host "  Run these once per machine to authenticate:"
    Write-Host "    gcloud auth login"
    Write-Host "    gcloud auth application-default login"
    Write-Host "    gws auth login"
    Write-Host "  Credentials are stored locally — never commit them."
    Register-Step "auth_reminder_shown"
}

Save-SetupState

Write-Host ""
Write-Host "=== Done ===" -ForegroundColor Green
Write-Host "  Open workspace: code `"$PSScriptRoot\GWS.code-workspace`""

Show-SetupHints
