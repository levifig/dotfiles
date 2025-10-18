return {
  "sourcegraph/amp.nvim",
  branch = "main",
  lazy = false,
  opts = {
    auto_start = true,
    log_level = "info",
  },
  config = function(_, opts)
    require("amp").setup(opts)

    -- Custom commands for Amp integration

    -- Send a quick message to the agent
    vim.api.nvim_create_user_command("AmpSend", function(args)
      local message = args.args
      if message == "" then
        print("Please provide a message to send")
        return
      end
      require("amp.message").send_message(message)
    end, {
      nargs = "*",
      desc = "Send a message to Amp",
    })

    -- Send entire buffer contents
    vim.api.nvim_create_user_command("AmpSendBuffer", function()
      local buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local content = table.concat(lines, "\n")
      require("amp.message").send_message(content)
    end, {
      desc = "Send current buffer contents to Amp",
    })

    -- Add selected text directly to prompt
    vim.api.nvim_create_user_command("AmpPromptSelection", function(args)
      local lines = vim.api.nvim_buf_get_lines(0, args.line1 - 1, args.line2, false)
      local text = table.concat(lines, "\n")
      require("amp.message").send_to_prompt(text)
    end, {
      range = true,
      desc = "Add selected text to Amp prompt",
    })

    -- Add file+selection reference to prompt
    vim.api.nvim_create_user_command("AmpPromptRef", function(args)
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname == "" then
        print("Current buffer has no filename")
        return
      end

      local relative_path = vim.fn.fnamemodify(bufname, ":.")
      local ref = "@" .. relative_path
      if args.line1 ~= args.line2 then
        ref = ref .. "#L" .. args.line1 .. "-" .. args.line2
      elseif args.line1 > 1 then
        ref = ref .. "#L" .. args.line1
      end

      require("amp.message").send_to_prompt(ref)
    end, {
      range = true,
      desc = "Add file reference (with selection) to Amp prompt",
    })
  end,
}
