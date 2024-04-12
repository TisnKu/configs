local function fold_non_matching_lines(pattern)
  vim.api.nvim_command("set foldmethod=manual")
  vim.api.nvim_exec("normal! zE", true)

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local foldstart = -1

  -- if pattern ends with a !, invert the match
  local invert = pattern:sub(-1) == "!"
  if invert then
    pattern = pattern:sub(1, -2)
  end

  for i, line in ipairs(lines) do
    local matched = line:match(pattern)
    if (invert and matched) or (not invert and not matched) then
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
end

function Request_input_and_fold()
  -- get the visual selection
  local selection = utils.get_visual_selection()
  -- prompt user for input, with the visual selection as default
  local pattern = vim.fn.input("Fold pattern: ", selection)
  fold_non_matching_lines(pattern)
end

vim.keymap.set({ "n", "v" }, "<leader>z", ":lua Request_input_and_fold()<CR>", { noremap = true, silent = true })
