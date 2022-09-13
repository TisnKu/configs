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
    sources = cmp.config.sources({ {
        name = "nvim_lsp"
    }, {
        name = "vsnip"
    } }, { {
        name = "buffer"
    } })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { {
        name = "buffer"
    } }
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({ {
        name = "path"
    } }, { {
        name = "cmdline"
    } })
})

-- lspconfig start
local lsp_defaults = {
    on_attach = function(client, bufnr)
        vim.api.nvim_exec_autocmds("User", {
            pattern = "LspAttached"
        })
    end
}

local lspconfig = require("lspconfig")
lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, lsp_defaults)
-- lspconfig end

-- Setup lsps
local lsp_servers = { "tsserver", "rust_analyzer" }
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
                globals = { "vim" }
            }
        }
    }
}
