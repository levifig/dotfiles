return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

-- Helper function to check if a linter is available
local function linter_exists(name)
  return vim.fn.executable(name) == 1
end

-- Configure linters only if they're available
local linters_by_ft = {}

-- JavaScript/TypeScript
if linter_exists("eslint_d") or linter_exists("eslint") then
  local eslint_cmd = linter_exists("eslint_d") and "eslint_d" or "eslint"
  linters_by_ft.javascript = { eslint_cmd }
  linters_by_ft.typescript = { eslint_cmd }
  linters_by_ft.javascriptreact = { eslint_cmd }
  linters_by_ft.typescriptreact = { eslint_cmd }
end

-- Python
if linter_exists("flake8") then
  linters_by_ft.python = { "flake8" }
elseif linter_exists("pylint") then
  linters_by_ft.python = { "pylint" }
end

-- Lua - only add if luacheck is available
if linter_exists("luacheck") then
  linters_by_ft.lua = { "luacheck" }
end

-- Ruby
if linter_exists("rubocop") then
  linters_by_ft.ruby = { "rubocop" }
end

-- Go
if linter_exists("golangci-lint") then
  linters_by_ft.go = { "golangcilint" }
end

-- Rust
if linter_exists("cargo") then
  linters_by_ft.rust = { "clippy" }
end

-- Shell
if linter_exists("shellcheck") then
  linters_by_ft.sh = { "shellcheck" }
  linters_by_ft.bash = { "shellcheck" }
  linters_by_ft.zsh = { "shellcheck" }
end

-- Docker
if linter_exists("hadolint") then
  linters_by_ft.dockerfile = { "hadolint" }
end

-- YAML
if linter_exists("yamllint") then
  linters_by_ft.yaml = { "yamllint" }
end

-- JSON
if linter_exists("jsonlint") then
  linters_by_ft.json = { "jsonlint" }
end

-- Markdown
if linter_exists("markdownlint") then
  linters_by_ft.markdown = { "markdownlint" }
end

-- Terraform
if linter_exists("tflint") then
  linters_by_ft.terraform = { "tflint" }
end

-- Ansible
if linter_exists("ansible-lint") then
  linters_by_ft.ansible = { "ansible-lint" }
end

lint.linters_by_ft = linters_by_ft

-- Autocmds should be defined in your main config, not in plugin configs

  end,
}