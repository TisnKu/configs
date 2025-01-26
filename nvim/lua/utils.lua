local M = {}

M.unpack = table.unpack or unpack

vim.g.is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
vim.g.is_linux = vim.fn.has("unix") == 1 and not vim.fn.has("macunix") == 1
vim.g.is_mac = vim.fn.has("macunix") == 1
vim.g.is_wsl = vim.g.is_linux and vim.fn.system("uname -r | grep -i microsoft") ~= ""

function M.open_url(url)
  print('Open url: ' .. url)
  if vim.g.is_win then
    vim.cmd("silent !start '" .. url .. "'")
  elseif vim.g.is_linux then
    os.execute("xdg-open \"" .. url .. "\"")
  elseif vim.g.is_mac then
    os.execute("open \"" .. url .. "\"")
  end
end

function M.get_selection_or_cword()
  if vim.api.nvim_get_mode().mode == "v" then
    return M.get_visual_selection()
  end

  return vim.fn.expand("<cword>")
end

function M.get_visual_selection()
  local _, start_line, start_col = unpack(vim.fn.getpos("'<"))
  local _, end_line, end_col = unpack(vim.fn.getpos("'>"))

  if start_line == end_line and start_col == end_col then
    return ""
  end

  -- Ensure column indices are within valid range
  start_col = start_col > 0 and start_col - 1 or 0
  -- if finish column exceeds line length, set it to the end of the line
  local finish_line_len = #vim.api.nvim_buf_get_lines(0, end_line - 1, end_line, true)[1]
  if end_col > finish_line_len then
    end_col = finish_line_len
  end

  local visualSelectionText = vim.api.nvim_buf_get_text(0, start_line - 1, start_col, end_line - 1, end_col, {})
  local result = table.concat(visualSelectionText, "\n")
  return result
end

function M.get_selection_or_buffer()
  local selection = M.get_visual_selection()

  if selection ~= "" then
    return selection
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  return table.concat(lines, "\n")
end

function M.trySetup(package, opts)
  local ok, p = pcall(require, package)
  if ok then
    if opts == nil then
      p.setup()
    elseif type(opts) == "function" then
      p.setup(opts(p))
    else
      p.setup(opts)
    end
  end
end

function M.reduce(fn, acc, list)
  for _, v in ipairs(list) do
    acc = fn(acc, v)
  end
  return acc
end

function M.map(fn, list)
  local result = {}
  for _, v in ipairs(list) do
    table.insert(result, fn(v))
  end
  return result
end

function M.filter(list, fn)
  local result = {}
  for _, v in ipairs(list) do
    if fn(v) then
      table.insert(result, v)
    end
  end
  return result
end

function M.find(list, fn)
  for _, v in ipairs(list) do
    if fn(v) then
      return v
    end
  end
  return nil
end

function M.index_of(list, element)
  for i, value in ipairs(list) do
    if value == element then
      return i
    end
  end
  return -1
end

function M.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function M.change_root()
  -- find nearest parent directory with .git folder or package.json
  local package_json_path = vim.fn.findfile("package.json", vim.fn.expand("%:p:h") .. ";")
  if package_json_path ~= "" then
    local package_json_dir = vim.fn.fnamemodify(package_json_path, ":h")
    print("Changing root to " .. package_json_dir)
    vim.cmd("cd " .. package_json_dir)
  end
end

_G.utils = M

return M
