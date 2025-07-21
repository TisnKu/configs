-- If the wording directory is like **/notes, auto add files to git, commit and pull rebase and push every 30s

local timer = nil
local function auto_git_sync()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end

  timer = vim.loop.new_timer()
  timer:start(30000, 0, function()
    vim.schedule(function()
      -- if still in edit mode, quit
      if vim.fn.mode() ~= "n" then
        return
      end
      vim.system(
        { "pwsh", "-NoProfile", "-Command", "git add .; git commit -m 'Auto commit'; git pull --rebase; git push" },
        { text = true }, function(_)
          print("Git sync completed.")
        end)
    end)
    timer:stop()
    timer:close()
    timer = nil
  end)
end

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*" },
  callback = function()
    local cwd = vim.fn.getcwd()
    if cwd:match("/notes$") or cwd:match("\\notes$") then
      auto_git_sync()
    end
  end,
})
