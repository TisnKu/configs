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
end, 0)
