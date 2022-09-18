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

vim.g.is_win   = (has("win32") or has("win64")) and true or false
vim.g.is_linux = (has("unix") and (not has("macunix"))) and true or false
vim.g.is_mac   = has("macunix") and true or false

-- Plugins
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

    use "machakann/vim-sandwich"
    use "preservim/nerdtree"
    --use "mattn/emmet-vim"
    use "scrooloose/nerdcommenter"
    use "sheerun/vim-polyglot" -- Syntax highlighting
    use "windwp/nvim-autopairs"
    use "yuttie/comfortable-motion.vim" -- Smooth scrolling
    use {
        "lukas-reineke/indent-blankline.nvim", -- Indentation lines
        config = function()
            vim.opt.list = true
            require("indent_blankline").setup {}
        end
    }
    use "airblade/vim-gitgutter"
    use "github/copilot.vim"
    use "nvim-lualine/lualine.nvim"
    use "nvim-lua/plenary.nvim"
    use "lewis6991/gitsigns.nvim"
    use "Pocco81/auto-save.nvim"
    use { "junegunn/fzf", run = ":call fzf#install()" }
    if vim.g.is_win then
        use "junegunn/fzf.vim"
    else
        use { 'ibhagwan/fzf-lua',
            requires = { 'kyazdani42/nvim-web-devicons' },
            config = function()
                require('fzf-lua').setup {
                    winopts = {
                        win_height = 0.7,
                        win_width = 0.9,
                        win_row = 0.5,
                        win_col = 0.5,
                    },
                    fzf_opts = {
                        ['--info'] = 'default'
                    }
                }
            end
        }
    end

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            require('nvim-treesitter.install').update({
                with_sync = true
            })
        end
    }

    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "neovim/nvim-lspconfig"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-vsnip"
    use "hrsh7th/vim-vsnip"
    use "hrsh7th/nvim-cmp"

    if packer_bootstrap then
        require('packer').sync()
    end
end)
-- End plugins
