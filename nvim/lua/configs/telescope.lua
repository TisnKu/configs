local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local actions = require("telescope.actions")
local project_actions = require("telescope._extensions.project.actions")
local file_browser_actions = require("telescope._extensions.file_browser.actions")

local project_paths = {
  { '~/',          max_depth = 1 },
  { '~/Projects',  max_depth = 2 },
  { 'D:/Projects', max_depth = 2 },
}
-- test project_paths and remove non-existing paths
for i = #project_paths, 1, -1 do
  local path = project_paths[i][1]
  if vim.fn.isdirectory(vim.fn.expand(path)) ~= 1 then
    table.remove(project_paths, i)
  end
end

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
        ["<esc><esc>"] = actions.close,
        ["<leader>q"] = actions.close,
        ["<C-c"] = actions.close,
      },
      n = {
        ["<leader>q"] = actions.close,
      }
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
      initial_mode = "normal",
      theme = "ivy",
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          ["<space>e"] = actions.close,
          ["<C-<F5>"] = file_browser_actions.create,
          ["<C-<F6>"] = file_browser_actions.copy,
          ["<C-<F7>"] = file_browser_actions.rename,
          ["<C-<F8>"] = file_browser_actions.remove,
          ["<C-<F9>"] = file_browser_actions.move,
        },
        ["n"] = {
          ["<space>e"] = actions.close,
        },
      },
    },
    recent_files = {
      only_cwd = true,
    },
    project = {
      base_dirs = project_paths,
      on_project_selected = function(prompt_bufnr)
        project_actions.change_working_directory(prompt_bufnr)
        vim.defer_fn(function()
          vim.cmd("bufdo bwipeout")
          vim.cmd("Alpha")
        end, 10)
      end
    }
  }
}

local extensions = {
  'fzf',
  'ui-select',
  'file_browser',
  'floaterm',
  'recent_files',
  'project'
}

for _, extension in ipairs(extensions) do
  local success, err = pcall(telescope.load_extension, extension)
  if not success then
    print('Error loading extension ' .. extension .. ': ' .. err)
  end
end

function Telescope_ripgrep()
  local input = vim.fn.input("Rg > ", "")
  if input == "" then
    return
  end
  require("telescope.builtin").grep_string {
    search = input == " " and "" or input,
    only_sort_text = true,
  }
end

local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>p', ':Telescope project display_type=full<CR>', opts)
vim.keymap.set('n', '<space>r', ':<C-u>Telescope recent_files pick<CR>', opts)
vim.keymap.set({ "n", "v" }, "<space>e", ":<C-u>Telescope file_browser path=%:p:h select_buffer=true<CR>", opts)
vim.keymap.set({ "n", "v" }, "<space>t", ":<C-u>Telescope builtin include_extensions=true<CR>", opts)
--vim.keymap.set("t", "<space>t", "<C-\\><C-n>:Telescope builtin include_extensions=true<CR>", opts)
vim.keymap.set({ "n", "v" }, "<space>;", ":<C-u>Telescope commands<CR>", opts)
--vim.keymap.set("t", "<space>;", "<C-\\><C-n>:Telescope commands<CR>", opts)
vim.keymap.set({ "n", "i", "v" }, "<leader>f",
  ":<C-u>lua require('telescope.builtin').find_files({ debounce = 100 })<CR>", opts)
vim.keymap.set("n", "<leader>gf",
  ":lua require('telescope.builtin').find_files({default_text = vim.fn.expand('<cword>')})<CR>",
  opts)
vim.keymap.set("v", "<leader>gf",
  ":lua require('telescope.builtin').find_files({default_text = utils.get_visual_selection()})<CR>", opts)

vim.keymap.set("n", "<leader>gb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", opts)
vim.keymap.set("n", "<leader>gl", "<cmd>Telescope live_grep<CR>", opts)
vim.keymap.set("n", "<leader>rg", ":lua Telescope_ripgrep()<CR>", opts)
vim.keymap.set("n", "<leader>gw", "<cmd>Telescope grep_string<CR>", opts)
vim.keymap.set("v", "<leader>gw",
  ":lua require('telescope.builtin').grep_string({search = utils.get_visual_selection()})<CR>", opts)
vim.keymap.set("v", "<leader>gv",
  ":lua require('telescope.builtin').grep_string({search = utils.get_visual_selection()})<CR>", opts)

vim.keymap.set("n", "<leader>m", "<cmd>Telescope keymaps<CR>", opts)
vim.keymap.set("n", "<leader>gst", "<cmd>Telescope git_status<CR>", opts)
vim.keymap.set("n", "<space>u", "<cmd>Telescope resume<CR>", opts)

vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

vim.cmd("cnoreabbrev TL Telescope")
vim.cmd("cnoreabbrev Tl Telescope")
vim.cmd [[
  autocmd User TelescopePreviewerLoaded setlocal wrap
]]
