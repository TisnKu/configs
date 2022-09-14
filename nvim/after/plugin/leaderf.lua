vim.cmd [[
  nnoremap <silent> <Leader>f<space> :Leaderf 
  nnoremap <silent> <leader>ff :<C-U>Leaderf file<CR>
  nnoremap <silent> <leader>rg :<C-U>Leaderf rg<CR>
  noremap <leader>gg :<C-U>Leaderf! rg --recall<CR>
]]
