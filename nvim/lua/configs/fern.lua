vim.cmd [[
  function! ToggleFileExplorer()
    Fern . -reveal=% -drawer -toggle -width=40
  endfunction

  nnoremap <space>t :call ToggleFileExplorer()<CR>
]]
