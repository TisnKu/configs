local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window {}
  window:gui_window():maximize()
end)

return {
  font = wezterm.font 'JetBrains Mono',
  default_domain = 'WSL:Ubuntu',
  --default_prog = { 'pwsh.exe' },
  keys = {
    {
      key = 'z', mods = 'ALT', action = wezterm.action.ShowLauncher,
    }
  },
  launch_menu = {
    {
      label = "Powershell Core",
      args = { "pwsh.exe" }
    }
  },
  window_decorations = "NONE"
}
