-- Define a function to complete missing characters
local completion_queue = {}

function Complete_line()
  -- Get the current line
  local line = vim.fn.getline('.')

  -- Clear the completion queue
  completion_queue = {}

  for char in line:gmatch('.') do
    -- if char is a open bracket, push it to queue
    if char == '(' or char == '[' or char == '{' then
      table.insert(completion_queue, char)
    end
    -- if char is a close bracket, pop open bracket from queue and ignore when open bracket is not available
    if char == ')' then
      if #completion_queue > 0 and completion_queue[#completion_queue] == '(' then
        table.remove(completion_queue)
      end
    elseif char == ']' then
      if #completion_queue > 0 and completion_queue[#completion_queue] == '[' then
        table.remove(completion_queue)
      end
    elseif char == '}' then
      if #completion_queue > 0 and completion_queue[#completion_queue] == '{' then
        table.remove(completion_queue)
      end
    end
  end

  -- Add missing characters
  local completion = ''

  -- Recursively pop from queue, append corresponding close bracket
  for i = #completion_queue, 1, -1 do
    if completion_queue[i] == '(' then
      completion = completion .. ')'
    elseif completion_queue[i] == '[' then
      completion = completion .. ']'
    elseif completion_queue[i] == '{' then
      completion = completion .. '}'
    end
  end

  -- Check if the language needs a semicolon
  local filetype = vim.bo.filetype
  local need_semicolon = _G.contains({
    'c', 'cpp', 'java', 'javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'rust', 'go', 'python'
  }, filetype)

  -- if completion is empty and current line does not miss ending semicolon, return
  if completion == '' and (line:sub(-1) == ';' or not need_semicolon) then
    return
  end

  -- Remove semicolon if it is the last character
  if line:sub(-1) == ';' then
    line = line:sub(1, -2)
  end

  if need_semicolon then
    completion = completion .. ';'
  end

  -- set the current line to the line with completion
  vim.fn.setline('.', line .. completion)
end

-- Define a custom command for triggering the completion
vim.cmd('command! -nargs=0 CompleteLine lua Complete_line()')

-- Map "\+c" to trigger the completion
vim.api.nvim_set_keymap('n', '\\c', ':CompleteLine<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '\\c', '<esc>:CompleteLine<CR>', { noremap = true, silent = true })
