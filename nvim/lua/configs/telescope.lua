local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local actions = require("telescope.actions")
telescope.setup {
  defaults = {
    cache_picker = {
      ignore_empty_prompt = false,
    },
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
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_cursor {
        layout_config = {
          height = function(_, _, _)
            return 12
          end,
        },
      }
    },
    file_browser = {
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  }
}

table.unpack = table.unpack or unpack -- 5.1 compatibility

telescope.load_extension('fzf')
telescope.load_extension("ui-select")
telescope.load_extension("file_browser")

local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>ef", ":Telescope file_browser<CR>", opts)
vim.keymap.set("n", "<leader>f", ":lua require('telescope.builtin').find_files({ debounce = 100 })<CR>", opts)
vim.keymap.set("n", "<leader>gf",
  ":lua require('telescope.builtin').find_files({default_text = vim.fn.expand('<cword>')})<CR>",
  opts)
vim.keymap.set("v", "<leader>gf",
  ":lua require('telescope.builtin').find_files({default_text = vim.g.get_visual_selection()})<CR>", opts)

vim.keymap.set("n", "<leader>gb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
vim.keymap.set("n", "<leader>gl", "<cmd>Telescope live_grep<CR>", opts)
vim.keymap.set("n", "<leader>rg",
  ":lua require('telescope.builtin').grep_string({search = vim.fn.input('Search term: ')})<CR>", opts)
vim.keymap.set("n", "<leader>gw", "<cmd>Telescope grep_string<CR>", opts)
vim.keymap.set("v", "<leader>gw",
  ":lua require('telescope.builtin').grep_string({search = vim.g.get_visual_selection()})<CR>", opts)
vim.keymap.set("v", "<leader>gv",
  ":lua require('telescope.builtin').grep_string({search = vim.g.get_visual_selection()})<CR>", opts)

vim.keymap.set("n", "<leader>b", "<cmd>Telescope buffers<CR>", opts)
vim.keymap.set("n", "<leader>m", "<cmd>Telescope keymaps<CR>", opts)
vim.keymap.set("n", "<leader>gst", "<cmd>Telescope git_status<CR>", opts)
vim.keymap.set("n", "<leader>rs", "<cmd>Telescope resume<CR>", opts)

vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

vim.cmd("cnoreabbrev TL Telescope")
vim.cmd("cnoreabbrev Tl Telescope")
vim.cmd [[
  autocmd User TelescopePreviewerLoaded setlocal wrap
]]
