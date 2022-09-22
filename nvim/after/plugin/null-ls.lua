local status, nullls = pcall(require, "null-ls")
if not status then
    return
end


nullls.setup({
    sources = {
        nullls.builtins.diagnostics.eslint_d,
        nullls.builtins.formatting.prettierd,
        nullls.builtins.formatting.stylua,
        nullls.builtins.diagnostics.eslint,
        --nullls.builtins.completion.spell,
    },
})
