-- General configs
vim.cmd("source ~/.vimrc")
-- End general configs

-- load utils
require('utils')

-- Globals
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

-- Plugins
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Plugins
require("packer").startup(function(use)
  local optuse = function(plugin, opts)
    opts = opts or {}
    opts.opt = true
    use(plugin, opts)
  end

  optuse("wbthomason/packer.nvim")
  optuse("projekt0n/github-nvim-theme")
  optuse {
    "catppuccin/nvim",
    name = "catppuccin",
  }
  optuse("kaicataldo/material.vim", { branch = "main" })
  use {
    'goolord/alpha-nvim',
    requires = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
    end
  }

  optuse("machakann/vim-sandwich")
  --optuse("lambdalisue/fern.vim")
  --optuse("preservim/nerdtree")
  optuse("scrooloose/nerdcommenter")
  optuse("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
  optuse("nvim-treesitter/nvim-treesitter-context")
  optuse("windwp/nvim-autopairs")
  optuse("yuttie/comfortable-motion.vim")  -- Smooth scrolling
  optuse({
    "lukas-reineke/indent-blankline.nvim", -- Indentation lines
    requires = { { "nvim-treesitter/nvim-treesitter", opt = true } },
    config = function()
      require("ibl").setup({})
    end,
  })
  optuse('TisnKu/log-highlight.nvim')

  optuse({
    "ThePrimeagen/refactoring.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    }
  })
  optuse({
    'toppair/peek.nvim',
    run = 'deno task --quiet build:fast',
  })

  optuse {
    'saecki/crates.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }
  optuse("dstein64/vim-startuptime")
  optuse("github/copilot.vim")
  optuse({
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    requires = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
  })
  optuse("nvim-lualine/lualine.nvim")
  optuse("nvim-lua/plenary.nvim")
  optuse("lewis6991/gitsigns.nvim")
  optuse { 'sindrets/diffview.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  optuse('skywind3000/asyncrun.vim')
  optuse('voldikss/vim-floaterm')
  optuse({ "junegunn/fzf", run = ":call fzf#install()" })
  optuse { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  optuse { "nvim-telescope/telescope.nvim", requires = {
    "nvim-lua/plenary.nvim",
    "smartpde/telescope-recent-files",
    'nvim-telescope/telescope-ui-select.nvim',
    "dawsers/telescope-floaterm.nvim",
    "nvim-telescope/telescope-project.nvim",
    "nvim-telescope/telescope-file-browser.nvim"
  } }
  --optuse({ "ibhagwan/fzf-lua", requires = { { "kyazdani42/nvim-web-devicons", opt = true } } })
  optuse { 'stevearc/dressing.nvim' }
  --optuse 'airblade/vim-rooter'
  optuse({
    "klen/nvim-test",
    config = function()
      require('nvim-test').setup()
    end
  })

  -- Visualize lsp progress
  optuse({
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end
  })
  -- LSP log panel
  optuse({
    "mhanberg/output-panel.nvim",
    config = function()
      require("output_panel").setup()
    end
  })
  optuse("simrat39/rust-tools.nvim")
  optuse("williamboman/mason.nvim")
  optuse("jose-elias-alvarez/null-ls.nvim")
  optuse("williamboman/mason-lspconfig.nvim")
  optuse("neovim/nvim-lspconfig")
  optuse({
    "TisnKu/lsp-setup.nvim",
    requires = {
      { "neovim/nvim-lspconfig",             opt = true },
      { "williamboman/mason.nvim",           opt = true },
      { "williamboman/mason-lspconfig.nvim", opt = true },
    },
  })
  optuse({ "pmizio/typescript-tools.nvim", requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" } })

  optuse("hrsh7th/cmp-nvim-lsp")
  optuse("hrsh7th/cmp-buffer")
  optuse("hrsh7th/cmp-path")
  optuse("hrsh7th/cmp-cmdline")
  optuse("hrsh7th/cmp-vsnip")
  optuse("hrsh7th/vim-vsnip")
  optuse("hrsh7th/nvim-cmp")

  if packer_bootstrap then
    require("packer").sync()
  end
end)
-- End plugins
