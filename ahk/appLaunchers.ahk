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
    Run 'wt'
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
