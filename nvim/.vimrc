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

vnoremap <leader>(( <esc>`>a)<esc>`<i(<esc>
vnoremap <leader>[[ <esc>`>a]<esc>`<i[<esc>
vnoremap <leader>{{ <esc>`>a}<esc>`<i{<esc>
vnoremap <leader>"" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>'' <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>`` <esc>`>a`<esc>`<i`<esc>

nnoremap <Leader>o o<Esc>0"_D
nnoremap <Leader>O O<Esc>0"_D

vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>