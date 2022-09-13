-- General configs
vim.cmd("source ~/.vimrc")
-- End general configs

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Plugins
require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use "projekt0n/github-nvim-theme"
    use {
        "Yggdroot/LeaderF",
        run = ":LeaderfInstallCExtension"
    }

    use "wellle/targets.vim"
    use "preservim/nerdtree"
    use "mattn/emmet-vim"
    use "scrooloose/nerdcommenter"
    use "sheerun/vim-polyglot"
    use "windwp/nvim-autopairs"
    use "yuttie/comfortable-motion.vim"
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            vim.opt.list = true
            require("indent_blankline").setup {}
        end
    }

    use {
        "skywind3000/asyncrun.vim",
        config = function()
            vim.g.asyncrun_open = 16
            vim.g.asyncrun_bell = 1
            vim.keymap.set("n", "<leader>a", "<cmd>AsyncRun ")
            vim.keymap.set("n", "<leader>as", "<cmd>AsyncStop<cr>")
            vim.keymap.set("n", "<cr>", "<cmd>call asyncrun#quickfix_toggle(16)<cr>", {
                noremap = false
            })
        end
    }

    use {
        "zivyangll/git-blame.vim",
        config = function()
            vim.keymap.set("n", "<leader>s", "<cmd>call gitblame#echo()<cr>")
        end
    }

    use "github/copilot.vim"
    use "nvim-lualine/lualine.nvim"

    use {
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }

    use "alx741/vim-hindent"
    use "williamboman/mason.nvim"
    use {
        "williamboman/mason-lspconfig.nvim",
        after = "mason.nvim",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
        end
    }

    use "Pocco81/auto-save.nvim"
    use {
        "neovim/nvim-lspconfig",
        after = { "mason-lspconfig.nvim" },
    }

    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-vsnip"
    use "hrsh7th/vim-vsnip"
    use {
        "hrsh7th/nvim-cmp",
        requires = { "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "harsh7th/cmp-buffer", "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline", "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip" },
        after = { "nvim-lspconfig" },
    }
    -- End LSP configs
    if packer_bootstrap then
        require('packer').sync()
    end
end)
-- End plugins
