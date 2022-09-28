local ok, telescope = pcall(require, "telescope")
if not ok then
    return
end

telescope.setup {
    defaults = {
        file_ignore_patterns = { "node_modules" },
        mappings = {
            i = {
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<C-k>"] = require("telescope.actions").move_selection_previous,
            },
        },
    },
}
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>", opts)
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)
vim.keymap.set("n", "<leader>rg", "<cmd>Telescope live_grep<CR>", opts)