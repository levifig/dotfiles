return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  config = function()
    local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then 
  return {}
end

-- Setup treesitter-context if available
local context_ok, context = pcall(require, "treesitter-context")
if context_ok then
  context.setup()
end

local languages = {
  -- Core languages
  "bash",
  "c",
  "cpp",
  "comment",
  "regex",
  "vim",
  "lua",

  -- Web development
  "html",
  "css",
  "scss",
  "javascript",
  "typescript",
  "tsx",
  "json",
  "jsonc",

  -- Backend languages
  "go",
  "gomod",
  "gowork",
  "python",
  "ruby",
  "elixir",
  "heex", -- Phoenix templates

  -- Configuration & Infrastructure
  "yaml",
  "toml",
  "dockerfile",
  "terraform",
  "hcl",

  -- Documentation & Static Sites
  "markdown",
  "markdown_inline",

  -- Other useful parsers
  "gitignore",
  "gitcommit",
  "diff",
  "sql",
}

configs.setup({
  sync_install = false,
  auto_install = false,
  ignore_install = {}, -- List of parsers to ignore installing
  
  -- Handle compilation failures gracefully
  install = {
    compilers = { "gcc", "clang" }
  },

  highlight = {
    enable = true,
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
    disable = { "python" },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<M-space>",
    },
  },

  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },

    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})

  end,
}