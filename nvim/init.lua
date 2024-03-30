-- General configs
vim.cmd("source ~/.vimrc")
-- End general configs

-- Globals

local has = function(feat)
  if vim.fn.has(feat) == 1 then
    return true
  end

  return false
end

table.unpack = table.unpack or unpack
vim.g.get_visual_selection = function()
  local _, ls, cs = table.unpack(vim.fn.getpos("'<"))
  local _, le, ce = table.unpack(vim.fn.getpos("'>"))
  local visual_selection = vim.api.nvim_buf_get_text(0, ls - 1, cs - 1, le - 1, ce, {})
  return table.concat(visual_selection, "\n")
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.is_win = (has("win32") or has("win64")) and true or false
vim.g.is_linux = (has("unix") and (not has("macunix"))) and true or false
vim.g.is_mac = has("macunix") and true or false
vim.g.format = true
vim.g.is_wsl = vim.g.is_linux and vim.fn.system("uname -r | grep -i microsoft") ~= "" and true or false
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

require("completeCurrentLine")

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
    if opts == nil then
      opts = { opt = true }
    else
      opts.opt = true
    end

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
  optuse("preservim/nerdtree")
  optuse("scrooloose/nerdcommenter")
  optuse("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
  optuse("windwp/nvim-autopairs")
  optuse("yuttie/comfortable-motion.vim")  -- Smooth scrolling
  optuse({
    "lukas-reineke/indent-blankline.nvim", -- Indentation lines
    requires = { { "nvim-treesitter/nvim-treesitter", opt = true } },
    config = function()
      require("ibl").setup({})
    end,
  })

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
    config = function()
    end,
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

  optuse({ "junegunn/fzf", run = ":call fzf#install()" })
  optuse { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  optuse { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }
  optuse { 'nvim-telescope/telescope-ui-select.nvim' }
  optuse {
    "nvim-telescope/telescope-file-browser.nvim",
    requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  }
  --optuse({ "ibhagwan/fzf-lua", requires = { { "kyazdani42/nvim-web-devicons", opt = true } } })
  optuse { 'stevearc/dressing.nvim' }

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
