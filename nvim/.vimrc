" Leader key mapping should be at the top of everything
let mapleader = ","

" press hh to return to normal mode
inoremap hh <esc>
vnoremap hh <esc>
cnoremap hh <esc>

" Map leader key to comma
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :q!<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>wq :wq<CR>
noremap QQ :q!<cr>
noremap WQ :wq<cr>

""""""""""""" Search mode """""""""""""""
set ignorecase smartcase

""""""""""""" Visual mode tips """""""""""""
vnoremap <leader>(( <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>[[ <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>{{ <esc>`>a}<esc>`<i{<esc>
vnoremap <leader>"" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>'' <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>`` <esc>`>a`<esc>`<i`<esc>

" quick replace selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

nnoremap <silent> <leader>ff :<C-U>Leaderf file<CR>
nnoremap <silent> <leader>rg :<C-U>Leaderf rg 
noremap <leader>gg :<C-U>Leaderf! rg --recall<CR>