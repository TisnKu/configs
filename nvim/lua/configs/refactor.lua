vim.keymap.set(
  { "n", "x" },
  "<Space>rr",
  function() require('refactoring').select_refactor() end
)
