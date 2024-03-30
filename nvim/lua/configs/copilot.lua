require('utils').trySetup("CopilotChat", {
  window = {
    layout = 'float',
  }
})

-- Keybindings
-- github copilot keys
if vim.g.is_mac then
  vim.api.nvim_set_keymap('i', '¬', '<Plug>(copilot-next)', {})
  vim.api.nvim_set_keymap('i', '˙', '<Plug>(copilot-previous)', {})
else
  vim.api.nvim_set_keymap('i', '<A-l>', '<Plug>(copilot-next)', {})
  vim.api.nvim_set_keymap('i', '<A-h>', '<Plug>(copilot-previous)', {})
end

-- Copilot chat
vim.api.nvim_set_keymap('n', '<space>cc', '<ESC>:CopilotChatToggle<CR>', { noremap = true, silent = true })
