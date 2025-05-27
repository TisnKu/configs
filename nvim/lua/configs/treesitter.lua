local status, ts = pcall(require, "nvim-treesitter.configs")
if not status then
  print("nvim-treesitter is not installed")
  return
end

ts.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "00",
      node_incremental = "v", -- expand selection
      node_decremental = "V", -- shrink selection
    }
  },
  highlight = {
    enable = true
  },
  ensure_installed = { "vim", "javascript", "typescript", "lua", "rust", "diff" },
  auto_install = true,
  sync_install = false,
  indent = {
    enable = true
  },
  additional_vim_regex_highlighting = false,
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>k"] = "@function.outer",
        ["<leader>K"] = "@class.outer",
      },
    },
  },
}

vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

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
