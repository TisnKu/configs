local wezterm = require 'wezterm'

return {
  font = wezterm.font 'JetBrains Mono',
  default_prog = { 'pwsh.exe' },
  keys = {
    {
      key = 'z', mods = 'ALT', action = wezterm.action.ShowLauncher,
    }
  }
}
