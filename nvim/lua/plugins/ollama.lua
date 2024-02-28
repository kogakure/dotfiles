-- Generate text using LLMs with customizable prompts
-- https://github.com/David-Kunz/gen.nvim
return {
  "David-Kunz/gen.nvim",
  opts = {
    model = "mistral", -- The default model to use.
    host = "localhost", -- The host running the Ollama service.
    port = "11434", -- The port on which the Ollama service is listening.
    display_mode = "split", -- The display mode. Can be "float" or "split".
    show_prompt = true, -- Shows the Prompt submitted to Ollama.
    show_model = true, -- Displays which model you are using at the beginning of your chat session.
    no_auto_close = false, -- Never closes the window automatically.
    init = function(options)
      pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
    end,
    command = function(options)
      return "curl --silent --no-buffer -X POST http://"
        .. options.host
        .. ":"
        .. options.port
        .. "/api/generate -d $body"
    end,
    debug = false, -- Prints errors and the command which is run.
  },
}
