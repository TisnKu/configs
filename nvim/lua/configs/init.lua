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
vim.api.nvim_set_keymap('i', '<C-j>', '<Plug>(copilot-next)', {})
vim.api.nvim_set_keymap('i', '<C-k>', '<Plug>(copilot-previous)', {})
