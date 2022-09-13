-- General configs
vim.cmd("source ~/.vimrc")
-- End general configs

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- Plugins
require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use {
        "projekt0n/github-nvim-theme",
        config = function()
            require("github-theme").setup()
            vim.cmd [[colorscheme github_dark_default]]
        end
    }
    use {
        "Yggdroot/LeaderF",
        cmd = "Leaderf",
        run = ":LeaderfInstallCExtension"
    }
    vim.cmd [[
      noremap <leader>ff :<C-U>Leaderf file<cr>
      noremap <leader>rg :<C-U>Leaderf rg<cr>
      noremap <leader>gg :<C-U>Leaderf! rg --recall<cr>
    ]]

    use {
        'mg979/vim-visual-multi',
        branch = "master"
    }
    use "wellle/targets.vim"

    use "preservim/nerdtree"
    vim.cmd [[
      noremap <space>e :NERDTreeToggle<CR>
      noremap <space>f :NERDTreeFind<CR>
    ]]

    use "mattn/emmet-vim"
    use "scrooloose/nerdcommenter"
    use "sheerun/vim-polyglot"
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end
    }
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

    use {
        "tikhomirov/vim-glsl",
        config = function()
            vim.cmd("autocmd! BufNewFile,BufRead *.vs,*.fs set ft=glsl")
        end
    }
    use "github/copilot.vim"
    use {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup {
                theme = "auto",
                extensions = {"nerdtree"}
            }
        end
    }

    use {
        "lewis6991/gitsigns.nvim",
        requires = {"nvim-lua/plenary.nvim"},
        config = function()
            require("gitsigns").setup()
        end
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup {
                highlight = {
                    enable = true
                },
                ensure_installed = {"javascript", "typescript", "lua", "haskell", "rust"},
                sync_install = false,
                indent = {
                    enable = true
                },
                additional_vim_regex_highlighting = false
            }
            vim.opt.foldlevel = 20
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        end
    }

    use {
        "alx741/vim-hindent",
        config = function()
            vim.cmd [[
                augroup HaskellFormat
                autocmd!
                autocmd BufRead,BufNewFile *.hs noremap <silent> <leader>l :Hindent<cr>
                augroup END
            ]]
        end
    }

    -- LSP configs
    -- LSP keybindings
    vim.api.nvim_create_autocmd("User", {
        pattern = "LspAttached",
        desc = "LSP actions",
        callback = function()
            local bufmap = function(mode, lhs, rhs)
                local bufopts = {
                    noremap = true,
                    buffer = true
                }
                vim.keymap.set(mode, lhs, rhs, bufopts)
            end

            bufmap("n", "gD", vim.lsp.buf.declaration)
            bufmap("n", "gd", vim.lsp.buf.definition)
            bufmap("n", "gi", vim.lsp.buf.implementation)
            bufmap("n", "gr", vim.lsp.buf.references)
            bufmap("n", "K", vim.lsp.buf.hover)
            bufmap("n", "<leader>l", function()
                vim.lsp.buf.formatting_sync()
            end)
            bufmap("n", "gl", vim.diagnostic.open_float)
            bufmap("n", "[d", vim.diagnostic.goto_prev)
            bufmap("n", "]d", vim.diagnostic.goto_next)
            bufmap("n", "go", vim.lsp.buf.type_definition)
        end
    })

    use "williamboman/mason.nvim"
    use {
        "williamboman/mason-lspconfig.nvim",
        after = "mason.nvim",
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup()
        end
    }

    use {
        "neovim/nvim-lspconfig",
        after = {"mason-lspconfig.nvim"},
        config = function()
            local lsp_defaults = {
                on_attach = function(client, bufnr)
                    vim.api.nvim_exec_autocmds("User", {
                        pattern = "LspAttached"
                    })
                end
            }

            -- Extend to defaults
            local lspconfig = require("lspconfig")
            lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)

        end
    }

    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-vsnip"
    use "hrsh7th/vim-vsnip"
    use {
        "hrsh7th/nvim-cmp",
        requires = {"neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "harsh7th/cmp-buffer", "hrsh7th/cmp-path",
                    "hrsh7th/cmp-cmdline", "hrsh7th/cmp-vsnip", "hrsh7th/vim-vsnip"},
        after = {"nvim-lspconfig"},
        config = function()
            vim.cmd [[set completeopt=menu,menuone,noselect]]

            local cmp = require "cmp"

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                    end
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort()
                    -- ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({{
                    name = "nvim_lsp"
                }, {
                    name = "vsnip"
                }}, {{
                    name = "buffer"
                }})
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {{
                    name = "buffer"
                }}
            })

            -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({{
                    name = "path"
                }}, {{
                    name = "cmdline"
                }})
            })

            -- Setup lspconfig.
            local lsp_servers = {"tsserver", "rust_analyzer"}
            local lspconfig = require("lspconfig")
            local capabilities =
                require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
            for _, lsp in ipairs(lsp_servers) do
                lspconfig[lsp].setup {
                    capabilities = capabilities
                }
            end
            lspconfig.sumneko_lua.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {"vim"}
                        }
                    }
                }
            }
        end
    }
    -- End LSP configs
    if packer_bootstrap then
        require('packer').sync()
    end
end)
-- End plugins
