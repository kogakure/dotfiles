-- Dashboard
-- https://github.com/goolord/alpha-nvim
return {
  "goolord/alpha-nvim",
  cond = vim.g.vscode == nil,
  opts = function(_, opts)
    opts.section.header.val = {
      "             ▖     ",
      "┌─╮╭─╮╭─╮▖  ▖▖▄▄▗▄ ",
      "│ │├─┘│ │▝▖▞ ▌▌ ▌ ▌",
      "╵ ╵╰─╯╰─╯ ▝  ▘▘ ▘ ▘",
    }
    opts.section.buttons.val = {
      opts.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
      opts.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
      opts.button("r", "󰈞 " .. " Recent files", ":Telescope oldfiles <CR>"),
      opts.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
      opts.button("p", " " .. " Find Project", ":Telescope projects<CR>"),
      opts.button("s", "󰁯 " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
      opts.button("l", "󰒲 " .. " Lazy (Plugins)", ":Lazy<CR>"),
      opts.button("m", "󱊈 " .. " Mason (LSP, DAP, Linter, Formatter)", ":Mason<CR>"),
      opts.button("q", " " .. " Quit", ":qa<CR>"),
      opts.padding,
    }
    opts.section.header.opts.hl = "String"
    opts.section.buttons.opts.hl = "Keyword"
    opts.section.footer.opts.hl = "String"
    opts.opts.opts.noautocmd = true
  end,
}
