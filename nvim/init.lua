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

-- Plugins
require("lazy").setup({ spec = {
  { "projekt0n/github-nvim-theme", lazy = true },
  { "kaicataldo/material.vim", branch = "main" },

  { "machakann/vim-sandwich", lazy = true },
  "preservim/nerdtree",
  { "scrooloose/nerdcommenter", lazy = true },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", lazy = true },
  "windwp/nvim-autopairs",
  "yuttie/comfortable-motion.vim", -- Smooth scrolling
  {
    "lukas-reineke/indent-blankline.nvim", -- Indentation lines
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      vim.opt.list = true
      require("indent_blankline").setup({
        show_current_context = true,
      })
    end,
  },

  "dstein64/vim-startuptime",
  "github/copilot.vim",
  "nvim-lualine/lualine.nvim",
  "nvim-lua/plenary.nvim",
  "lewis6991/gitsigns.nvim",
  { 'sindrets/diffview.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  { "junegunn/fzf", build = ":call fzf#install()" },
  --if vim.g.is_win then
  --  optuse { "nvim-telescope/telescope.nvim", tag = "0.1.0",
  --    requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzy-native.nvim" } }
  --else
  { "ibhagwan/fzf-lua", dependencies = { "kyazdani42/nvim-web-devicons" } },
  --end
  { "hood/popui.nvim", dependencies = { 'RishabhRD/popfix' } },

  "williamboman/mason.nvim",
  "jose-elias-alvarez/null-ls.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  {
    "TisnKu/lsp-setup.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig", lazy = true },
      { "williamboman/mason.nvim", lazy = true },
      { "williamboman/mason-lspconfig.nvim", lazy = true },
    },
  },

  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",
  "hrsh7th/nvim-cmp",
}, defaults = {
  lazy = false,
} })
-- End plugins
