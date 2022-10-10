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

vim.g.trySetup = function(package, opts)
	local ok, p = pcall(require, package)
	if not ok then
		vim.cmd("echom 'Failed to load " .. package .. "'")
	else
		if opts == nil then
			p.setup()
		elseif type(opts) == "function" then
			p.setup(opts(p))
		else
			p.setup(opts)
		end
	end
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
	use("wbthomason/packer.nvim")
	use("projekt0n/github-nvim-theme")

	use("machakann/vim-sandwich")
	use("preservim/nerdtree")
	use("scrooloose/nerdcommenter")
	--use("sheerun/vim-polyglot") -- Syntax highlighting
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("windwp/nvim-autopairs")
	use("yuttie/comfortable-motion.vim") -- Smooth scrolling
	use({
		"lukas-reineke/indent-blankline.nvim", -- Indentation lines
		requires = "nvim-treesitter/nvim-treesitter",
		config = function()
			vim.opt.list = true
			require("indent_blankline").setup({
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	})

	use("github/copilot.vim")
	use("nvim-lualine/lualine.nvim")
	use("nvim-lua/plenary.nvim")
	use("lewis6991/gitsigns.nvim")
	use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

	use({ "junegunn/fzf", run = ":call fzf#install()" })
	if vim.g.is_win then
		use { "nvim-telescope/telescope.nvim", tag = "0.1.0",
			requires = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzy-native.nvim" } }
	else
		use({ "ibhagwan/fzf-lua", requires = { "kyazdani42/nvim-web-devicons" } })
	end
	use({ "hood/popui.nvim", requires = { 'RishabhRD/popfix' } })

	use("williamboman/mason.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")
	use({
		"junnplus/lsp-setup.nvim",
		requires = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
	})

	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-vsnip")
	use("hrsh7th/vim-vsnip")
	use("hrsh7th/nvim-cmp")

	if packer_bootstrap then
		require("packer").sync()
	end
end)
-- End plugins
