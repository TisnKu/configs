local JSON = {}

-- Example input: "{\n\"x\": [\"111\", \"222\"]\n}"
-- Example output: {"x": ["111", "222"]}
JSON.parse = function()
  local json_string = utils.get_selection_or_buffer()
  local result = vim.fn.json_decode(json_string)
  vim.fn.setreg('0', result)
  vim.fn.setreg('"', result)
  vim.fn.setreg('*', result)
end

_G.JSON = JSON


-- command
vim.cmd("command! -nargs=0 JsonParse :lua JSON.parse()")
