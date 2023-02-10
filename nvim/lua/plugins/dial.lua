-- Enhanced increment/decrement
-- https://github.com/monaqa/dial.nvim
return {
  "monaqa/dial.nvim",
  config = function()
    local augend = require("dial.augend")
    local opts = { noremap = true, silent = true }

    require("dial.config").augends:register_group({
      default = {
        augend.constant.alias.bool,
        augend.constant.alias.de_weekday,
        augend.constant.alias.de_weekday_full,
        augend.date.alias["%d.%m.%Y"],
        augend.hexcolor.new({ case = "lower" }),
        augend.integer.alias.decimal_int,
        augend.semver.alias.semver,
      },
    })

    vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), opts)
    vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), opts)
    vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(), opts)
    vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(), opts)
    vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(), opts)
    vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(), opts)
  end,
}
