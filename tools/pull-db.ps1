<#
.SYNOPSIS
    Pulls the Markazosshabab on-device SQLite database out of a running
    Android emulator/device into a local folder for inspection in
    DB Browser for SQLite.

.DESCRIPTION
    The app stores its database (drift, WAL mode) in the app-private folder:
        /data/data/com.markazosshabab.markazosshababApp/app_flutter/markaz_archive.sqlite
    plus the WAL sidecars (-wal / -shm) which hold the most recent writes.

    This script copies all three out. It first tries `adb root` (works on
    standard, non-Play-Store emulator images). If root is unavailable it falls
    back to `run-as`, which works because the debug build is debuggable.

.PARAMETER OutDir
    Destination folder. Defaults to <repo-root>/db-dump. Created if missing.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools/pull-db.ps1

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File tools/pull-db.ps1 -OutDir C:\temp\markaz-db
#>

[CmdletBinding()]
param(
    [string]$OutDir = (Join-Path $PSScriptRoot '..\db-dump')
)

$ErrorActionPreference = 'Stop'

$package   = 'com.markazosshabab.markazosshababApp'
$remoteDir = "/data/data/$package/app_flutter"
$dbFile    = 'markaz_archive.sqlite'
$files     = @($dbFile, "$dbFile-wal", "$dbFile-shm")

# --- Locate adb -----------------------------------------------------------
$adb = (Get-Command adb -ErrorAction SilentlyContinue).Source
if (-not $adb) {
    $candidate = Join-Path $env:LOCALAPPDATA 'Android\Sdk\platform-tools\adb.exe'
    if (Test-Path $candidate) { $adb = $candidate }
}
if (-not $adb) {
    Write-Error "adb not found. Add the Android SDK's platform-tools to PATH, or install it via Android Studio."
    exit 1
}

# --- Require a connected device ------------------------------------------
$connected = (& $adb devices) | Select-String -Pattern '\bdevice$'
if (-not $connected) {
    Write-Error "No device/emulator detected. Start your emulator (and launch the app once so the database exists), then retry."
    exit 1
}

# --- Prepare output folder -----------------------------------------------
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null
$OutDir = (Resolve-Path $OutDir).Path
Write-Host "Pulling database into: $OutDir"

# --- Try to gain root, then probe the private dir ------------------------
$rootOk = $false
try {
    & $adb root | Out-Null
    & $adb wait-for-device
    & $adb shell "ls $remoteDir" 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) { $rootOk = $true }
} catch {
    $rootOk = $false
}
Write-Host ("Access mode: {0}" -f ($(if ($rootOk) { 'adb root' } else { 'run-as (no root)' })))

# --- Copy each file -------------------------------------------------------
$gotMain = $false
foreach ($f in $files) {
    $local = Join-Path $OutDir $f

    if (Test-Path $local) { Remove-Item $local -Force }

    if ($rootOk) {
        # adb pull writes the file itself - safe for binary.
        & $adb pull "$remoteDir/$f" "$local" 2>$null | Out-Null
    } else {
        # run-as streams the bytes; use cmd.exe redirection so PowerShell does
        # NOT re-encode the binary stream (PS 5.1 '>' would corrupt it).
        & cmd.exe /c "`"$adb`" exec-out run-as $package cat `"app_flutter/$f`" > `"$local`"" 2>$null
    }

    if ((Test-Path $local) -and ((Get-Item $local).Length -gt 0)) {
        Write-Host ("  pulled  {0}  ({1:N0} bytes)" -f $f, (Get-Item $local).Length)
        if ($f -eq $dbFile) { $gotMain = $true }
    } else {
        # -wal / -shm may legitimately be absent (DB checkpointed/closed).
        if (Test-Path $local) { Remove-Item $local -Force }
        Write-Host ("  skipped {0}  (not present)" -f $f)
    }
}

Write-Host ""
if (-not $gotMain) {
    Write-Error "Failed to pull $dbFile. Make sure the app has been launched at least once on this device."
    exit 1
}

Write-Host "Done. Open this file in DB Browser for SQLite:"
Write-Host ("  " + (Join-Path $OutDir $dbFile))
Write-Host "Keep the -wal/-shm files next to it so the latest writes are visible."
