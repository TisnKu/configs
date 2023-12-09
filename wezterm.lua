local wezterm = require 'wezterm'

local schemes = {}
for name, _ in pairs(wezterm.get_builtin_color_schemes()) do
  schemes[#schemes + 1] = {
    label = name,
    id = name,
  }
end

---cycle through builtin dark schemes in dark mode,
---and through light schemes in light mode
local function themeCycler(direction, window, _)
  local allSchemes = wezterm.color.get_builtin_schemes()
  local currentMode = wezterm.gui.get_appearance()
  local currentScheme = window:effective_config().color_scheme
  local darkSchemes = {}
  local lightSchemes = {}

  for name, scheme in pairs(allSchemes) do
    local bg = wezterm.color.parse(scheme.background) -- parse into a color object
    ---@diagnostic disable-next-line: unused-local
    local h, s, l, a = bg:hsla()                      -- and extract HSLA information
    if l < 0.4 then
      table.insert(darkSchemes, name)
    else
      table.insert(lightSchemes, name)
    end
  end
  local schemesToSearch = currentMode:find("Dark") and darkSchemes or lightSchemes

  for i = 1, #schemesToSearch, 1 do
    if schemesToSearch[i] == currentScheme then
      local next = (i + direction + #schemesToSearch) % #schemesToSearch
      local overrides = window:get_config_overrides() or {}
      overrides.color_scheme = schemesToSearch[next]
      wezterm.log_info("Switched to: " .. schemesToSearch[next])
      window:set_config_overrides(overrides)
      return
    end
  end
end

return {
  font = wezterm.font 'JetBrains Mono',
  default_prog = { 'pwsh' },
  keys = {
    {
      key = 'a', mods = 'ALT', action = wezterm.action.ShowLauncher,
    },
    {
      key = 'F12',
      action = 'ShowDebugOverlay'
    },
    {
      key = 'F11',
      action = wezterm.action.InputSelector {
        action = wezterm.action_callback(function(window, pane, id, label)
          if not id and not label then
            wezterm.log_info 'cancelled'
          else
            -- set color scheme to the selected id
            wezterm.log_info('selected ' .. id)
            window:set_config_overrides {
              color_scheme = id,
            }
          end
        end),
        title = 'Pick a color scheme',
        choices = schemes,
      }
    },
    {
      key = 'F9',
      action = wezterm.action_callback(function(window, _)
        themeCycler(-1, window, _)
      end)
    },
    {
      key = 'F10',
      action = wezterm.action_callback(function(window, _)
        themeCycler(1, window, _)
      end)
    },
  },
  launch_menu = {
    {
      label = "PowerShell",
      args = { "pwsh" }
    },
    {
      label = "Windows PowerShell",
      args = { "powershell" }
    }
  },
  window_decorations = "RESIZE",
  color_scheme = "Seti",
  default_cursor_style = 'SteadyBar',
  warn_about_missing_glyphs = false,
  hide_tab_bar_if_only_one_tab = true,
}
