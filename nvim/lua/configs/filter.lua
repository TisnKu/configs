local function filter_buffer(pattern)
  local fzf = require("fzf_lib")
  vim.g.last_search_query = pattern

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local slab = fzf.allocate_slab()
  local patternobj = fzf.parse_pattern(pattern, 0, true)
  local new_lines = {}

  local max_line_number_len = #tostring(#lines)

  for i, line in ipairs(lines) do
    local score = fzf.get_score(line, patternobj, slab)
    local matched = score > 0
    if matched then
      -- add line number to the beginning of the line
      local num_str = tostring(i)
      local padding = string.rep(" ", max_line_number_len - #num_str)
      local line_with_number = num_str .. padding .. "# " .. line
      table.insert(new_lines, line_with_number)
    end
  end

  print("Filtered " .. #lines .. " lines to " .. #new_lines .. " lines")

  -- open a new readonly buffer with the filtered lines
  local new_bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(new_bufnr, 0, -1, false, new_lines)
  vim.api.nvim_buf_set_option(new_bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(new_bufnr, "bufhidden", "wipe")
  -- set filetype to the current buffer filetype
  vim.api.nvim_buf_set_option(new_bufnr, "filetype", vim.api.nvim_buf_get_option(bufnr, "filetype"))

  -- set the new buffer as the current buffer in new tab
  vim.api.nvim_command("tabnew")
  vim.api.nvim_command("buffer " .. new_bufnr)

  fzf.free_pattern(patternobj)
  fzf.free_slab(slab)
end

function Request_input_and_filter(reset)
  local default_query = vim.g.last_search_query or ""
  if reset then
    default_query = ""
  end

  vim.ui.input({ prompt = "Filter pattern: ", default = default_query, }, function(input)
    if input == "" or input == nil then
      return
    end
    filter_buffer(input)
  end)
end

function Add_word_or_selection_and_filter()
  local query_to_add = "'" .. utils.get_selection_or_cword()
  local last = vim.g.last_search_query or ""

  local query = last == "" and query_to_add or last .. " " .. query_to_add
  filter_buffer(query)
end

vim.keymap.set({ "n", "v" }, "<leader>zz", ":lua Request_input_and_filter(true)<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>ze", ":lua Request_input_and_filter()<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>za", ":lua Add_word_or_selection_and_filter()<CR>",
  { noremap = true, silent = true })
