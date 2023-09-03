require('nvim-test').setup()
vim.api.nvim_set_keymap('n', '\\te', ':TestEdit<CR>', { noremap = true })
