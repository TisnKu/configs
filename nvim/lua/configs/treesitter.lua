local status, ts = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

ts.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "00",
      node_incremental = "v",
      node_decremental = "V",
    }
  },
  highlight = {
    enable = false
  },
  ensure_installed = { "vim", "javascript", "typescript", "lua", "rust" },
  auto_install = true,
  sync_install = false,
  indent = {
    enable = true
  },
  additional_vim_regex_highlighting = false
}
vim.opt.foldlevel = 20
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
