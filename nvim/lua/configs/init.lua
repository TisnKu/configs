-- Load immediately after startup
require("configs.nerdtree")
require("configs.theme")
require("utils").trySetup("lualine", {
  theme = "auto",
  extensions = { "nerdtree" },
  --options = {
  --theme = require('material.lualine'),
  --}
})
require("configs.cmp")


-- Defer loading until after vim has started
vim.defer_fn(function()
  require("utils").trySetup("nvim-autopairs")
  require("configs.diffview")
  require("configs.gitsigns")
  require("configs.lsp")
  --require('configs.coc')
  require("configs.null-ls")
  require("configs.popui")
  require("configs.treesitter")
  require("configs.fzflua")
  require("configs.telescope")
  require("configs.nerdtree")
  require("configs.theme")
  require("configs.peek")
  require('configs.crates')
end, 0)

-- Keybindings
-- github copilot keys
if vim.g.is_mac then
  vim.api.nvim_set_keymap('i', '¬', '<Plug>(copilot-next)', {})
  vim.api.nvim_set_keymap('i', '˙', '<Plug>(copilot-previous)', {})
else
  vim.api.nvim_set_keymap('i', '<A-l>', '<Plug>(copilot-next)', {})
  vim.api.nvim_set_keymap('i', '<A-h>', '<Plug>(copilot-previous)', {})
end
