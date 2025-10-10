# Secret Management with 1Password CLI

This dotfiles setup uses 1Password CLI for secure secret management, avoiding the need to commit sensitive data to git.

## Prerequisites

1. **1Password CLI** - Already installed via Homebrew
2. **1Password Account** - Sign in before running setup

```bash
# Sign in to 1Password
eval $(op signin)
```

## Quick Setup

Run the setup script to configure all secrets:

```bash
~/.dotfiles/scripts/setup-secrets.sh
```

This script will:
- Check if 1Password CLI is available and signed in
- Fetch secrets from 1Password for configured applications
- Create config files from templates with injected secrets
- Fall back to templates if secrets aren't found in 1Password

## Storing Secrets in 1Password

### 1. Context7 API Key (for OpenCode)

```bash
op item create \
  --category='API Credential' \
  --title='Context7 API' \
  --vault='Personal' \
  credential=ctx7sk-your-actual-key-here
```

**Reference:** `op://Personal/Context7 API/credential`

### 2. Full OpenCode Configuration (Alternative)

Store the entire config file:

```bash
op document create \
  --title='OpenCode' \
  --vault='Personal' \
  --file-name='config.json' \
  ~/.config/opencode/opencode.json
```

**Reference:** `op://Personal/OpenCode/config.json`

### 3. Other MCP Server Configurations

For other MCP servers that require API keys:

```bash
# Example: Anthropic API
op item create \
  --category='API Credential' \
  --title='Anthropic API' \
  --vault='Personal' \
  credential=sk-ant-your-key-here

# Example: OpenAI API
op item create \
  --category='API Credential' \
  --title='OpenAI API' \
  --vault='Personal' \
  credential=sk-your-key-here
```

## Application-Specific Secret Management

### OpenCode (`~/.config/opencode/opencode.json`)

**Automatic:** The Nix activation script will:
1. Try to read `op://Personal/OpenCode/config.json`
2. Fall back to injecting `op://Personal/Context7 API/credential` into template
3. Use template if no 1Password entries found

**Manual:** Run `setup-secrets.sh` or edit the file directly

### Claude (`~/.config/claude/`)

**Method:** App-managed authentication
- Claude Desktop handles auth via OAuth
- MCP server configs in `settings.json` can use op references if Claude supports them
- No manual secret management needed for core app

### Zed (`~/.config/zed/settings.json`)

**Method:** App-managed authentication
- GitHub OAuth handled by Zed
- Extension API keys managed through Zed UI
- MCP configurations in settings may need manual setup

## Adding New Secrets

When adding new applications that require secrets:

1. **Create template file** with placeholders:
   ```json
   {
     "api_key": "YOUR_API_KEY_HERE"
   }
   ```

2. **Update .gitignore** to exclude the actual config:
   ```gitignore
   app/*
   !app/config.json.template
   ```

3. **Store secret in 1Password:**
   ```bash
   op item create \
     --category='API Credential' \
     --title='App Name API' \
     --vault='Personal' \
     credential=your-key-here
   ```

4. **Add to setup script** (`scripts/setup-secrets.sh`):
   ```bash
   if op read "op://Personal/App Name API/credential" &> /dev/null; then
       # Inject secret
   fi
   ```

5. **Create Nix module** with activation script to fetch from 1Password

## Nix Activation Scripts

Modules automatically attempt 1Password integration during activation:

```nix
home.activation.setupAppConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
  if command -v op &> /dev/null && op account get &> /dev/null; then
    if op read "op://Personal/App/config" &> /dev/null; then
      op read "op://Personal/App/config" > "$HOME/.config/app/config.json"
    fi
  fi
'';
```

## Security Best Practices

### ✅ Do:
- Store all secrets in 1Password
- Use `op://` references when possible
- Use template files with placeholders in git
- Run `setup-secrets.sh` after fresh clone
- Use deny-by-default .gitignore patterns

### ❌ Don't:
- Commit actual API keys, tokens, or credentials
- Push secrets to git (even in private repos)
- Share secrets via insecure channels
- Store secrets in environment variables permanently

## Troubleshooting

### "1Password CLI is not installed"
```bash
brew install --cask 1password-cli
```

### "Please sign in to 1Password first"
```bash
eval $(op signin)
```

### "1Password reference not found"
```bash
# List all items in Personal vault
op item list --vault=Personal

# Get details of specific item
op item get "Context7 API"
```

### Secret not being injected
1. Verify item exists: `op item get "Item Name"`
2. Check reference format: `op://Vault/Item/field`
3. Ensure you're signed in: `op account get`
4. Run setup script manually: `~/.dotfiles/scripts/setup-secrets.sh`

## References

- [1Password CLI Documentation](https://developer.1password.com/docs/cli/)
- [1Password Secret References](https://developer.1password.com/docs/cli/secret-references/)
- [Nix Home Manager Activation Scripts](https://nix-community.github.io/home-manager/options.html#opt-home.activation)

---

**Last Updated:** 2025-10-10
