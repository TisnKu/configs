require("github-theme").setup()
--vim.cmd [[colorscheme github_dark_default]]
vim.cmd [[
  colorscheme material
  if (has("termguicolors"))
    set termguicolors
  endif
]]
