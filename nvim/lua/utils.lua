local M = {};

M.trySetup = function(package, opts)
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

M.reduce = function(fn, acc, list)
  for _, v in ipairs(list) do
    acc = fn(acc, v)
  end
  return acc
end

M.map = function(fn, list)
  local result = {}
  for _, v in ipairs(list) do
    table.insert(result, fn(v))
  end
  return result
end

M.filter = function(fn, list)
  local result = {}
  for _, v in ipairs(list) do
    if fn(v) then
      table.insert(result, v)
    end
  end
  return result
end

M.find = function(list, fn)
  for _, v in ipairs(list) do
    if fn(v) then
      return v
    end
  end
  return nil
end

return M;
