local keymap = vim.api.nvim_set_keymap

-- Basic Text Objects
function Basic_text_objects()
	local chars = { "_", ".", ":", ",", ";", "|", "/", "\\", "*", "+", "%", "`", "?" }
	for _, char in ipairs(chars) do
		for _, mode in ipairs({ "x", "o" }) do
			keymap(mode, "i" .. char, string.format(":<C-u>normal! T%svt%s<CR>", char, char), {
				noremap = true,
				silent = true,
			})
			keymap(mode, "a" .. char, string.format(":<C-u>normal! F%svf%s<CR>", char, char), {
				noremap = true,
				silent = true,
			})
		end
	end
end

function Select_indent(around)
	local start_indent = vim.fn.indent(vim.fn.line("."))
	local blank_line_pattern = "^%s*$"

	if string.match(vim.fn.getline("."), blank_line_pattern) then
		return
	end

	if vim.v.count > 0 then
		start_indent = start_indent - vim.o.shiftwidth * (vim.v.count - 1)
		if start_indent < 0 then
			start_indent = 0
		end
	end

	local prev_line = vim.fn.line(".") - 1
	local prev_blank_line = function(line)
		return string.match(vim.fn.getline(line), blank_line_pattern)
	end
	while prev_line > 0 and (prev_blank_line(prev_line) or vim.fn.indent(prev_line) >= start_indent) do
		vim.cmd("-")
		prev_line = vim.fn.line(".") - 1
	end
	if around then
		vim.cmd("-")
	end

	vim.cmd("normal! 0V")

	local next_line = vim.fn.line(".") + 1
	local next_blank_line = function(line)
		return string.match(vim.fn.getline(line), blank_line_pattern)
	end
	local last_line = vim.fn.line("$")
	while next_line <= last_line and (next_blank_line(next_line) or vim.fn.indent(next_line) >= start_indent) do
		vim.cmd("+")
		next_line = vim.fn.line(".") + 1
	end
	if around then
		vim.cmd("+")
	end
end

-- Indent Text Object
function Indent_text_objects()
	for _, mode in ipairs({ "x", "o" }) do
		keymap(mode, "ii", ":<c-u>lua select_indent()<cr>", {
			noremap = true,
			silent = true,
		})
		keymap(mode, "ai", ":<c-u>lua select_indent(true)<cr>", {
			noremap = true,
			silent = true,
		})
	end
end

return {
	basic_text_objects = Basic_text_objects,
	indent_text_objects = Indent_text_objects,
}