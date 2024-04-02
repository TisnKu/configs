require('nvim-test').setup()

-- open test file in new vertical split, if current file is a test file, open the source file in a new vertical split
function _G.open_test_file()
  local test_file_suffix = { "test", "spec" }
  local target_file_extensions = { "ts", "js", "tsx", "jsx" }
  local filename = vim.fn.expand('%:t:r')
  local path = vim.fn.expand('%:p:h')
  local suffix = utils.find(test_file_suffix, function(suffix) return string.match(filename, '.' .. suffix) end)
  local file_name_without_suffix = suffix and string.gsub(filename, '.' .. suffix, '') or filename

  -- If there are multiple splits, close all but the current one
  if vim.fn.winnr('$') > 1 then
    vim.cmd('only')
  end

  -- if test file suffix is found, open the source file
  if suffix then
    utils.find(target_file_extensions, function(target_extension)
      local target_file_path = path .. '/' .. file_name_without_suffix .. '.' .. target_extension
      if vim.fn.filereadable(target_file_path) == 1 then
        vim.cmd('vsplit ' .. target_file_path)
        return true
      end
    end)
  else
    utils.find(target_file_extensions, function(target_extension)
      if utils.find(test_file_suffix, function(target_suffix)
            local target_file_path = path .. '/' .. filename .. '.' .. target_suffix .. '.' .. target_extension
            if vim.fn.filereadable(target_file_path) == 1 then
              vim.cmd('vsplit ' .. target_file_path)
              return true
            end
          end) then
        return true
      end
    end)
  end
end

-- register command to run test in terminal
vim.cmd([[
  command! -nargs=0 RunTmpTest :!tmptest "%:p"
]])

vim.cmd([[
  command! -nargs=0 RunTmpTestTerminal :!start-process pwsh "-noexit -command tmptest '%:p'"
]])

vim.cmd([[
  command! -nargs=0 OpenTestFile :lua open_test_file()
]])

vim.api.nvim_set_keymap('n', '<Bslash>rt', ':RunTmpTestTerminal<CR>', { noremap = true })
--bind open_test_file to <leader>tv
vim.api.nvim_set_keymap('n', '<Bslash>t', ':lua open_test_file()<CR>', { noremap = true })
