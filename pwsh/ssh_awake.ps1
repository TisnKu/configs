# This script will be executed on system startup to keep the system awake when there are active SSH connections.
# Start a new powershell window and run the following command to execute the script:

function ssh_awake
{
  $startDate = $(Get-Date)

  $interval = 60

  Write-Host "starting script at $startDate"

  while ($true)
  {
    $isSSHOn = $false
    try
    {
      $connection = Get-NetTCPConnection -State Established -LocalPort 22 2> $null
      $isSSHOn = $connection.State -eq "Established"
    } catch
    {
    }

    write-host "isSSHOn: $isSSHOn"

    if ($isSSHOn)
    {
      Write-Host "SSH connection found, setting timeout to 0."
      Powercfg.exe /Change standby-timeout-ac 0
    } else
    {
      Write-Host "No SSH connection found, setting timeout to 10 minutes."
      Powercfg.exe /Change standby-timeout-ac 30
    }

    Start-Sleep $interval
  }
}

function ssh_awake_background
{
  $job = Start-Job -ScriptBlock ${function:ssh_awake}
  Write-Host "Job started with id: $($job.Id)"
}

if ($env:SSH_CLIENT -or $env:SSH_TTY)
{
  ssh_awake_background
}
