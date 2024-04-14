vim.keymap.set({ "n", "v" }, "<space>f", ":FloatermToggle<CR>", { noremap = true, silent = true })
vim.keymap.set('t', "<leader>q", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })
-- Kill all instances of floaterm on qall
vim.keymap.set({ "n", "v" }, "WQ", ":FloatermKill!<CR>:wqall<CR>", { noremap = true, silent = true })

-- Lazygit
vim.cmd("command! Lazygit FloatermNew --width=1.0 --height=1.0 lazygit")
