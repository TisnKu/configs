-- File explorer
local ok, oil = pcall(require, "oil")
if ok then
  oil.setup({
    default_file_explorer = false,
    view_options = {
      show_hidden = true,
    },
  })
  vim.keymap.set("n", "<space>e", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
end

-- Copy file path / name
vim.api.nvim_create_user_command("CopyFilePath", function()
  local filepath = vim.fn.expand("%:p")
  vim.fn.setreg("+", filepath)
  vim.notify("Copied: " .. filepath)
end, { desc = "Copy the current file path to clipboard" })

vim.api.nvim_create_user_command("CopyFileName", function()
  local filename = vim.fn.expand("%:t")
  vim.fn.setreg("+", filename)
  vim.notify("Copied: " .. filename)
end, { desc = "Copy the current file name to clipboard" })

-- Navigation
vim.api.nvim_create_user_command("CRoot", function()
  utils.change_root()
end, { desc = "Change to project root directory" })

vim.api.nvim_create_user_command("OpenFolder", function()
  local folder_path = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
  if vim.fn.has("win32") == 1 or vim.fn.has("wsl") == 1 then
    os.execute("explorer.exe " .. folder_path)
  elseif vim.fn.has("mac") == 1 then
    os.execute("open " .. folder_path)
  elseif vim.fn.has("linux") == 1 then
    os.execute("xdg-open " .. folder_path)
  else
    vim.notify("Unsupported OS", vim.log.levels.WARN)
  end
end, { desc = "Open containing folder in system file manager" })

-- External editors
vim.api.nvim_create_user_command("OpenInVSCode", function()
  local file_path = vim.fn.expand("%:p")
  local workspace = vim.fn.getcwd()
  os.execute("code -g \"" .. workspace .. "\" \"" .. file_path .. "\"")
end, { desc = "Open current file in VS Code" })

vim.api.nvim_create_user_command("OpenInVSO", function()
  local file_path = vim.fn.expand("%:p")
  if file_path:match("%.sln$") then
    vim.cmd("!ovs " .. file_path)
    return
  end
  vim.cmd("!ovs " .. vim.fn.getcwd() .. " " .. file_path)
end, { desc = "Open current file in Visual Studio" })
