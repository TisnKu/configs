require('lsp-setup').setup({
	-- Default mappings
	-- gD = 'lua vim.lsp.buf.declaration()',
	-- gd = 'lua vim.lsp.buf.definition()',
	-- gt = 'lua vim.lsp.buf.type_definition()',
	-- gi = 'lua vim.lsp.buf.implementation()',
	-- gr = 'lua vim.lsp.buf.references()',
	-- K = 'lua vim.lsp.buf.hover()',
	-- ['<C-k>'] = 'lua vim.lsp.buf.signature_help()',
	-- ['<space>rn'] = 'lua vim.lsp.buf.rename()',
	-- ['<space>ca'] = 'lua vim.lsp.buf.code_action()',
	-- ['<space>f'] = 'lua vim.lsp.buf.formatting()',
	-- ['<space>e'] = 'lua vim.diagnostic.open_float()',
	-- ['[d'] = 'lua vim.diagnostic.goto_prev()',
	-- [']d'] = 'lua vim.diagnostic.goto_next()',
	default_mappings = false,
	mappings = {
		gD = 'lua vim.lsp.buf.declaration()',
		gd = 'lua vim.lsp.buf.definition()',
		gt = 'lua vim.lsp.buf.type_definition()',
		--gi = 'lua vim.lsp.buf.implementations()',
		gi = 'lua require("fzf-lua").lsp_implementations({ jump_to_single_result = true })',
		--gr = 'lua vim.lsp.buf.references()',
		gr = 'lua require("fzf-lua").lsp_references({ jump_to_single_result = true })',
		K = 'lua vim.lsp.buf.hover()',
		['<C-k>'] = 'lua vim.lsp.buf.signature_help()',
		['<Bslash>rn'] = 'lua vim.lsp.buf.rename()',
		--['<Bslash>ca'] = 'lua vim.lsp.buf.code_action()',
		['<Bslash>ca']='lua require("fzf-lua").lsp_code_actions()',
		['<Bslash>f'] = 'lua vim.lsp.buf.format { async = true }',
		['<Bslash>e'] = 'lua vim.diagnostic.open_float()',
		['[d'] = 'lua vim.diagnostic.goto_prev()',
		[']d'] = 'lua vim.diagnostic.goto_next()',
	},

	-- Global on_attach
	on_attach = function(client, bufnr)
		-- Support custom the on_attach function for global
		-- Formatting on save as default
		--require('lsp-setup.utils').format_on_save(client)
		if client.name == "tsserver" then
			client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
		end
	end,
	-- Global capabilities
	capabilities = vim.lsp.protocol.make_client_capabilities(),
	-- Configuration of LSP servers

	servers = {
		-- Install LSP servers automatically
		-- LSP server configuration please see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
		-- pylsp = {},
		['null-ls'] = {},
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
		rust_analyzer = {
			settings = {
				['rust-analyzer'] = {
					cargo = {
						loadOutDirsFromCheck = true,
					},
					procMacro = {
						enable = true,
					},
				},
			},
		},
	},
})
