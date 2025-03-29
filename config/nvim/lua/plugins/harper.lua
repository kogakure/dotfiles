-- Harper - Grammar and spell checker
-- https://writewithharper.com/docs/integrations/neovim
return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			harper_ls = {
				settings = {
					["harper-ls"] = {
						userDictPath = "~/.config/harper-ls/dictionary.txt",
						fileDictPath = "~/.config/harper-ls/file_dictionaries",
						linters = {
							SpellCheck = true,
							SpelledNumbers = false,
							AnA = true,
							SentenceCapitalization = true,
							UnclosedQuotes = true,
							WrongQuotes = false,
							LongSentences = true,
							RepeatedWords = true,
							Spaces = true,
							Matcher = true,
							CorrectNumberSuffix = true,
						},
						codeActions = {
							ForceStable = false,
						},
						markdown = {
							IgnoreLinkTitle = false,
						},
						diagnosticSeverity = "hint",
						isolateEnglish = false,
					},
				},
			},
		},
	},
}
