local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local actions = require("telescope.actions")
telescope.setup {
  defaults = {
    file_ignore_patterns = { "node_modules" },
    preview = {
      treesitter = false,
    },
    dynamic_preview_title = true,
    path_display = { "truncate" },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<esc>"] = actions.close,
      },
    },
  },
}
telescope.load_extension('fzy_native')
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>", opts)
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)
vim.keymap.set("n", "<leader>rg", "<cmd>Telescope live_grep<CR>", opts)
vim.keymap.set("n", "gw", "<cmd>Telescope grep_string<CR>", opts)
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
vim.keymap.set("n", "<leader>m", "<cmd>Telescope keymaps<CR>", opts)
vim.keymap.set("n", "<leader>gst", "<cmd>Telescope git_status<CR>", opts)
vim.keymap.set("n", "<leader>rs", "<cmd>Telescope resume<CR>", opts)

vim.cmd [[
  autocmd User TelescopePreviewerLoaded setlocal wrap
]]
