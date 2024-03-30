-- Load immediately after startup
require("configs.theme")
require("utils").trySetup("lualine", {
  theme = "auto",
  --extensions = { "fern" },
  options = {
    theme = 'auto'
  }
})
require("configs.cmp")

-- Defer loading until after vim has started
vim.defer_fn(function()
  require('configs.ps')
  require('configs.nerdtree')
  --require("configs.fern")
  require("utils").trySetup("nvim-autopairs")
  require("configs.diffview")
  require("configs.gitsigns")
  require("configs.lsp")
  require("configs.null-ls")
  require("configs.treesitter")
  require("configs.fzflua")
  require("configs.telescope")
  require("configs.theme")
  require("configs.peek")
  require('configs.crates')
  require('configs.test')
  require('configs.file')
  require('configs.refactor')
  require('configs.dressing')
  require('configs.terminal')
  require('configs.copilot')
  --require('configs.noice')
end, 0)

