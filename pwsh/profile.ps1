using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Management.Automation.AliasInfo

Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineOption -PredictionViewStyle InlineView

Import-PowerShellDataFile "C:\Program Files\PowerShell\7\Modules\Microsoft.PowerShell.Utility\Microsoft.PowerShell.Utility.psd1" 2>&1 | Out-Null
Import-Module git-aliases -DisableNameChecking

$PSDefaultParameterValues['Out-Default:OutVariable'] = '__'

. ~/configs/pwsh/utilities.ps1
. ~/configs/pwsh/git.ps1
. ~/configs/pwsh/alias.ps1
. ~/configs/pwsh/chrome.ps1
. ~/configs/pwsh/ssh_awake.ps1

# nvs
$env:NVS_HOME="$env:LOCALAPPDATA\nvs"

## Rustup
$ENV:RUSTUP_DIST_SERVER='https://mirrors.ustc.edu.cn/rust-static'
$ENV:RUSTUP_UPDATE_ROOT='https://mirrors.ustc.edu.cn/rust-static/rustup'

# Source work-specific scripts if available (private repo)
if (Test-Path ~/work/work_profile.ps1) { . ~/work/work_profile.ps1 }
