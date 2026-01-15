local function get_themes()
  local themes = vim.fn.getcompletion("", "color")
  local excluded = { "github_dimmed", "kanagawa-lotus", "shine", "catppuccin" }
  return utils.filter(themes, function(theme)
    return not utils.contains(excluded, theme)
  end)
end
function Switch_theme(forward)
  local current_theme = vim.g.colors_name
  local themes = get_themes()
  local current_index = utils.index_of(themes, current_theme)
  print(current_theme)

  local next_index = current_index + (forward and 1 or -1)
  if next_index <= 0 then
    next_index = #themes - 1
  elseif next_index > #themes then
    next_index = 0
  end

  local next_theme = themes[next_index]
  vim.cmd("colorscheme " .. next_theme)
  print("Theme switched to " .. next_theme .. ", " .. next_index .. "/" .. #themes)
end

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-t>n", "<cmd>lua Switch_theme(true)<CR>", opts)
vim.keymap.set("n", "<C-t>p", "<cmd>lua Switch_theme(false)<CR>", opts)

require("catppuccin").setup({
  --term_colors = true,
  ----transparent_background = true,
  --styles = {
  --comments = {},
  --conditionals = {},
  --loops = {},
  --functions = {},
  --keywords = {},
  --strings = {},
  --variables = {},
  --numbers = {},
  --booleans = {},
  --properties = {},
  --types = {},
  --},
  --color_overrides = {
  --mocha = {
  --base = "#000000",
  --mantle = "#000000",
  --crust = "#000000",
  --},
  --},
  --integrations = {
  --dropbar = {
  --enabled = true,
  --color_mode = true,
  --},
  --},
})

vim.cmd [[
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
  set termguicolors
]]

if vim.g.random_theme then
  local themes = get_themes()
  local random_theme = themes[math.random(#themes)]
  vim.cmd("colorscheme " .. random_theme)
  print("Current theme: " .. random_theme)
else
  vim.cmd("colorscheme darcula-solid")
end
