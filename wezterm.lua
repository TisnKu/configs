local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on("gui-startup", function()
  local tab, pane, window = mux.spawn_window {}
  --window:gui_window():maximize()
end)

return {
  font = wezterm.font 'JetBrains Mono',
  default_domain = 'WSL:Ubuntu',
  --default_prog = { 'pwsh' },
  keys = {
    {
      key = 'a', mods = 'ALT', action = wezterm.action.ShowLauncher,
    }
  },
  launch_menu = {
    {
      label = "PowerShell Core",
      args = { "pwsh" }
    }
  },
  window_decorations = "RESIZE"
}
