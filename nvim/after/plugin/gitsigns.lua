vim.g.trySetup('gitsigns', {
    signs = {
        add = { hl = "GitGutterAdd", text = "▎", numhl = "GitGutterAddNr", linehl = "GitGutterAddLn" },
        change = { hl = "GitGutterChange", text = "▎", numhl = "GitGutterChangeNr", linehl = "GitGutterChangeLn" },
        delete = { hl = "GitGutterDelete", text = "契", numhl = "GitGutterDeleteNr", linehl = "GitGutterDeleteLn" },
        topdelete = { hl = "GitGutterDelete", text = "契", numhl = "GitGutterDeleteNr", linehl = "GitGutterDeleteLn" },
        changedelete = { hl = "GitGutterChange", text = "▎", numhl = "GitGutterChangeNr", linehl = "GitGutterChangeLn" },
    },
    numhl = false,
    linehl = false,
    keymaps = {
        -- Default keymap options
        noremap = true,
        buffer = true,
        ["n ]c"] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns\".next_hunk()<CR>'" },
        ["n [c"] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns\".prev_hunk()<CR>'" },
        ["n <leader>hs"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
        ["n <leader>hu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
        ["n <leader>hr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
        ["n <leader>hR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
        ["n <leader>hp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
        ["n <leader>hb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
        -- Text objects
        ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk<CR>',
        ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk<CR>',
    }
})
