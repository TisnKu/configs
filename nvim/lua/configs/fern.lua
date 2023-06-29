vim.cmd [[
  function! ToggleFileExplorer()
    Fern . -reveal=% -drawer -toggle
  endfunction

  nnoremap <space>t :call ToggleFileExplorer()<CR>
]]

