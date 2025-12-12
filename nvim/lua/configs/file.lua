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


vim.cmd([[
  command! -nargs=0 CopyFilePath :let @+=expand("%:p")
]])

vim.cmd([[
  command! -nargs=0 CRoot :lua utils.change_root()
]])

_G.open_folder = function()
  local file_path = vim.fn.expand("%:p")
  local folder_path = vim.fn.fnamemodify(file_path, ":h")
  -- Windows, wsl, mac and linux
  if vim.fn.has("win32") == 1 then
    os.execute("explorer.exe " .. folder_path)
  elseif vim.fn.has("wsl") == 1 then
    os.execute("explorer.exe " .. folder_path)
  elseif vim.fn.has("mac") == 1 then
    os.execute("open " .. folder_path)
  elseif vim.fn.has("linux") == 1 then
    os.execute("xdg-open " .. folder_path)
  else
    print("Unsupported OS")
  end
end

vim.cmd([[
  command! -nargs=0 OpenFolder :lua open_folder()
]])
-- create command to open the file in vs code
vim.api.nvim_create_user_command("OpenInVSCode", function()
  local file_path = vim.fn.expand("%:p")
  local workspace = vim.fn.getcwd()
  os.execute("code -g \"" .. workspace .. "\" \"" .. file_path .. "\"")
end, { desc = "Open current file in VS Code" })

-- create command to open the file in visual studio
vim.api.nvim_create_user_command("OpenInVSO", function()
  vim.cmd("!ovs " .. vim.fn.getcwd() .. " " .. vim.fn.expand("%:p"))
end, { desc = "Open current file in VS" })
