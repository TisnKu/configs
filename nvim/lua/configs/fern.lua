vim.cmd [[
  function! OpenFern()
    execute "Fern . -reveal=" . expand("%") . " -drawer -width=45 -toggle"
  endfunction

  autocmd BufRead,BufNewFile * nested call OpenFern()

  function! ToggleFileExplorer()
    Fern . -reveal=% -drawer -toggle -width=40
  endfunction

  nnoremap <space>t :call ToggleFileExplorer()<CR>
]]
