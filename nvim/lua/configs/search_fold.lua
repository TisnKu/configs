local fzf = require("fzf_lib")
local function fold_non_matching_lines(pattern)
  vim.g.last_search_query = pattern
  vim.api.nvim_command("set foldmethod=manual")
  vim.api.nvim_exec("normal! zE", true)

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local foldstart = -1

  local slab = fzf.allocate_slab()
  local patternobj = fzf.parse_pattern(pattern, 0, true)

  for i, line in ipairs(lines) do
    local score = fzf.get_score(line, patternobj, slab)
    local matched = score > 0
    if not matched then
      if foldstart == -1 then
        foldstart = i
      end
    else
      if foldstart ~= -1 then
        vim.api.nvim_command(foldstart .. "," .. (i - 1) .. "fold")
        foldstart = -1
      end
    end
  end

  if foldstart ~= -1 then
    vim.api.nvim_command(foldstart .. ",$" .. "fold")
  end

  fzf.free_pattern(patternobj)
  fzf.free_slab(slab)
end

function Request_input_and_fold(reset)
  local default_query = vim.g.last_search_query or ""
  if reset then
    default_query = ""
  end

  vim.ui.input({ prompt = "Fold pattern: ", default = default_query, }, function(input)
    if input == "" or input == nil then
      return
    end
    fold_non_matching_lines(input)
  end)
end

function Add_word_or_selection_and_fold()
  local query_to_add = "'" .. utils.get_selection_or_cword()
  local last = vim.g.last_search_query or ""

  -- if last is empty, just fold the query, otherwise fold the last query and the new query
  local query = last == "" and query_to_add or last .. " " .. query_to_add
  fold_non_matching_lines(query)
end

vim.keymap.set({ "n", "v" }, "<leader>zz", ":lua Request_input_and_fold(true)<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>ze", ":lua Request_input_and_fold()<CR>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>za", ":lua Add_word_or_selection_and_fold()<CR>", { noremap = true, silent = true })
