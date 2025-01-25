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
  vim.opt.shadafile = "NONE"
  vim.cmd [[
    let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
    let &shellcmdflag = '-noexit -NoLogo -ExecutionPolicy RemoteSigned -Command '
    let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    let &shellpipe  = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
    set shellquote= shellxquote=
  ]]
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

require("lazy").setup({
  { "TisnKu/plenary.nvim" },
  { "wbthomason/packer.nvim",      lazy = true },
  { "projekt0n/github-nvim-theme", lazy = true },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true
  },
  { "kaicataldo/material.vim", branch = "main", lazy = true },
  { "EdenEast/nightfox.nvim",  lazy = true },
  { "doums/darcula",           lazy = true },
  { "morhetz/gruvbox",         lazy = true },
  { "rebelot/kanagawa.nvim",   lazy = true },
  {
    'goolord/alpha-nvim',
    lazy = true,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
    end
  },
  { "machakann/vim-sandwich",                      lazy = true },
  { "scrooloose/nerdcommenter",                    lazy = true },
  { "nvim-treesitter/nvim-treesitter",             lazy = true, run = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-context",     lazy = true },
  { 'nvim-treesitter/nvim-treesitter-textobjects', lazy = true },
  { "windwp/nvim-autopairs",                       lazy = true },
  { "yuttie/comfortable-motion.vim",               lazy = true },
  {
    "lukas-reineke/indent-blankline.nvim",
    lazy = true,
    dependencies = { { "nvim-treesitter/nvim-treesitter", lazy = true } },
    config = function()
      require("ibl").setup({})
    end,
  },
  { 'TisnKu/log-highlight.nvim',           lazy = true },
  { "Matt-A-Bennett/vim-surround-funk",    lazy = true },
  { "b4winckler/vim-angry",                lazy = true },
  { "Julian/vim-textobj-variable-segment", lazy = true },
  { "michaeljsmith/vim-indent-object",     lazy = true },
  { "coderifous/textobj-word-column.vim",  lazy = true },
  { "kana/vim-textobj-user",               lazy = true },
  { "kana/vim-textobj-entire",             lazy = true },
  {
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" }
    }
  },
  {
    'toppair/peek.nvim',
    lazy = true,
    run = 'deno task --quiet build:fast',
  },
  { 'saecki/crates.nvim',       lazy = true },
  { "dstein64/vim-startuptime", lazy = true },
  { "github/copilot.vim",       lazy = true },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    lazy = true,
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
  },
  { "nvim-lualine/lualine.nvim",                lazy = true },
  { "lewis6991/gitsigns.nvim",                  lazy = true },
  { 'sindrets/diffview.nvim',                   lazy = true },
  { 'skywind3000/asyncrun.vim',                 lazy = true },
  { 'voldikss/vim-floaterm',                    lazy = true },
  { "junegunn/fzf",                             lazy = true, run = ":call fzf#install()" },
  { 'nvim-telescope/telescope-fzf-native.nvim', lazy = true, run = 'make' },
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    dependencies = {
      "smartpde/telescope-recent-files",
      'nvim-telescope/telescope-ui-select.nvim',
      "dawsers/telescope-floaterm.nvim",
      "nvim-telescope/telescope-project.nvim",
      "TisnKu/telescope-file-browser.nvim",
      "slarwise/telescope-git-diff.nvim"
    }
  },
  { 'stevearc/dressing.nvim',            lazy = true },
  {
    "klen/nvim-test",
    lazy = true,
    config = function()
      require('nvim-test').setup()
    end
  },
  {
    "j-hui/fidget.nvim",
    lazy = true,
    config = function()
      require("fidget").setup()
    end
  },
  {
    "mhanberg/output-panel.nvim",
    lazy = true,
    config = function()
      require("output_panel").setup({})
    end
  },
  { "simrat39/rust-tools.nvim",          lazy = true },
  { "williamboman/mason.nvim",           lazy = true },
  { "nvimtools/none-ls.nvim",            lazy = true },
  { "williamboman/mason-lspconfig.nvim", lazy = true },
  { "neovim/nvim-lspconfig",             lazy = true },
  {
    "TisnKu/lsp-setup.nvim",
    lazy = true,
    dependencies = {
      { "neovim/nvim-lspconfig",             lazy = true },
      { "williamboman/mason.nvim",           lazy = true },
      { "williamboman/mason-lspconfig.nvim", lazy = true },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    branch = 'master',
    lazy = true,
    dependencies = { "neovim/nvim-lspconfig" }
  },
  { "hrsh7th/cmp-nvim-lsp", lazy = true },
  { "hrsh7th/cmp-buffer",   lazy = true },
  { "hrsh7th/cmp-path",     lazy = true },
  { "hrsh7th/cmp-cmdline",  lazy = true },
  { "hrsh7th/nvim-cmp",     lazy = true },
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    run = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },
  { 'saadparwaiz1/cmp_luasnip', lazy = true },
})
-- End plugins
