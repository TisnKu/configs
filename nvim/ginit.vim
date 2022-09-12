"""""" Neovim settings """"""
let g:neovide_remember_window_size = v:true

function Neovide_fullscreen()
    if g:neovide_fullscreen == v:true
        let g:neovide_fullscreen=v:false
    else
        let g:neovide_fullscreen=v:true
    endif
endfunction
map <F12> :call Neovide_fullscreen()<cr>