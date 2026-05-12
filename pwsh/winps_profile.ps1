Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

. ~/configs/pwsh/alias.ps1

# Source work-specific scripts if available (private repo)
if (Test-Path ~/work/work_profile.ps1) { . ~/work/work_profile.ps1 }
