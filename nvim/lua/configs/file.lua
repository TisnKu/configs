-- Copy current buffer file path to clipboard
-- register a command
vim.cmd([[
  command! -nargs=0 CopyFilePath :let @+=expand("%:p")
]])
