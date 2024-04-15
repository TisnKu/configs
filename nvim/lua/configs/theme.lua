--require("github-theme").setup {}
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

if vim.g.is_win then
  vim.cmd "colorscheme catppuccin"
else
  vim.cmd "colorscheme material"
end

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
