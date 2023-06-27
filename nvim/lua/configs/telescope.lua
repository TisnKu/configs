local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local actions = require("telescope.actions")
telescope.setup {
  defaults = {
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        width = 0.9,
        height = 0.75,
        preview_width = 0.6,
      },
      vertical = {
        width = 0.9,
        height = 0.8,
        preview_height = 0.5,
      },
      prompt_position = "top",
    },
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
telescope.load_extension('fzf')
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>f", "<cmd>Telescope find_files<CR>", opts)
vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)
vim.keymap.set("n", "<leader>rg",
  ":lua require('telescope.builtin').grep_string({search = vim.fn.input('Search term: ')})<CR>", opts)
vim.keymap.set("n", "<leader>gw", "<cmd>Telescope grep_string<CR>", opts)
vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
vim.keymap.set("n", "<leader>m", "<cmd>Telescope keymaps<CR>", opts)
vim.keymap.set("n", "<leader>gst", "<cmd>Telescope git_status<CR>", opts)
vim.keymap.set("n", "<leader>rs", "<cmd>Telescope resume<CR>", opts)

vim.cmd("cnoreabbrev TP Telescope")
vim.cmd("cnoreabbrev Tp Telescope")
vim.cmd [[
  autocmd User TelescopePreviewerLoaded setlocal wrap
]]
