local status, FzfLua = pcall(require, "fzf-lua")
if not status then
  return
end

require('fzf-lua').setup {
  winopts = {
    win_height = 0.7,
    win_width = 0.9,
    win_row = 0.5,
    win_col = 0.5,
  },
  --fzf_layout = 'reverse-list',
  fzf_opts = {
    ['--info'] = 'default',
    ['--keep-right'] = '',
  }
}

vim.cmd("cnoreabbrev FL FzfLua")
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>f', ':lua require("fzf-lua").files()<CR>', opts)
vim.keymap.set('n', '<leader>gst', ':lua require("fzf-lua").git_status()<CR>', opts)
vim.keymap.set('n', '<leader>rg', ':lua require("fzf-lua").grep()<CR>', opts)
vim.keymap.set('n', '<leader>gl', ':lua require("fzf-lua").grep_last()<CR>', opts)
vim.keymap.set('n', '<leader>gw', ':lua require("fzf-lua").grep_cword()<CR>', opts)
vim.keymap.set('n', '<leader>gW', ':lua require("fzf-lua").grep_cWORD()<CR>', opts)
vim.keymap.set('n', '<leader>gv', ':lua require("fzf-lua").grep_visual()<CR>', opts)
vim.keymap.set('n', 'gd', ':lua require("fzf-lua").lsp_definitions({ jump_to_single_result = true })<CR>', opts)
vim.keymap.set('n', 'gi', ':lua require("fzf-lua").lsp_implementations({ jump_to_single_result = true })<CR>', opts)
vim.keymap.set('n', 'gr', ':lua require("fzf-lua").lsp_references({ jump_to_single_result = true })<CR>', opts)
vim.keymap.set('n', '<leader>m', ':lua require("fzf-lua").keymaps()<CR>', opts)
vim.keymap.set('n', '<leader>b', ':lua require("fzf-lua").buffers()<CR>', opts)
vim.keymap.set('n', '<leader>rs', ':lua require("fzf-lua").resume()<CR>', opts)
