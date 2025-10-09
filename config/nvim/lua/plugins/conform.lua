return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        -- Lua
        lua = { "stylua" },

        -- Python/Django
        python = { "isort", "black" },

        -- Go
        go = { "goimports", "gofmt" },

        -- Ruby/Rails
        ruby = { "rubocop" },

        -- Elixir/Phoenix
        elixir = { "mix" },

        -- JavaScript/TypeScript
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },

        -- Web technologies
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },

        -- Configuration files
        yaml = { "prettierd", "prettier", stop_after_first = true },
        toml = { "taplo" },

        -- Infrastructure as Code
        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },

        -- Kubernetes/Helm
        helm = { "prettier" },

        -- Documentation
        markdown = { "prettierd", "prettier", stop_after_first = true },

        -- Shell scripting
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },

        -- Other
        dockerfile = { "hadolint" },
      },

      -- Custom formatters
      formatters = {
        mix = {
          command = "mix",
          args = { "format", "-" },
          stdin = true,
        },
      },

      log_level = vim.log.levels.ERROR,
      notify_on_error = true,
    })
  end,
}