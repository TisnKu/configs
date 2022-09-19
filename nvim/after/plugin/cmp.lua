local cmp = require "cmp"
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end
    },
    --comfirmation = { completeopt = "menu,menuone,noselect" },
    mapping = cmp.mapping.preset.insert({
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })),
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<Enter"] = cmp.mapping.confirm({ select = false })
    }),
    sources = cmp.config.sources({
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "buffer" }
    }),
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
