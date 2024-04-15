-- Load immediately after startup
require("configs.theme")
utils.trySetup("lualine", {
  theme = "auto",
  --extensions = { "fern" },
  options = {
    theme = 'auto'
  }
})
require("configs.json")
require("configs.cmp")
require("configs.search_fold")

-- Defer loading until after vim has started
vim.defer_fn(function()
  require('configs.completeCurrentLine')
  require('configs.ps')
  --require('configs.nerdtree')
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
  utils.trySetup('log-highlight', {
    pattern = '.*log.*'
  })
  --require('configs.noice')
  require('configs.floaterm')
end, 0)
