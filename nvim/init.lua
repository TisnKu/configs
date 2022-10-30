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

vim.g.is_win = (has("win32") or has("win64")) and true or false
vim.g.is_linux = (has("unix") and (not has("macunix"))) and true or false
vim.g.is_mac = has("macunix") and true or false

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
  optuse("kaicataldo/material.vim", { branch = "main" })

  optuse("machakann/vim-sandwich")
  optuse("preservim/nerdtree")
  optuse("scrooloose/nerdcommenter")
  optuse("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
  optuse("windwp/nvim-autopairs")
  optuse("yuttie/comfortable-motion.vim") -- Smooth scrolling
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

  optuse("dstein64/vim-startuptime")
  optuse("github/copilot.vim")
  optuse("nvim-lualine/lualine.nvim")
  optuse("nvim-lua/plenary.nvim")
  optuse("lewis6991/gitsigns.nvim")
  optuse { 'sindrets/diffview.nvim', requires = { 'nvim-lua/plenary.nvim' } }

  optuse({ "junegunn/fzf", run = ":call fzf#install()" })
  if vim.g.is_win then
    optuse { "nvim-telescope/telescope.nvim", tag = "0.1.0",
      requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzy-native.nvim" } }
  else
    optuse({ "ibhagwan/fzf-lua", requires = { { "kyazdani42/nvim-web-devicons", opt = true } } })
  end
  optuse({ "hood/popui.nvim", requires = { 'RishabhRD/popfix' } })

  optuse("williamboman/mason.nvim")
  optuse("jose-elias-alvarez/null-ls.nvim")
  optuse("williamboman/mason-lspconfig.nvim")
  optuse("neovim/nvim-lspconfig")
  optuse({
    "TisnKu/lsp-setup.nvim",
    requires = {
      { "neovim/nvim-lspconfig", opt = true },
      { "williamboman/mason.nvim", opt = true },
      { "williamboman/mason-lspconfig.nvim", opt = true },
    },
  })

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
