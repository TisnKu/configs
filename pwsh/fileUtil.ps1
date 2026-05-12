function downloadFolder()
{
  $downloadFolder = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path;
  return $downloadFolder;
}

function unzipLatestZipFileInDownloads()
{
  $latest = Get-ChildItem -Path $(downloadFolder) -Filter *.zip | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  $destination =  $latest.FullName.Substring(0, $latest.FullName.Length - 4)
  write-host "unzipping $latest to $destination"
  Expand-Archive -Path $latest.FullName -DestinationPath $destination -Force
  # Open destination folder
  explorer.exe $destination
  # Open destination folder in pwsh
  start-process pwsh -ArgumentList "-noexit -WorkingDirectory $destination"
}

# Example usage: UnzipRecentFiles -TargetFolder "C:\Users\UserName\Downloads" -TimeLimitInMinutes 30
function UnzipRecentFiles
{
  Param (
    [Parameter()]
    [string]$TargetFolder = "$HOME\Downloads",

    [Parameter()]
    [int]$TimeLimitInMinutes = 30
  )

  $currentTime = Get-Date
  $zipFiles = Get-ChildItem $TargetFolder | Where-Object {$_.Extension -eq ".zip" -and $_.CreationTime -ge ($currentTime.AddMinutes(-$TimeLimitInMinutes))}

  foreach ($zipFile in $zipFiles)
  {
    $zipFolder = Join-Path $TargetFolder -ChildPath ($zipFile.BaseName + "_files")
    if (!(Test-Path $zipFolder -PathType Container))
    {
      New-Item $zipFolder -ItemType Directory | Out-Null
    }
    $shell = New-Object -com Shell.Application
    $zip = $shell.NameSpace($zipFile.FullName)
    foreach ($item in $zip.items())
    {
      $shell.Namespace($zipFolder).CopyHere($item)
    }
  }
}

function cleanCifxLogs()
{
  # Delete all zips or folders with tee_[num]_executee pattern in the name from Download folder
  Get-ChildItem -Path $(downloadFolder) -Filter tee_*_executee* | Remove-Item -Recurse -Force
}

function extractCifxLogs()
{

  # Extract all zips with tee_[num]_executee pattern in the name from Download folder
  Get-ChildItem -Path $(downloadFolder) -Filter tee_*_executee* | % { Expand-Archive -Path $_.FullName -DestinationPath $_.FullName.Substring(0, $_.FullName.Length - 4) -Force }
}

function startup()
{
  # Open startup folder
  Invoke-Item "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup"
}
