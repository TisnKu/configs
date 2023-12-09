local status, null_ls = pcall(require, "null-ls")
if not status then
  return
end

null_ls.setup({
  sources = {
    --null_ls.builtins.diagnostics.eslint_d,
    --null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.prettier,
    --null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.taplo,
  },
})
