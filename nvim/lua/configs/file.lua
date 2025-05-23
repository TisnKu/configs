-- Copy current buffer file path to clipboard
-- register a command
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
