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
    null_ls.builtins.code_actions.gitsigns,
    null_ls.builtins.code_actions.refactoring,
    null_ls.copilot_chat,
  },
})

local helpers = require("null-ls.helpers")
local methods = require("null-ls.methods")

local CODE_ACTION = methods.internal.CODE_ACTION

local copilot_chat_source = helpers.make_builtin({
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
      local copilot_chat_actions = {
        Open = {
          callback = function()
            require('CopilotChat').open()
          end,
        },
        Prompt = {
          callback = function()
            -- Request user input for prompt, then ask CopilotChat
            vim.ui.input("Prompt: ", function(prompt)
              require('CopilotChat').ask(prompt, {
                selection = function(source)
                  local select = require('CopilotChat.select')
                  return select.visual(source) or select.buffer(source)
                end
              })
            end)
          end,
        },
        Workspace = {
          callback = function()
            -- Request user input for workspace, then ask CopilotChat
            vim.ui.input("Workspace Prompt: ", function(prompt)
              require('CopilotChat').ask(prompt, {
                system_prompt = require('CopilotChat.prompts').COPILOT_WORKSPACE
              })
            end)
          end,
        }
      }
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
            if action.callback then
              action.callback()
              return
            end
            -- delay action with 100ms
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

null_ls.register(copilot_chat_source)
