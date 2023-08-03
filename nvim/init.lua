-- General configs
vim.cmd("source ~/.vimrc")
-- End general configs

-- Globals
vim.cmd("let g:NERDDefaultAlign = 'left'")

local has = function(feat)
  if vim.fn.has(feat) == 1 then
    return true
  end

  return false
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
  use { "catppuccin/nvim", as = "catppuccin", opts = {
    term_colors = true,
    transparent_background = false,
    styles = {
      comments = {},
      conditionals = {},
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
    },
    color_overrides = {
      mocha = {
        base = "#000000",
        mantle = "#000000",
        crust = "#000000",
      },
    },
  } }
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
      vim.opt.list = true
      require("indent_blankline").setup({
        show_current_context = true,
      })
    end,
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
  optuse("nvim-lualine/lualine.nvim")
  optuse("nvim-lua/plenary.nvim")
  optuse("lewis6991/gitsigns.nvim")
  optuse { 'sindrets/diffview.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  optuse({ "junegunn/fzf", run = ":call fzf#install()" })
  if vim.g.is_win then
    optuse { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    optuse { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }
  else
    optuse({ "ibhagwan/fzf-lua", requires = { { "kyazdani42/nvim-web-devicons", opt = true } } })
  end
  optuse({ "hood/popui.nvim", requires = { 'RishabhRD/popfix' } })

  optuse({
    "klen/nvim-test",
    config = function()
      require('nvim-test').setup()
    end
  })

  -- Visualize lsp progress
  optuse({
    "j-hui/fidget.nvim",
    tag = 'legacy',
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
