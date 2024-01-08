function _G.run_cmd(cmd)
  if cmd == '' then
    return
  end

  -- if cmd ends with `;`, do not append file path
  if string.sub(cmd, -1) == ';' then
    vim.cmd('!pwsh -noexit -command ' .. cmd)
    return
  end

  vim.cmd('!' .. cmd .. ' \"%:p\"')
  --local filePath = vim.fn.expand('%:p')
  --vim.cmd('!pwsh -noexit -command \'' .. cmd .. ' "' .. filePath .. '"\'')
end

vim.api.nvim_set_keymap('n', '<Bslash>tr', ':lua run_cmd(vim.fn.input("pwsh: "))<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Bslash>ff', ':!prettier --write \"%:p\"<CR>', { noremap = true })
