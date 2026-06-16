-- nvim-treesitter (main branch) only handles parser installation.
-- Treesitter highlight/indent are built into Neovim 0.12+.
local status, ts = pcall(require, "nvim-treesitter")
if not status then
  print("nvim-treesitter is not installed")
  return
end

ts.setup {}

-- Neovim 0.12+ bundles common parsers. Only install additional ones if needed.
-- ts.install({ "additional_language" })

-- Note: incremental selection was removed in nvim-treesitter main branch.
-- Use visual mode 'v' with standard motions instead.

-- Textobjects (nvim-treesitter-textobjects main branch API)
local ts_textobjects_ok = pcall(require, "nvim-treesitter-textobjects")
if ts_textobjects_ok then
  local select_to = require("nvim-treesitter.textobjects.select").select_textobject
  vim.keymap.set({ "x", "o" }, "af", function() select_to("@function.outer", "textobjects") end)
  vim.keymap.set({ "x", "o" }, "if", function() select_to("@function.inner", "textobjects") end)
  vim.keymap.set({ "x", "o" }, "ak", function() select_to("@class.outer", "textobjects") end)
  vim.keymap.set({ "x", "o" }, "ik", function() select_to("@class.inner", "textobjects") end)
  vim.keymap.set({ "x", "o" }, "ac", function() select_to("@class.outer", "textobjects") end)
  vim.keymap.set({ "x", "o" }, "ic", function() select_to("@class.inner", "textobjects") end)

  local move = require("nvim-treesitter.textobjects.move")
  vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
  vim.keymap.set({ "n", "x", "o" }, "]k", function() move.goto_next_start("@class.outer", "textobjects") end)
  vim.keymap.set({ "n", "x", "o" }, "]z", function() move.goto_next_start("@fold", "folds") end)
  vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
  vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
  vim.keymap.set({ "n", "x", "o" }, "[k", function() move.goto_previous_start("@class.outer", "textobjects") end)
  vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
end

-- Folding
vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

utils.trySetup('treesitter-context', {
  enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
})
