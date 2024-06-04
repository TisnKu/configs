if vim.g.is_win then
  vim.cmd [[
		let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
		let &shellcmdflag = '-noexit -NoLogo -ExecutionPolicy RemoteSigned -Command '
		let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
		let &shellpipe  = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
		set shellquote= shellxquote=
    let g:NERDTreeCopyFileCmd = 'cp -r ' "https://github.com/preservim/nerdtree/blob/f3a4d8eaa8ac10305e3d53851c976756ea9dc8e8/plugin/NERD_tree.vim#L96
    let g:NERDTreeRemoveDirCmd = 'rm -r '
    let g:NERDTreeCopyDirCmd = 'cp -r '
  ]]
  --vim.o.shell = 'pwsh'
  --vim.o.shellxquote = ''
  --vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
  --vim.o.shellquote = ''
  --vim.o.shellpipe = '| Out-File -Encoding UTF8 %s'
  --vim.o.shellredir = '| Out-File -Encoding UTF8 %s'
end
