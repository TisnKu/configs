. ~/configs/pwsh/fileUtil.ps1

$env:nvimdata = "$env:LOCALAPPDATA\nvim-data"
$env:packerhome = "$env:nvimdata\site\pack\packer\start\"

New-Alias which get-command -Force
function Say
{
  param([string]$message)
  $voice = New-Object -ComObject Sapi.spvoice
  $voice.rate = 0
  $voice.speak($message)
}

function symlink($source, $target)
{
  New-Item -Path $target -ItemType SymbolicLink -Value $source
}

function gitbash
{
  & 'C:\Program Files\Git\bin\sh.exe' --login
}

function Get-Size
{
  param([string]$pth)
  "{0:n2}" -f ((Get-ChildItem -path $pth -recurse | measure-object -property length -sum).sum / 1mb) + " mb"
}

function AllHistory
{
  param (
  )
  Get-Content $( (Get-PSReadlineOption).HistorySavePath)
}

function trim
{
  [CmdletBinding()]
  param([string]$str)
  $trimmedStr = $str.Replace('`n', '').Replace('`r', '')
  $trimmedStr
}

function ...
{
  cd.. && cd..
}

function ....
{
  cd.. && cd.. && cd..
}

function .....
{
  cd .. && cd .. && cd .. && cd ..
}

function restartDocker
{
  $processes = Get-Process "*docker desktop*"
  if ($processes.Count -gt 0)
  {
    $processes[0].Kill()
    $processes[0].WaitForExit()
  }
  Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
}

function ~
{
  Set-Location ~
}

function guid
{
  [guid]::NewGuid() | Set-Clipboard
}

function activate
{
  param([string]$pathKeyword)
  if (![string]::IsNullOrEmpty($pathKeyword))
  {
    j $pathKeyword
  }

  ./venv/Scripts/activate
}

function pkill
{
  param([int]$port)
  $processId = (Get-Process -Id (Get-NetTCPConnection -LocalPort $port).OwningProcess).Id
  Stop-Process $processId
}

function addPath
{
  param([string]$path)
  $oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
  $newpath = "$oldpath;$(resolve-path $path)"
  Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
  (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
}

function setPath
{
  param([string]$path)
  Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $path
  (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).Path
}

function killByPath
{
  param([string]$path)
  Get-Process | Where-Object { $_.Path -like "*$path*" } | Stop-Process -Force -processname { $_.ProcessName }
}

function Reduce($initial, $reducer)
{
  begin
  {
    $result = $initial
  }

  process
  {
    # & is to call a variable
    # $reducer example: $reducer = { param($x, $y) $x + $y }
    $result = & $reducer $result $_
  }

  end
  {
    $result
  }
}

# github copilot alias
function ghc
{
  gh copilot suggest $args
}

function ghce
{
  gh copilot explain $args
}


function upgradePS
{
  iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI" 
}

# write a function to wait for $arg seconds
function wait
{
  param([int]$arg)
  Start-Sleep -Seconds $arg
}

# set proxy
function vpn()
{
  $proxy = "http://127.0.0.1:7890"
  $env:HTTP_PROXY = $proxy
  $env:HTTPS_PROXY = $proxy
  $env:ALL_PROXY = $proxy
  netsh winhttp set proxy $proxy
}

function unvpn()
{
  $env:HTTP_PROXY = ""
  $env:HTTPS_PROXY = ""
  $env:ALL_PROXY = ""
}

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
    ArgumentList = "-Command `"$wrappedCommand`""
    Wait         = $wait
  }
  if ($asAdmin)
  { $startProcessParams.Verb = "RunAs" 
  }

  $process = Start-Process @startProcessParams
  return $process
}

function bios() 
{
  runInPwsh "shutdown /r /fw /t 0" $false $true
}

# I have 2 windows boot options, switch to another one
function nextWin()
{
  $bootOptionsLines = bcdedit /enum
  foreach ($line in $bootOptionsLines)
  {
    if ($line -match 'identifier\s+{([^}]+)}')
    {
      $identifier = $matches[1]
      if ($identifier -notin @('current', 'bootmgr', 'default'))
      {
        bcdedit /default "{$identifier}"
        Write-Host "Changed default boot option: $identifier"
        break
      }
    }
  }

  # wait for user confirmation
  Write-Host "Switched to the next Windows boot option. The system will now restart."
  Write-Host "Press Enter to continue..."
  [void][System.Console]::ReadLine()

  shutdown /r /t 0
}
