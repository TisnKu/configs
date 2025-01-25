-- Load immediately after startup
-- require("configs.theme")
require("configs.start_page")

-- utils.trySetup("lualine", {
--   theme = "auto",
--   options = {
--     theme = 'auto'
--   }
-- })

-- Defer loading until after vim has started
vim.defer_fn(function()
  require('configs.common')
  require('configs.snippets')
  require("configs.cmp")
  require("configs.json")
  require("configs.search_fold")
  require("configs.filter")
  require('configs.completeCurrentLine')
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
  require("configs.peek")
  require('configs.crates')
  require('configs.test')
  require('configs.file')
  require('configs.refactor')
  require('configs.dressing')
  require('configs.terminal')
  require('configs.copilot')
  -- require('configs.textobjects')
  utils.trySetup('log-highlight', {
    pattern = '.*log.*'
  })
  --require('configs.noice')
  require('configs.floaterm')
end, 0)
