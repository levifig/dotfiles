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
        javascript = { { "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        javascriptreact = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },

        -- Web technologies
        html = { { "prettierd", "prettier" } },
        css = { { "prettierd", "prettier" } },
        scss = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        jsonc = { { "prettierd", "prettier" } },

        -- Configuration files
        yaml = { { "prettierd", "prettier" } },
        toml = { "taplo" },

        -- Infrastructure as Code
        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        
        -- Kubernetes/Helm
        helm = { "prettier" },

        -- Documentation
        markdown = { { "prettierd", "prettier" } },

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

      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
      
      format_after_save = {
        lsp_fallback = true,
      },
      
      log_level = vim.log.levels.ERROR,
      notify_on_error = true,
    })
  end,
}