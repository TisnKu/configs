local M = {}

M.unpack = table.unpack or unpack

function M.get_visual_selection()
  local _, startLine, startColumn = unpack(vim.fn.getpos("'<"))
  local _, endLine, endColumn = unpack(vim.fn.getpos("'>"))

  -- Ensure column indices are within valid range
  startColumn = startColumn > 0 and startColumn - 1 or 0
  endColumn = endColumn > 0 and endColumn - 1 or 0

  local visualSelectionText = vim.api.nvim_buf_get_text(0, startLine - 1, startColumn, endLine - 1, endColumn, {})
  local result = table.concat(visualSelectionText, "\n")
  print(result)
  return result
end

function M.trySetup(package, opts)
  local ok, p = pcall(require, package)
  if not ok then
    vim.cmd("echom 'Failed to load " .. package .. "'")
  else
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

function M.filter(fn, list)
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

function M.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

_G.utils = M

return M
