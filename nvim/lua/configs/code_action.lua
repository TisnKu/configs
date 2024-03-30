local nullls = require("null-ls")
local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local CODE_ACTION = methods.internal.CODE_ACTION

local copilot_chat_source = h.make_builtin({
  name = "copilot_chat",
  meta = {
    url = "https://github.com/CopilotC-Nvim/CopilotChat.nvim?tab=readme-ov-file",
    description =
    "Injects code actions for CopilotChat.nvim",
  },
  method = CODE_ACTION,
  filetypes = {},
  generator = {
    fn = function(_)
      local _, help_actions = pcall(require("CopilotChat.actions").help_actions)
      local _, prompt_actions = pcall(require("CopilotChat.actions").prompt_actions)
      local copilot_chat_actions = {}
      if help_actions then
        copilot_chat_actions = vim.tbl_extend("force", copilot_chat_actions, help_actions.actions)
      end
      if prompt_actions then
        copilot_chat_actions = vim.tbl_extend("force", copilot_chat_actions, prompt_actions.actions)
      end

      local actions = {}
      for name, action in pairs(copilot_chat_actions) do
        table.insert(actions, {
          title = 'CopilotChat ' .. name,
          action = function()
            vim.defer_fn(function()
              require('CopilotChat').ask(action.prompt, action)
            end, 100)
          end,
        })
      end
      return actions
    end
  }
})

nullls.register(copilot_chat_source)
