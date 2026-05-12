$configs = @{
  "configs\nvim\vimrc" = ".vimrc"
  "configs\nvim\" = "AppData\Local\nvim"
  "configs\wezterm.lua" = ".wezterm.lua"
}

foreach ($config in $configs.GetEnumerator()) {
  $source = Join-Path -Path $env:USERPROFILE -ChildPath $config.Key
  $destination = Join-Path -Path $env:USERPROFILE -ChildPath $config.Value
  New-Item -Path $destination -ItemType SymbolicLink -Value $source -Force
}

# PowerShell profiles
$documentFolder = [environment]::getfolderpath("mydocuments")
$pwshProfile = "$documentFolder\PowerShell\Microsoft.PowerShell_profile.ps1"
$winpsProfile = "$documentFolder\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"

New-Item -ItemType Directory -Path (Split-Path $pwshProfile) -Force | Out-Null
New-Item -ItemType Directory -Path (Split-Path $winpsProfile) -Force | Out-Null

$pwshSource = Join-Path $env:USERPROFILE "configs\pwsh\profile.ps1"
$winpsSource = Join-Path $env:USERPROFILE "configs\pwsh\winps_profile.ps1"

function Insert-SourceLine($profilePath, $sourceLine) {
  if (!(Test-Path $profilePath)) {
    Set-Content -Path $profilePath -Value $sourceLine
    return
  }
  if (Select-String -Path $profilePath -SimpleMatch $sourceLine -Quiet) { return }
  $existing = Get-Content -Path $profilePath -Raw
  Set-Content -Path $profilePath -Value "$sourceLine`n$existing" -NoNewline
}

Insert-SourceLine $pwshProfile ". $pwshSource"
Insert-SourceLine $winpsProfile ". $winpsSource"

# Global Copilot instructions
if (!(Test-Path $env:USERPROFILE\.copilot)) {
  New-Item -ItemType Directory -Path $env:USERPROFILE\.copilot -Force | Out-Null
}
New-Item -Path $env:USERPROFILE\.copilot\copilot-instructions.md -ItemType HardLink -Value $env:USERPROFILE\configs\copilot-instructions.md -Force