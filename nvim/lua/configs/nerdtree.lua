vim.cmd [[
  let NERDTreeQuitOnOpen=1
  function! NerdTreeToggleFind()
      if exists("g:NERDTree") && g:NERDTree.IsOpen()
          NERDTreeClose
      elseif filereadable(expand('%'))
          let filename = expand('%')
          let parent_dir = fnamemodify(filename, ":h")
          if !exists("g:NERDTreeCurDir") || g:NERDTreeCurDir!= parent_dir
              let g:NERDTreeCurDir = parent_dir
              NERDTree %
          endif
          execute 'NERDTreeFind ' . filename
      else
          NERDTree
      endif
  endfunction

  nnoremap <space>t :call NerdTreeToggleFind()<CR>
]]
