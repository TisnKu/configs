require('nvim-test').setup()
--vim.api.nvim_set_keymap('n', '<leader>te', ':TestEdit<CR>', { noremap = true })

-- open test file in new vertical split, if current file is a test file, open the source file in a new vertical split
function _G.open_test_file()
  local filename = vim.fn.expand('%:t:r')
  local extension = vim.fn.expand('%:e')
  local path = vim.fn.expand('%:p:h')

  -- Close all other splits in the current tab
  vim.cmd('only')

  -- if current buffer is a test file, open the source file
  if string.match(filename, '.test') then
    vim.cmd('vsplit ' .. path .. '/' .. string.gsub(filename, '.test', '') .. '.' .. extension)
  elseif string.match(filename, '.spec') then
    vim.cmd('vsplit ' .. path .. '/' .. string.gsub(filename, '.spec', '') .. '.' .. extension)
  elseif vim.fn.filereadable(path .. '/' .. filename .. '.test.' .. extension) == 1 then
    vim.cmd('vsplit ' .. path .. '/' .. filename .. '.test.' .. extension)
  elseif vim.fn.filereadable(path .. '/' .. filename .. '.spec.' .. extension) == 1 then
    vim.cmd('vsplit ' .. path .. '/' .. filename .. '.spec.' .. extension)
  end
end

--bind open_test_file to <leader>tv
vim.api.nvim_set_keymap('n', '<leader>t', ':lua open_test_file()<CR>', { noremap = true })
