-- Use <C-t>n/p to navigate between themes
vim.defer_fn(function()
  local themes = vim.fn.getcompletion("", "color")
  -- delete duplicate themes
  local duplicates = { "github_dimmed", "kanagawa-lotus" }
  vim.g.themes = utils.filter(themes, function(theme)
    return not utils.contains(duplicates, theme)
  end)
end, 100)

function Switch_theme(forward)
  --local current_theme = vim.api.nvim_exec2("colorscheme", { output = true }).output
  local current_theme = vim.g.colors_name
  local themes = vim.g.themes
  -- get current theme index
  local current_index = 1
  for i, theme in ipairs(themes) do
    if theme == current_theme then
      current_index = i
      break
    end
  end

  local next_index = current_index + (forward and 1 or -1)
  if next_index > #themes then
    next_index = 1
  elseif next_index < 1 then
    next_index = #themes
  end

  local next_theme = themes[next_index]
  vim.cmd("colorscheme " .. next_theme)
  print("Theme switched to " .. next_theme .. ", " .. next_index .. "/" .. #themes)
end

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-t>n", "<cmd>lua Switch_theme(true)<CR>", opts)
vim.keymap.set("n", "<C-t>p", "<cmd>lua Switch_theme(false)<CR>", opts)

--require("github-theme").setup {}
--if vim.g.is_win then
require("catppuccin").setup({
  term_colors = true,
  --transparent_background = true,
  styles = {
    comments = {},
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
  },
  color_overrides = {
    mocha = {
      base = "#000000",
      mantle = "#000000",
      crust = "#000000",
    },
  },
  integrations = {
    dropbar = {
      enabled = true,
      color_mode = true,
    },
  },
})
vim.cmd "colorscheme catppuccin"
--else
--vim.cmd "colorscheme material"
--end

vim.cmd [[
  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
  set termguicolors
]]

-- Startup page
require('alpha').setup(require('alpha.themes.dashboard').config)
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set header
dashboard.section.header.val = {
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
  "                                                     ",
}

-- Set menu
dashboard.section.buttons.val = {
  dashboard.button("r", "  > Recent", ":Telescope recent_files pick<CR>"),
  dashboard.button("e", "  > File Explorer", ":Telescope file_browser<CR>"),
  dashboard.button("f", "  > Find file", ":Telescope find_files<CR>"),
  dashboard.button("p", "  > Find project", ":Telescope project display_type=full<CR>"),
  dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])

-- Open alpha buffer on startup only when directory is opened
vim.cmd([[
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | Alpha | endif
]])
