require("utils").trySetup('gitsigns', function(gs)
  return {
    on_attach = function(bufnr)
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      local next_hunk = function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end
      local prev_hunk = function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end
      map('n', ']c', next_hunk, { expr = true })
      map('n', '<F7>', next_hunk, { expr = true })
      map('n', '[c', prev_hunk, { expr = true })
      map('n', '<F8>', prev_hunk, { expr = true })

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hu', gs.undo_stage_hunk)
      map('n', '<leader>hR', gs.reset_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function() gs.blame_line { full = true } end)
      map('n', '<leader>tb', gs.toggle_current_line_blame)
      map('n', '<leader>hd', gs.diffthis)
      map('n', '<leader>hD', function() gs.diffthis('~') end)
      map('n', '<leader>td', gs.toggle_deleted)

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end
  }
end)
