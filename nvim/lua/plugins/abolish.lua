-- Automatically fix spelling mistakes
-- https://github.com/tpope/vim-abolish
return {
  "tpope/vim-abolish",
  config = function()
    vim.api.nvim_command("Abolish teh the")
    vim.api.nvim_command("Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {despe,sepa}rat{}")
  end,
}
