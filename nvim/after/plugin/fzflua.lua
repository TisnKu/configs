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
    fzf_opts = {
        ['--info'] = 'default'
    }
}

vim.cmd("cnoreabbrev FL FzfLua")
vim.keymap.set('n', '<leader>f', ':lua require("fzf-lua").files()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gst', ':lua require("fzf-lua").git_status()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>rg', ':lua require("fzf-lua").grep()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gl', ':lua require("fzf-lua").grep_last()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gw', ':lua require("fzf-lua").grep_cword()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gW', ':lua require("fzf-lua").grep_cWORD()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gv', ':lua require("fzf-lua").grep_visual()<CR>', { noremap = true, silent = true })
