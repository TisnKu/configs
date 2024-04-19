local cmp = require "cmp"
local ls = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping(function(fallback)
      if not cmp.visible() then
        fallback()
        return
      end

      if ls.expandable() then
        ls.expand()
        return
      end

      if cmp.confirm({ select = false }) then
        return
      end

      fallback()
    end),
    ["<C-N>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif ls.locally_jumpable(1) then
        ls.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-P>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif ls.locally_jumpable(-1) then
        ls.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  preselect = cmp.PreselectMode.None,
  sources = cmp.config.sources({
    { name = "crates" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
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
