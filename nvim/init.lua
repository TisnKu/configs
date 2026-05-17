-- General configs
vim.cmd("source ~/.vimrc")
-- End general configs

-- load utils
require('utils')

-- Globals
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.random_theme = false
vim.opt.smoothscroll = true

if vim.g.is_wsl then
  vim.g.clipboard = {
    name = 'win32yank',
    copy = {
      ["+"] = 'win32yank.exe -i --crlf',
      ["*"] = 'win32yank.exe -i --crlf',
    },
    paste = {
      ["+"] = 'win32yank.exe -o --lf',
      ["*"] = 'win32yank.exe -o --lf',
    },
    cache_enabled = 0,
  }
end

if vim.g.is_win then
  vim.opt.shadafile    = "NONE"
  vim.opt.shell        = vim.fn.executable('pwsh') == 1 and 'pwsh' or 'powershell'
  vim.opt.shellcmdflag = '-noexit -NoLogo -ExecutionPolicy RemoteSigned -Command '
  vim.opt.shellredir   = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  vim.opt.shellpipe    = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
  vim.opt.shellquote   = ''
  vim.opt.shellxquote  = ''
else
  vim.opt.shell = vim.fn.executable('zsh') == 1 and 'zsh' or 'bash'
end

-- Plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.cmd [[
  runtime macros/sandwich/keymap/surround.vim
]]

require("lazy").setup({
  { "TisnKu/plenary.nvim" },
  { "doums/darcula" },
  {
    "xiantang/darcula-dark.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("configs.start_page")
    end
  },
  { "machakann/vim-sandwich",  event = "BufReadPost" },
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    opts = {
      toggler = { line = "<leader>cc", block = "<leader>cb" },
      opleader = { line = "<leader>cc", block = "<leader>cb" },
      extra = { above = "<leader>cO", below = "<leader>co", eol = "<leader>cA" },
    },
  },
  { "nvim-treesitter/nvim-treesitter",             branch = "master",                                   build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context",     dependencies = { "nvim-treesitter/nvim-treesitter" } },
  { 'nvim-treesitter/nvim-treesitter-textobjects', branch = "master",                                   dependencies = { "nvim-treesitter/nvim-treesitter" } },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },
  { "tpope/vim-repeat",             event = "BufReadPost" },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("ibl").setup({})
    end,
  },
  {
    'TisnKu/log-highlight.nvim',
    opts = {
      pattern = '.*log.*'
    }
  },
  { "b4winckler/vim-angry",               event = "BufReadPost" },
  {
    "Julian/vim-textobj-variable-segment",
    event = "BufReadPost",
    dependencies = {
      "kana/vim-textobj-user"
    }
  },
  { "michaeljsmith/vim-indent-object",    event = "BufReadPost" },
  { "coderifous/textobj-word-column.vim", event = "BufReadPost" },
  { "kana/vim-textobj-user",              event = "BufReadPost",
    config = function()
      vim.cmd [[
        call textobj#user#plugin('datetime', {
        \   'date': {
        \     'pattern': '\<\d\d\d\d-\d\d-\d\d\>',
        \     'select': ['ad', 'id'],
        \   },
        \   'time': {
        \     'pattern': '\<\d\d:\d\d:\d\d\>',
        \     'select': ['at', 'it'],
        \   },
        \ })
      ]]
    end
  },
  {
    "kana/vim-textobj-entire",
    event = "BufReadPost",
    dependencies = {
      "kana/vim-textobj-user"
    }
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" }
    }
  },
  {
    'toppair/peek.nvim',
    build = 'deno task --quiet build:fast',
  },
  {
    'saecki/crates.nvim',
    config = function()
      require("configs.crates")
    end
  },
  { "dstein64/vim-startuptime" },
  {
    'zbirenbaum/copilot.lua',
    dependencies = {
      "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
    },
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = '<Tab>',
        },
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      theme = "auto",
      options = {
        theme = 'auto'
      }

    }
  },
  { "lewis6991/gitsigns.nvim" },
  {
    'sindrets/diffview.nvim',
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = { { "<leader>d", ":DiffviewOpen<CR>", desc = "Open diffview" } },
    config = function()
      require("configs.diffview")
    end
  },
  { 'skywind3000/asyncrun.vim', cmd = "AsyncRun" },
  { 'voldikss/vim-floaterm',    cmd = { "FloatermNew", "FloatermToggle", "FloatermKill" } },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "smartpde/telescope-recent-files",
      'nvim-telescope/telescope-ui-select.nvim',
      "dawsers/telescope-floaterm.nvim",
      "nvim-telescope/telescope-project.nvim",
      "TisnKu/telescope-file-browser.nvim",
      "TisnKu/telescope-git-diff.nvim"
    }
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        default_file_explorer = false,
        view_options = {
          show_hidden = true,
        },
      })
      vim.keymap.set("n", "<space>e", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
    end
  },
  { 'stevearc/dressing.nvim' },
  {
    "j-hui/fidget.nvim",
    config = true
  },
  --{
  --"mhanberg/output-panel.nvim",
  --config = true
  --},
  { "williamboman/mason.nvim" },
  { "nvimtools/none-ls.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  {
    "TisnKu/lsp-setup.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    branch = 'master',
    dependencies = { "neovim/nvim-lspconfig" }
  },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-cmdline" },
  { "hrsh7th/nvim-cmp" },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },
  { 'saadparwaiz1/cmp_luasnip' },
  {
    'gsuuon/note.nvim',
    opts = {
      spaces = {
        '~',
      },
    },
    cmd = 'Note',
    ft = 'note',
    keys = {
      -- You can use telescope to search the current note space:
      {
        '<space>nt', -- [t]elescope [n]ote
        function()
          require('telescope.builtin').live_grep({
            cwd = require('note.api').current_note_root()
          })
        end,
        mode = 'n'
      }
    }
  },
  {
    'MoaidHathot/dotnet.nvim',
    cmd = "DotnetUI",
    opts = {},
  },
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      choose_target = function(target)
        return vim.iter(target):find(function(item)
          if not string.match(item, "Cosmic.sln") then
            return item
          end
        end)
      end
    }
  },
  {
    "joechrisellis/lsp-format-modifications.nvim"
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  { "folke/snacks.nvim",       opts = {} },
})
-- End plugins
