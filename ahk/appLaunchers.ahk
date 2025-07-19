#Requires AutoHotkey v2.0

SwitchToWindowsTerminal()
{
  if (WinActive("ahk_exe WindowsTerminal.exe"))
  {
    WinMinimize
  }
  else if (WinExist("ahk_exe WindowsTerminal.exe"))
  {
    WinActivate
  }
  else {
    Run "shell:appsfolder\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe!App"
  }
}

; Hotkey to use Shift-Alt-t to launch/restore the Windows Terminal.
+!t::SwitchToWindowsTerminal()


SwitchToWezterm()
{
  if (WinActive("ahk_exe wezterm-gui.exe"))
  {
    WinMinimize
  }
  else if (WinExist("ahk_exe wezterm-gui.exe"))
  {
    WinActivate
  }
  else {
    Run "C:\Program Files\WezTerm\wezterm-gui.exe"
  }
}

; +!w::SwitchToWezterm()

UnzipFirstZipFileInDownload()
{
  Run 'pwsh.exe -Command "unzipLatestZipFileInDownloads"'
}

+!z::UnzipFirstZipFileInDownload()

; Run nextWin pwsh function in admin mode when ctrl+shift+alt+F9 is pressed.
RunNextWinInAdmin()
{
  Run 'pwsh.exe -Command "runInPwsh nextWin $false $true"'
}

^+!F9::RunNextWinInAdmin()

; Run bios pwsh function in admin mode when ctrl+shift+alt+F12 is pressed.
RunBiosInAdmin()
{
  Run 'pwsh.exe -Command "runInPwsh bios $false $true"'
}

^+!F12::RunBiosInAdmin()
