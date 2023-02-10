-- TMUX commands manager
-- https://github.com/otavioschwanck/tmux-awesome-manager.nvim
return {
  "otavioschwanck/tmux-awesome-manager.nvim",
  keys = {
    -- stylua: ignore
    { "<leader>sT", function() vim.cmd(":Telescope tmux-awesome-manager list_terms") end, desc = "TMUX Awesome Manager" },
  },
  config = function()
    local tmux = require("tmux-awesome-manager")

    tmux.setup({
      per_project_commands = {
        astro = { { cmd = "pnpm dev", name = "Astro Dev" } },
      },
      session_name = "Neovim Terminals",
      project_open_as = "window",
      default_size = "30%",
      open_new_as = "window",
    })

    tmux.run_wk({ cmd = "pnpm dev", name = "Astro Development Server" })

    tmux.run_wk({ cmd = "yarn develop", name = "Brewery Server" })
    tmux.run_wk({ cmd = "MD=${PWD}/packages/xdl/ yarn dev", name = "Brewery Fast Server" })
    tmux.run_wk({ cmd = "yarn test:unit -u", name = "Brewery Unit Tests" })
  end,
}
