if vim.g.is_win then
  vim.cmd [[
		let &shell = executable('pwsh') ? 'pwsh' : 'powershell'
		let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';$PSStyle.OutputRendering = [System.Management.Automation.OutputRendering]::PlainText;'
		let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
		let &shellpipe  = '2>&1 | %%{ "$_" } | Tee-Object %s; exit $LastExitCode'
		set shellquote= shellxquote=
    let g:NERDTreeCopyFileCmd = 'cp -r ' "https://github.com/preservim/nerdtree/blob/f3a4d8eaa8ac10305e3d53851c976756ea9dc8e8/plugin/NERD_tree.vim#L96
    let g:NERDTreeRemoveDirCmd = 'rm -r '
    let g:NERDTreeCopyDirCmd = 'cp -r '
]]
end
