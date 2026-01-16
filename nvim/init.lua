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
if not vim.loop.fs_stat(lazypath) then
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
  { "machakann/vim-sandwich" },
  { "scrooloose/nerdcommenter" },
  { "nvim-treesitter/nvim-treesitter",             branch = "master",                                   build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context",     dependencies = { "nvim-treesitter/nvim-treesitter" } },
  { 'nvim-treesitter/nvim-treesitter-textobjects', branch = "master",                                   dependencies = { "nvim-treesitter/nvim-treesitter" } },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },
  { "yuttie/comfortable-motion.vim" },
  { "justinmk/vim-sneak" },
  { "tpope/vim-repeat" },
  {
    "lukas-reineke/indent-blankline.nvim",
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
  { "b4winckler/vim-angry" },
  {
    "Julian/vim-textobj-variable-segment",
    dependencies = {
      "kana/vim-textobj-user"
    }
  },
  { "michaeljsmith/vim-indent-object" },
  { "coderifous/textobj-word-column.vim" },
  { "kana/vim-textobj-user" },
  {
    "kana/vim-textobj-entire",
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
    config = function()
      require("configs.diffview")
    end
  },
  { 'skywind3000/asyncrun.vim' },
  { 'voldikss/vim-floaterm' },
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
  { "simrat39/rust-tools.nvim" },
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },
  { "folke/snacks.nvim",       opts = {} },
  {
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      instructions_file = "avante.md",
      provider = "copilot",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
      "stevearc/dressing.nvim",        -- for input provider dressing
      "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",        -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  }
})
-- End plugins
