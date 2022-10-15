local mappings = {
  gD = 'lua vim.lsp.buf.declaration()',
  --gd = 'lua vim.lsp.buf.definition()',
  gt = 'lua vim.lsp.buf.type_definition()',
  K = 'lua vim.lsp.buf.hover()',
  ['<c-k>'] = 'lua vim.lsp.buf.signature_help()',
  ['<space>rn'] = 'lua vim.lsp.buf.rename()',
  ['<space>f'] = 'lua vim.lsp.buf.format()',
  ['<space>e'] = 'lua vim.diagnostic.open_float()',
  ['[d'] = 'lua vim.diagnostic.goto_prev()',
  [']d'] = 'lua vim.diagnostic.goto_next()',
  ['<space>ca'] = 'lua vim.lsp.buf.code_action()'
}
vim.keymap.set('v', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')

require('lsp-setup').setup({
  default_mappings = false,
  mappings = mappings,

  -- Global on_attach
  on_attach = function(client, bufnr)
    -- Support custom the on_attach function for global
    -- Formatting on save as default
    require('lsp-setup.utils').format_on_save(client)
    if client.name == "tsserver" or client.name == "jsonls" then
      require('lsp-setup.utils').disable_formatting(client)
    end
  end,
  -- Global capabilities
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  -- Configuration of LSP servers

  servers = {
    -- Install LSP servers automatically
    -- LSP server configuration please see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
    ['null-ls'] = {},
    ['powershell_es'] = {
      bundle_path = vim.fn.stdpath('data') .. '\\mason\\packages\\powershell-editor-services',
    },
    eslint = {},
    jsonls = {},
    taplo = {},
    tsserver = {},
    sumneko_lua = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      }
    },
    -- Windows needs gzip as dependency for mason to unzip the server
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          assist = {
            importGranularity = "module",
            importPrefix = "by_self",
          },
          cargo = {
            loadOutDirsFromCheck = true,
          },
          procMacro = {
            enable = true,
          },
        },
      },
      --bundle_path = vim.fn.stdpath('data') .. '\\mason\\packages\\rust-analyzer',
      dependencies = {
        windows = { 'gzip' }
      }
    },
  },
})
