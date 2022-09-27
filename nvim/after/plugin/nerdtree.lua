vim.cmd [[
  function! NerdTreeToggleFind()
      if exists("g:NERDTree") && g:NERDTree.IsOpen()
          NERDTreeClose
      elseif filereadable(expand('%'))
          NERDTreeFind
      else
          NERDTree
      endif
  endfunction

  nnoremap <space>t :call NerdTreeToggleFind()<CR>
]]
