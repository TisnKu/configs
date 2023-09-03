require('nvim-test').setup()
vim.api.nvim_set_keymap('n', '<leader>te', ':TestEdit<CR>', { noremap = true })
