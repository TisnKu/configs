"""""""" Plugins """"""""
packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
Jetpack 'jetpackscrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Jetpack 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
call jetpack#end()

""""""" Key mappings """"""""
nnoremap <silent> <leader>ff :<C-U>Leaderf file --popup<CR>
source ./.vimrc