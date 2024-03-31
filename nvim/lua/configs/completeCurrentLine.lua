local function is_open_bracket(char)
  return char == '(' or char == '[' or char == '{'
end

local function is_close_bracket(char)
  return char == ')' or char == ']' or char == '}'
end

local function matching_bracket(char)
  local brackets = { ['('] = ')', ['['] = ']', ['{'] = '}' }
  return brackets[char]
end

local function process_char(char, completion_queue)
  if is_open_bracket(char) then
    table.insert(completion_queue, char)
  elseif is_close_bracket(char) and #completion_queue > 0 and completion_queue[#completion_queue] == matching_bracket(char) then
    table.remove(completion_queue)
  end
end

function Complete_line()
  local line = vim.fn.getline('.')
  local completion_queue = {}

  for char in line:gmatch('.') do
    process_char(char, completion_queue)
  end

  local completion = ''
  for i = #completion_queue, 1, -1 do
    completion = completion .. matching_bracket(completion_queue[i])
  end

  local need_semicolon = utils.contains(
    { 'c', 'cpp', 'java', 'javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'rust', 'go', 'python' },
    vim.bo.filetype)

  if completion == '' and (line:sub(-1) == ';' or not need_semicolon) then
    return
  end

  if line:sub(-1) == ';' then
    line = line:sub(1, -2)
  end

  if need_semicolon then
    completion = completion .. ';'
  end

  vim.fn.setline('.', line .. completion)
end

vim.cmd('command! -nargs=0 CompleteLine lua Complete_line()')
vim.api.nvim_set_keymap('n', '\\c', ':CompleteLine<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '\\c', '<esc>:CompleteLine<CR>', { noremap = true, silent = true })
