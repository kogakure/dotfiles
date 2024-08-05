-- A fully featured GitHub integration for performing code reviews
-- https://github.com/ldelossa/gh.nvim
return {
  "ldelossa/gh.nvim",
  dependencies = { "ldelossa/litee.nvim" },
  config = function()
    require("litee.lib").setup()
    require("litee.gh").setup({
      jump_mode = "invoking",
      map_resize_keys = false,
      disable_keymaps = false,
      icon_set = "default",
      icon_set_custom = nil,
      git_buffer_completion = true,
      keymaps = {
        open = "<CR>",
        expand = "zo",
        collapse = "zc",
        goto_issue = "gd",
        details = "d",
        submit_comment = "<C-s>",
        actions = "<C-a>",
        resolve_thread = "<C-r>",
        goto_web = "gx",
      },
    })
  end,
}
