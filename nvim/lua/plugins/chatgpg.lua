-- ChatGPT Neovim Plugin
-- https://github.com/jackMort/ChatGPT.nvim
return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  keys = {
    {
      mode = "v",
      "<leader>e",
      function()
        require("chatgpt").edit_with_instructions()
      end,
      desc = "Edit with instructions",
    },
  },
  config = function()
    local home = vim.fn.expand("$HOME")
    local file_path = home .. "/.dotfiles/nvim/lua/plugins/chatgpg.txt.gpg"
    require("chatgpt").setup({
      api_key_cmd = "gpg --decrypt --use-agent " .. file_path,
    })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
}
