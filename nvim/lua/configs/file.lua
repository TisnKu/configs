-- Copy current buffer file path to clipboard
vim.api.nvim_set_keymap('n', '<F3>', ':let @+=expand("%:p")<CR>', { noremap = true })
