-- Copilot replacement
-- https://github.com/zbirenbaum/copilot.lua
-- https://github.com/zbirenbaum/copilot-cmp
return {
  "zbirenbaum/copilot-cmp",
  dependencies = "zbirenbaum/copilot.lua",
  opts = function()
    require("copilot").setup()
  end,
}
