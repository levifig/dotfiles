# AI CLI Tools - Installation Guide

Most AI CLI tools are **NOT available as npm/bun packages** and have specific installation methods.

## Available Tools

### Claude Code (Anthropic)
**Status**: Not yet publicly available as npm package

- Currently in private beta
- Check: https://claude.ai for updates
- Alternative: Use Anthropic SDK for Python

### OpenAI CLI/Codex
**Status**: No official CLI tool

- OpenAI provides APIs, not CLI tools
- Use the Python SDK:
  ```bash
  pip install --user openai
  ```
- Or use community tools like:
  ```bash
  npm install -g chatgpt-cli  # Unofficial
  ```

### Google Gemini
**Status**: Python SDK, no standalone CLI

- Install Python SDK:
  ```bash
  pip install --user google-generativeai
  ```
- Use in Python scripts:
  ```python
  import google.generativeai as genai
  genai.configure(api_key="YOUR_API_KEY")
  ```

### GitHub Copilot CLI
**Status**: Official npm package (requires subscription)

```bash
npm install -g @githubnext/github-copilot-cli
gh copilot --version
```

Add to `global-packages.sh`:
```bash
NPM_PACKAGES=(
  "@githubnext/github-copilot-cli"
)
```

### Codeium
**Status**: IDE extension, not CLI

- Install as VS Code/Vim/Neovim extension
- Not available as npm package
- Download: https://codeium.com/download

### Cursor (AI IDE)
**Status**: Full IDE, not CLI

- Download from: https://cursor.sh
- Add to homebrew casks if needed:
  ```nix
  casks = [
    "cursor"
  ];
  ```

### Continue.dev
**Status**: VS Code extension, not standalone CLI

- Install as VS Code extension
- GitHub: https://github.com/continuedev/continue

### Aider (AI Pair Programming)
**Status**: ✅ Available as Python package

```bash
pip install --user aider-chat
```

Add to `global-packages.sh`:
```bash
PYTHON_PACKAGES=(
  "aider-chat"
)
```

### Mentat (AI Coding Assistant)
**Status**: ✅ Available as Python package

```bash
pip install --user mentat
```

### GPT-Engineer
**Status**: ✅ Available as Python package

```bash
pip install --user gpt-engineer
```

## Recommended Setup

### For AI Development

```bash
# Python AI SDKs (add to global-packages.sh)
PYTHON_PACKAGES=(
  "openai"           # OpenAI API
  "anthropic"        # Claude API
  "google-generativeai"  # Gemini API
  "aider-chat"       # AI pair programming
  "gpt-engineer"     # AI code generation
)
```

### For GitHub Copilot Users

```bash
# npm packages (add to global-packages.sh)
NPM_PACKAGES=(
  "@githubnext/github-copilot-cli"
)
```

## How to Find Package Names

### For npm/bun packages:
```bash
# Search npm registry
npm search <tool-name>

# Check package page
open https://www.npmjs.com/package/<package-name>
```

### For Python packages:
```bash
# Search PyPI
pip search <tool-name>  # Note: search is disabled, use https://pypi.org

# Check package page
open https://pypi.org/project/<package-name>
```

### Verify installation:
```bash
# Test the package exists before adding to global-packages.sh
npm install -g <package-name>  # Test npm
pip install --user <package-name>  # Test pip
bun install -g <package-name>  # Test bun
```

## Common Mistakes

❌ **Wrong**: Assuming every AI tool has an npm package
```bash
BUN_PACKAGES=(
  "@opencode-ai"  # Doesn't exist
  "@anthropic-ai/claude-code"  # Not published yet
)
```

✅ **Right**: Check official docs first
```bash
# 1. Visit the tool's official website/GitHub
# 2. Find installation instructions
# 3. Add to appropriate array in global-packages.sh
```

## Official Resources

- **OpenAI**: https://platform.openai.com/docs
- **Anthropic (Claude)**: https://docs.anthropic.com
- **Google AI (Gemini)**: https://ai.google.dev
- **GitHub Copilot**: https://docs.github.com/copilot
- **Aider**: https://aider.chat
- **Codeium**: https://codeium.com

---

*Last Updated: 2025-10-08 - Initial AI CLI tools guide*
