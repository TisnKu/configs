vim.cmd [[
  nnoremap <silent> <leader>ff :<C-U>Leaderf file<CR>
  nnoremap <silent> <leader>rg :<C-U>Leaderf rg 
  noremap <leader>gg :<C-U>Leaderf! rg --recall<CR>
]]
vim.cmd("LeaderfInstallCExtension")
