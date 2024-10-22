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
  local test_file_found = false
  if suffix then
    utils.find(target_file_extensions, function(target_extension)
      local target_file_path = path .. '/' .. file_name_without_suffix .. '.' .. target_extension
      if vim.fn.filereadable(target_file_path) == 1 then
        vim.cmd('vsplit ' .. target_file_path)
        test_file_found = true
        return true
      end
    end)
  else
    utils.find(target_file_extensions, function(target_extension)
      if utils.find(test_file_suffix, function(target_suffix)
            local target_file_path = path .. '/' .. filename .. '.' .. target_suffix .. '.' .. target_extension
            if vim.fn.filereadable(target_file_path) == 1 then
              vim.cmd('vsplit ' .. target_file_path)
              test_file_found = true
              return true
            end
          end) then
        return true
      end
    end)
  end

  -- if test file does not exist, pop up dialog for user to edit test file name, press enter to create a new test file
  if not test_file_found then
    local new_file_name = file_name_without_suffix .. '.' .. test_file_suffix[1] .. '.' .. target_file_extensions[1]
    vim.ui.input({ prompt = "Enter test file name:", default = new_file_name }, function(prompt)
      if not prompt or prompt == "" then
        return
      end
      vim.cmd('vsplit ' .. path .. '/' .. prompt)
    end)
  end
end

-- register command to run test in terminal
vim.cmd([[
  command! -nargs=0 RunTmpTestInPlace :!tmptest "%:p"
  command! -nargs=0 RunTmpTestTerminal :!start-process pwsh "-noexit -command tmptest '%:p'"
  command! -nargs=0 OpenTestFile :lua open_test_file()
  command! -nargs=0 RunTmpTestFloterm :FloatermNew --width=1.0 --height=1.0 tmptest "%:p"
]])

vim.api.nvim_set_keymap('n', '<Bslash>rt', ':RunTmpTestTerminal<CR>', { noremap = true })
--bind open_test_file to <leader>tv
vim.api.nvim_set_keymap('n', '<Bslash>t', ':lua open_test_file()<CR>', { noremap = true })
