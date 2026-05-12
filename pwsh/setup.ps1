# This script helps to setup a new machine with all the required tools and configurations

Write-Host "Login to MS store to unblock msstore installation."
Write-Host "Press any key to install pwsh and git via winget..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

function runInPwsh($command, $wait = $true, $asAdmin = $false)
{
  $wrappedCommand = @"
    try
    {
      $command
    } catch
    {
      Write-Host "Error executing command: $command"
      Write-Host "Press Enter to continue..."
      [void][System.Console]::ReadLine()
    }
"@

  $startProcessParams = @{
    FilePath     = "pwsh.exe"
    ArgumentList = "-noprofile -Command `"$wrappedCommand`""
    Wait         = $wait
  }
  if ($asAdmin)
  { $startProcessParams.Verb = "RunAs" 
  }

  $process = Start-Process @startProcessParams
  return $process
}

winget install WingetPathUpdater
winget install Microsoft.PowerShell

# Generate ssh key
if (!(Test-Path $HOME/.ssh/id_rsa))
{
  $command=@"
    ssh-keygen -f $HOME/.ssh/id_rsa -N '' -t rsa -b 4096;
    winget install GitHub.cli;
    gh auth login;
    gh auth refresh -h github.com -s admin:public_key;
    gh ssh-key add $HOME/.ssh/id_rsa.pub --type authentication;
"@;
  runInPwsh $command
}

# Git configuration
winget install Git.Git
git config --global user.name "TK"
$repos = @(
  @{ path = "$HOME/configs"; url = "git@github.com:TisnKu/configs.git" },
  @{ path = "$HOME/work"; url = "git@github.com:TisnKu/work.git" },
  @{ path = "$HOME/notes";  url = "git@github.com:TisnKu/notes.git" }
)
foreach ($repo in $repos)
{
  if (!(Test-Path $repo.path))
  {
    git clone $repo.url $repo.path
    Set-Location $repo.path
    git config user.email "kutianxi@outlook.com"
  }
}
runInPwsh "Set-Location $HOME/configs; ./pwsh/sync.ps1; Set-Location $HOME/work; ./init.ps1" $false $true

# Setup hotkey
runInPwsh @"
winget install AutoHotkey.AutoHotkey
  New-Item -Path '$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\appLaunchers.ahk' -ItemType HardLink -Value $env:USERPROFILE\configs\ahk\appLaunchers.ahk -Force
  Invoke-Item '$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup\appLaunchers.ahk'
"@ $false

# Install-Module: PSReadLine(builtin already), git-aliases, zlocation
runInPwsh @"
  Set-PSRepository -Name PSGallery -InstallationPolicy Trusted;
  Install-Module -Name git-aliases -Force -AllowClobber;
  Install-Module -Name zlocation -Force -AllowClobber;
"@ $false


$wingetPackages = @(
  'Microsoft.DotNet.SDK.9',
  'Microsoft.NuGet',
  'Microsoft.VisualStudioCode',
  'Microsoft.WindowsApp',
  'VideoLAN.VLC',
  'Google.Chrome',
  'OBSProject.OBSStudio',
  'BlastApps.FluentSearch',
  'Microsoft.WindowsTerminal.Preview',
  'gerardog.gsuds',
  'GitHub.Copilot'
)
$msstorePackages = @(
  'PowerToys',
  'Snipaste',
  '微信输入法'
)

foreach ($pkg in $wingetPackages)
{
  runInPwsh "winget install $pkg --accept-source-agreements --accept-package-agreements" $false
}
foreach ($pkg in $msstorePackages)
{
  runInPwsh "winget install $pkg --source=msstore --accept-source-agreements --accept-package-agreements" $false
}

## Scoop
if(!(Test-Path "$HOME\scoop\shims\scoop.ps1"))
{
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; Invoke-RestMethod get.scoop.sh | Invoke-Expression
}
scoop bucket add versions
scoop bucket add main
scoop bucket add extras
scoop bucket add nerd-fonts
scoop install firacode
scoop install Font-Awesome
scoop install mingw
scoop install gzip
scoop install fd
scoop install make
scoop install wget
scoop install unzip
scoop install deno
scoop install lazygit
scoop install fzf
scoop install ripgrep
scoop install nvs

# nvs setup
$nodeVersion = 22
nvs add $nodeVersion; nvs use $nodeVersion; nvs link $nodeVersion;

## open neovim in headless mode in another pwsh to install all plugins
$command = "winget install Neovim.Neovim; nvim --headless `"+Lazy! sync`" +qa"
runInPwsh $command $false
 
