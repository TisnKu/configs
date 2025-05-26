local mappings = {
  gD = 'lua vim.lsp.buf.declaration({ timeout_ms = 10000 })',
  K = 'lua vim.lsp.buf.hover()',
  --['<space>s'] = 'lua vim.lsp.buf.signature_help()',
  ['<leader>rn'] = 'lua vim.lsp.buf.rename()',
  ['<Bslash>f'] = 'lua vim.lsp.buf.format({ timeout_ms = 2000 })',
  ['[d'] = 'lua vim.diagnostic.goto_prev()',
  [']d'] = 'lua vim.diagnostic.goto_next()',
}

vim.keymap.set({ 'n', 'x' }, '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set('v', '<space>a', ":'<,'>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set('n', '<space>d', '<cmd>lua vim.diagnostic.open_float()<CR>')

local lsp_format_augroup = vim.api.nvim_create_augroup('LspFormat', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = lsp_format_augroup,
  callback = function()
    -- skip formatting for these filetypes { cs }
    local skip_formatting = { 'cs' }
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    if vim.tbl_contains(skip_formatting, filetype) then
      return
    end
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})

local function get_max_memory()
  if vim.g.is_windows then
    return 20480
  end
  return 8192
end

if not vim.g.is_mac then
  require('typescript-tools').setup({
    on_attach = function(client, bufnr)
      require('lsp-setup.utils').disable_formatting(client)
      require('lsp-setup.utils').mappings(bufnr, mappings)
    end,
    settings = {
      tsserver_max_memory = get_max_memory(),
      separate_diagnostic_server = false,
      expose_as_code_action = "all"
    },
    flags = {
      --allow_incremental_sync = true,
    }
  })
end

require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
})

require('lsp-setup').setup({
  default_mappings = false,
  mappings = mappings,
  on_attach = function(client, _)
    local clients_no_formatting = {
      'typescript-tools',
      'jsonls',
      'taplo',
      'roslyn'
    };
    if utils.contains(clients_no_formatting, client.name) then
      require('lsp-setup.utils').disable_formatting(client)
    end
  end,
  -- Global capabilities
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  -- Configuration of LSP servers
  servers = {
    ['powershell_es'] = {
      ensure_installed = false,
      bundle_path = vim.fn.stdpath('data') .. '\\mason\\packages\\powershell-editor-services',
    },
    eslint = {},
    jsonls = {},
    taplo = {},
    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      }
    },
    --pylsp = {
    --settings = {
    --pylsp = {
    --plugins = {
    --pycodestyle = { ignore = { "E501" } },
    --autopep8 = { enabled = false },
    --}
    --}
    --}
    --},
    -- Windows needs gzip as dependency for mason to unzip the server
    rust_analyzer = {
      settings = {
        ['rust-analyzer'] = {
          inlayHints = {
            bindingModeHints = {
              enable = false,
            },
            chainingHints = {
              enable = true,
            },
            closingBraceHints = {
              enable = true,
              minLines = 25,
            },
            closureReturnTypeHints = {
              enable = 'never',
            },
            lifetimeElisionHints = {
              enable = 'never',
              useParameterNames = false,
            },
            maxLength = 25,
            parameterHints = {
              enable = true,
            },
            reborrowHints = {
              enable = 'never',
            },
            renderColons = true,
            typeHints = {
              enable = true,
              hideClosureInitialization = false,
              hideNamedConstructor = false,
            }
          }
        }
      }
    }
  }
})

-- let noice handle it
--vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--  border = "rounded",
--})

function Buf_update_diagnostics()
  local clients = vim.lsp.get_clients()
  local buf = vim.api.nvim_get_current_buf()

  for _, client in ipairs(clients) do
    if vim.lsp.diagnostic.get then
      local diagnostics = vim.lsp.diagnostic.get(buf, client.id)
      vim.lsp.diagnostic.display(diagnostics, buf, client.id)
    end
  end
end

vim.api.nvim_exec([[
    au CursorHold <buffer> lua Buf_update_diagnostics()
]], false)
