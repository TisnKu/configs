vim.cmd [[
  let g:Lf_UseCache=1
  let g:Lf_RgConfig = [
    \ "--max-columns=150",
    \ "--glob=!node_modules/*",
    \ "--glob=!dist/*",
    \ "--glob=!*/*patch",
    \ ]
  nnoremap <silent> <Leader>f<space> :Leaderf 
  nnoremap <silent> <leader>ff :<C-U>Leaderf file<CR>
  nnoremap <silent> <leader>rg :<C-U>Leaderf rg -i<CR>
  noremap <leader>gg :<C-U>Leaderf! rg --recall<CR>
]]
