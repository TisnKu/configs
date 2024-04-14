vim.keymap.set({ "n", "v" }, "<space>f", ":FloatermToggle<CR>", { noremap = true, silent = true })
vim.keymap.set('t', "<Esc>", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })

-- Lazygit
vim.cmd("command! Lazygit FloatermNew lazygit")
