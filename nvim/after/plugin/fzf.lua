vim.keymap.set("n", "<leader>f", "<cmd>call fzf#run(fzf#wrap({\"source\": \"rg --files\"}))<cr>")
--vim.keymap.set("n", "<leader>f", ":FZF<cr>")
vim.keymap.set("n", "<leader>rg", ":RG<cr>")
vim.keymap.set("n", "<leader>zg", ":Rg<cr>")

vim.cmd [[
  let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.4, 'yoffset': 1, 'border': 'horizontal' } }

  function! RipgrepFzf(query, fullscreen)
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction

  command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
]]
