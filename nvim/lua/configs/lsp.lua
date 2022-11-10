local mappings = {
  gD = 'lua vim.lsp.buf.declaration()',
  --gd = 'lua vim.lsp.buf.definition()',
  gt = 'lua vim.lsp.buf.type_definition()',
  K = 'lua vim.lsp.buf.hover()',
  ['<c-k>'] = 'lua vim.lsp.buf.signature_help()',
  ['<space>rn'] = 'lua vim.lsp.buf.rename()',
  ['<space>f'] = 'lua vim.lsp.buf.format({ timeout_ms = 2000 })',
  ['<space>e'] = 'lua vim.diagnostic.open_float()',
  ['[d'] = 'lua vim.diagnostic.goto_prev()',
  [']d'] = 'lua vim.diagnostic.goto_next()',
  ['<space>ca'] = 'lua vim.lsp.buf.code_action()',
  ['<space>o'] = 'OrganizeImports'
}
vim.keymap.set('v', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')

_G.contains = function(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

_G.lsp_organize_imports_sync = function(bufnr)
  -- gets the current bufnr if no bufnr is passed
  if not bufnr then bufnr = vim.api.nvim_get_current_buf() end

  -- params for the request
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(bufnr) },
    title = ""
  }

  -- perform a syncronous request
  -- 500ms timeout depending on the size of file a bigger timeout may be needed
  --print("Organizing imports...")
  vim.lsp.buf_request_sync(bufnr, "workspace/executeCommand", params, 2000)
  vim.lsp.buf.format({ timeout_ms = 2000 })
  --print("Organizing imports done.")
end

local lsp_format_augroup = vim.api.nvim_create_augroup('LspFormat', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = lsp_format_augroup,
  callback = function()
    --if vim.bo.filetype == 'typescript' then
    --  lsp_organize_imports_sync()
    --end
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})

require('lsp-setup').setup({
  default_mappings = false,
  mappings = mappings,

  on_attach = function(client, bufnr)
    local clients_no_formatting = {
      'jsonls',
      'tsserver',
      'taplo'
    };
    if _G.contains(clients_no_formatting, client.name) then
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
    tsserver = {
      commands = {
        OrganizeImports = {
          lsp_organize_imports_sync,
          description = "Organize Imports"
        }
      }

    },
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
