require("github-theme").setup {}
vim.cmd [[colorscheme github_dark_high_contrast]]
--vim.cmd [[
--  colorscheme material
--  let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
--  if (has("termguicolors"))
--    set termguicolors
--  endif
--]]

---- Startup page
--require('alpha').setup(require('alpha.themes.dashboard').config)
--local alpha = require("alpha")
--local dashboard = require("alpha.themes.dashboard")

---- Set header
--dashboard.section.header.val = {
--  "                                                     ",
--  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
--  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
--  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
--  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
--  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
--  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
--  "                                                     ",
--}

---- Set menu
--dashboard.section.buttons.val = {
--  dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
--  dashboard.button("f", "  > Find file", "Telescope find_files<CR>"),
--  dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
--  dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
--}

---- Send config to alpha
--alpha.setup(dashboard.opts)

---- Disable folding on alpha buffer
--vim.cmd([[
--    autocmd FileType alpha setlocal nofoldenable
--]])

---- Open alpha buffer on startup only when directory is opened
--vim.cmd([[
--    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | Alpha | endif
--]])
