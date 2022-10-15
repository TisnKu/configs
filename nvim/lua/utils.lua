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

return M;
