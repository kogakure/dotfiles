-- Chat with GitHub Copilot in Neovim
-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {},
  },
}
