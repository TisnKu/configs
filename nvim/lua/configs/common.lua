vim.keymap.set('n', '<leader>cn', ':cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>cp', ':cprevious<CR>', { noremap = true, silent = true })

vim.api.nvim_create_user_command('NoCarriageReturns', function()
  vim.cmd([[%s/\r//ge]])
end, { desc = 'Remove all ^M (carriage returns) from the current file' })

