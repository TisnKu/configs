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

local use_range_formatting = true

if not use_range_formatting then
  local lsp_format_augroup = vim.api.nvim_create_augroup('LspFormat', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = lsp_format_augroup,
    callback = function()
      -- skip formatting for these filetypes { cs }
      local skip_formatting = {}
      local filetype = vim.api.nvim_get_option_value('filetype', { buf = 0 })
      if vim.tbl_contains(skip_formatting, filetype) then
        return
      end
      vim.lsp.buf.format({ timeout_ms = 2000 })
    end,
  })
end

local function get_max_memory()
  if vim.g.is_windows then
    return 20480
  end
  return 8192
end

vim.api.nvim_create_user_command(
  'Format',
  function()
    vim.lsp.buf.format()
  end,
  { desc = "Format the buffer" }
)
require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry",
  },
})

local on_attach = function(client, bufnr)
  local clients_no_formatting = {
    'typescript-tools',
    'jsonls',
    'taplo',
  };
  if utils.contains(clients_no_formatting, client.name) then
    require('lsp-setup.utils').disable_formatting(client)
  end
  local augroup_id = vim.api.nvim_create_augroup(
    "FormatModificationsDocumentFormattingGroup",
    { clear = false }
  )
  vim.api.nvim_clear_autocmds({ group = augroup_id, buffer = bufnr })
  vim.api.nvim_buf_create_user_command(
    bufnr,
    "FormatChanges",
    function()
      local lsp_format_modifications = require "lsp-format-modifications"
      lsp_format_modifications.format_modifications(client, bufnr)
    end,
    {}
  )
  print('running on_attach for ' .. client.name)
  if use_range_formatting then
    vim.api.nvim_create_autocmd(
      { "BufWritePre" },
      {
        group = augroup_id,
        buffer = bufnr,
        callback = function()
          local lsp_format_modifications = require "lsp-format-modifications"
          lsp_format_modifications.format_modifications(client, bufnr)
        end,
      }
    )
  end
end

-- typescript-tools.nvim does not support lspconfig, so we use its own setup function
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

-- roslyn does not support lspconfig
require('roslyn').setup({
  config = {
    on_attach = on_attach,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    settings = {
      ["csharp|code_style.formatting.indentation_and_spacing"] = {
        indent_size = 4,
        indent_style = "space",
        tab_width = 4,
      },
    },
  }
})

require('lsp-setup').setup({
  on_attach = on_attach,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
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
    rust_analyzer = {}
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
