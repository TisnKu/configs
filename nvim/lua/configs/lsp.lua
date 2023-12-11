local opts = { noremap = true, silent = true }

local mappings = {
  gD = 'lua vim.lsp.buf.declaration({ timeout_ms = 10000 })',
  K = 'lua vim.lsp.buf.hover()',
  ['<c-k>'] = 'lua vim.lsp.buf.signature_help()',
  ['<space>rn'] = 'lua vim.lsp.buf.rename()',
  ['<space>f'] = 'lua vim.lsp.buf.format({ timeout_ms = 2000 })',
  ['<space>e'] = 'lua vim.diagnostic.open_float()',
  ['[d'] = 'lua vim.diagnostic.goto_prev()',
  [']d'] = 'lua vim.diagnostic.goto_next()',
  ['<space>o'] = 'OrganizeImports',
}
vim.keymap.set({ 'n', 'x' }, '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
vim.keymap.set({ 'n', 'x' }, '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')

_G.contains = function(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

local lsp_format_augroup = vim.api.nvim_create_augroup('LspFormat', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = lsp_format_augroup,
  callback = function()
    local current_folder = vim.loop.cwd()
    local skipFolders = {
      ['Teamspace-Web'] = { 'json', 'tsx', 'typescript' },
    };

    for folder, extensions in pairs(skipFolders) do
      if string.find(current_folder, folder, 1, true) ~= nil then
        print('Skipping formatting for ' .. current_folder)
        return
      end
    end

    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
})

require('typescript-tools').setup({
  on_attach = function(client, bufnr)
    require('lsp-setup.utils').disable_formatting(client)
    require('lsp-setup.utils').mappings(bufnr, mappings)
  end,
  settings = {
    tsserver_max_memory = 12288,
    separate_diagnostic_server = false,
    expose_as_code_action = "all"
  },
})

require('lsp-setup').setup({
  default_mappings = false,
  mappings = mappings,
  on_attach = function(client, _)
    local clients_no_formatting = {
      'typescript-tools',
      'jsonls',
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
    -- Windows needs gzip as dependency for mason to unzip the server
    rust_analyzer = require('lsp-setup.rust-tools').setup({
      server = {
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
    }),
  },
})

-- let noice handle it
--vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--  border = "rounded",
--})

function vim.g.buf_update_diagnostics()
  local clients = vim.lsp.buf_get_clients()
  local buf = vim.api.nvim_get_current_buf()

  for _, client in ipairs(clients) do
    if vim.lsp.diagnostic.get then
      local diagnostics = vim.lsp.diagnostic.get(buf, client.id)
      vim.lsp.diagnostic.display(diagnostics, buf, client.id)
    end
  end
end

vim.api.nvim_exec([[
    au CursorHold <buffer> lua vim.g.buf_update_diagnostics()
]], false)
