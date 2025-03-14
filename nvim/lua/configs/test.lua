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

function Get_jest_config_file_path(startPath)
  local config_file = "jest.config.js"
  local path = startPath

  while true do
    local config_path = path .. "/" .. config_file
    if vim.fn.filereadable(config_path) == 1 then
      return config_path
    end

    local parent_path = vim.fn.fnamemodify(path, ":h")
    if parent_path == path then
      break
    end
    path = parent_path
  end

  return nil
end

function _G.run_tmp_test()
  -- get current filepath
  local filepath = vim.fn.expand('%:p')
  -- go up the parent directory until the nearest jest.config.js file is found
  local config_path = Get_jest_config_file_path(vim.fn.expand('%:p:h'))

  -- if jest.config.js file is found, run the test with jest command
  if config_path then
    local command = "npx jest --config " .. config_path .. " " .. filepath
    print("Running test with command: " .. command)
    vim.cmd('FloatermNew --width=1.0 --height=1.0 ' .. command)
  else
    -- if jest.config.js file is not found, run the test with default command
    local command = "npx jest " .. filepath
    print("Running test with command: " .. command)
    vim.cmd('FloatermNew --width=1.0 --height=1.0 ' .. command)
  end
end

-- register command to run test in terminal
--command! -nargs=0 RunTmpTestTerminal :!start-process pwsh "-noexit -command tmptest '%:p'"
vim.cmd([[
  command! -nargs=0 RunTmpTestInPlace :!tmptest "%:p"
  command! -nargs=0 RunTmpTestTerminal :!start-process pwsh "-noexit -command tmptest '%:p'"
  command! -nargs=0 OpenTestFile :lua open_test_file()
  command! -nargs=0 RunTmpTestFloterm :lua run_tmp_test()
]])

vim.api.nvim_set_keymap('n', '<Bslash>rt', ':RunTmpTestTerminal<CR>', { noremap = true })
--bind open_test_file to <leader>tv
vim.api.nvim_set_keymap('n', '<Bslash>t', ':lua open_test_file()<CR>', { noremap = true })
