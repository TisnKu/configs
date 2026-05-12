$configRoot = Join-Path $HOME "configs"

$configs = @{
  "nvim\vimrc" = ".vimrc"
  "nvim\" = "AppData\Local\nvim"
  "wezterm.lua" = ".wezterm.lua"
}

function Test-IsAdmin {
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal]::new($identity)
  return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function New-Link {
  param(
    [string]$Path,
    [ValidateSet("SymbolicLink", "HardLink")]
    [string]$ItemType,
    [string]$Value
  )

  $parent = Split-Path -Path $Path -Parent
  if ($parent) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }

  if (Test-Path -LiteralPath $Path) {
    Write-Host "Removing existing path: $Path"
    Remove-Item -LiteralPath $Path -Recurse -Force
  }

  Write-Host "Creating ${ItemType}: $Path -> $Value"
  New-Item -Path $Path -ItemType $ItemType -Value $Value -Force | Out-Null
}

if (-not (Test-IsAdmin)) {
  Write-Host "Restarting sync.ps1 in an elevated PowerShell window..."
  Start-Process -FilePath "pwsh.exe" -ArgumentList @("-NoProfile", "-NoExit", "-File", $PSCommandPath) -Verb RunAs | Out-Null
  return
}

Write-Host "Running sync.ps1 as administrator..."

foreach ($config in $configs.GetEnumerator()) {
  $source = Join-Path -Path $configRoot -ChildPath $config.Key
  $destination = Join-Path -Path $env:USERPROFILE -ChildPath $config.Value
  New-Link -Path $destination -ItemType SymbolicLink -Value $source
}

# PowerShell profiles
$documentFolder = [environment]::getfolderpath("mydocuments")
$pwshProfile = "$documentFolder\PowerShell\Microsoft.PowerShell_profile.ps1"
$winpsProfile = "$documentFolder\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

New-Item -ItemType Directory -Path (Split-Path $pwshProfile) -Force | Out-Null
New-Item -ItemType Directory -Path (Split-Path $winpsProfile) -Force | Out-Null

$pwshSource = Join-Path $configRoot "pwsh\profile.ps1"
$winpsSource = Join-Path $configRoot "pwsh\winps_profile.ps1"

function Insert-SourceLine($profilePath, $sourceLine) {
  if (!(Test-Path $profilePath)) {
    Write-Host "Creating profile: $profilePath"
    Set-Content -Path $profilePath -Value $sourceLine
    return
  }
  if (Select-String -Path $profilePath -SimpleMatch $sourceLine -Quiet) {
    Write-Host "Profile already configured: $profilePath"
    return
  }
  $existing = Get-Content -Path $profilePath -Raw
  Write-Host "Updating profile: $profilePath"
  Set-Content -Path $profilePath -Value "$sourceLine`n$existing" -NoNewline
}

Insert-SourceLine $pwshProfile ". $pwshSource"
Insert-SourceLine $winpsProfile ". $winpsSource"

# Global Copilot instructions
if (!(Test-Path $env:USERPROFILE\.copilot)) {
  New-Item -ItemType Directory -Path $env:USERPROFILE\.copilot -Force | Out-Null
}
New-Link -Path "$env:USERPROFILE\.copilot\copilot-instructions.md" -ItemType HardLink -Value (Join-Path $configRoot "copilot-instructions.md")

Write-Host "sync.ps1 completed successfully."
