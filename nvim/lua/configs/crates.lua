local crates = require('crates')
crates.setup {
  null_ls = {
    enabled = true,
    name = "Crates"
  },
  popup = {
    autofocus = true,
  }
}

local opts = { silent = true }
vim.keymap.set('n', '<space>f', crates.show_features_popup, opts)
