-- If the wording directory is like **/notes, auto add files to git, commit and pull rebase and push every 30s

local timer = nil
local function auto_git_sync()
  if timer then
    timer:stop()
  end

  timer = vim.loop.new_timer()
  timer:start(0, 30000, function()
    vim.cmd("silent !git add .")
    vim.cmd("silent !git commit -m 'Auto commit'")
    vim.cmd("silent !git pull --rebase")
    vim.cmd("silent !git push")
    print("Git sync completed.")
  end)
end

vim.api.create_autocmd("BufWritePost", {
  pattern = { "*.md" },
  callback = function()
    local cwd = vim.fn.getcwd()
    if cwd:match("/notes$") or cwd:match("\\notes$") then
      auto_git_sync()
    end
  end,
})
