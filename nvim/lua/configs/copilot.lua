-- Configuration for CopilotChat
local copilotChatConfig = {
  window = {
    layout = 'float',
  },
  mappings = {
    close = {
      normal = '<esc>',
    },
    submit_prompt = {
      normal = '<cr>',
      insert = '<cr>',
    },
  },
  selection = function(source)
    local select = require('CopilotChat.select')
    return select.visual(source) or select.buffer(source)
  end,
  prompts = {
    Refactor = {
      prompt = '/COPILOT_REFACTOR Refactor the selected code to be cleaner and more readable.'
    },
    Performance = {
      prompt = '/COPILOT_REFACTOR Improve the performance of the code.'
    },
  }
}

local function selection(source)
  local select = require('CopilotChat.select')
  return select.visual(source) or select.buffer(source)
end

function Ask_copilot()
  vim.ui.input({ prompt = "Github Copilot Chat:", default = "/COPILOT_INSTRUCTIONS " }, function(prompt)
    if not prompt or prompt == "" then
      return
    end
    require('CopilotChat').ask(prompt, { selection = selection })
  end)
end

function Ask_copilot_workspace()
  vim.ui.input({ prompt = "Github Copilot Workspace:", default = "/COPILOT_WORKSPACE " }, function(prompt)
    if not prompt or prompt == "" then
      return
    end
    require('CopilotChat').ask(prompt, { system_prompt = require('CopilotChat.prompts').COPILOT_WORKSPACE })
  end)
end

vim.keymap.set({ "n", "v" }, "<space>p", ":lua Ask_copilot()<CR>", { noremap = true, silent = true })

-- Setup CopilotChat with the configuration
utils.trySetup("CopilotChat", copilotChatConfig)

-- Keybindings for GitHub Copilot
local isMac = vim.g.is_mac
local nextKey, previousKey = isMac and '¬' or '<A-l>', isMac and '˙' or '<A-h>'

vim.api.nvim_set_keymap('i', nextKey, '<Plug>(copilot-next)', {})
vim.api.nvim_set_keymap('i', previousKey, '<Plug>(copilot-previous)', {})
