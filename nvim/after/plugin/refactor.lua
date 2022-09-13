require('telescope').load_extension('refactoring')
vim.api.nvim_set_keymap("v", "<leader>rt",
  "<cmd>lua require('telescope').extensions.refactoring.refactors()<cr>", {
  noremap = true,
  silent = true
})
