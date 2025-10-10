#!/usr/bin/env bash
# Setup secrets from 1Password
# This script fetches secrets from 1Password and creates config files

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if op CLI is available
if ! command -v op &> /dev/null; then
    echo -e "${RED}Error: 1Password CLI (op) is not installed${NC}"
    echo "Install with: brew install --cask 1password-cli"
    exit 1
fi

# Check if user is signed in to 1Password
if ! op account get &> /dev/null; then
    echo -e "${YELLOW}Please sign in to 1Password first:${NC}"
    echo "eval \$(op signin)"
    exit 1
fi

echo -e "${GREEN}Setting up secrets from 1Password...${NC}"

# Function to safely create config from template
setup_config() {
    local template="$1"
    local target="$2"
    local op_reference="$3"
    local description="$4"

    if [ -f "$target" ]; then
        echo -e "${YELLOW}  ⊙ $description already exists, skipping${NC}"
        return
    fi

    if [ ! -f "$template" ]; then
        echo -e "${RED}  ✗ Template not found: $template${NC}"
        return
    fi

    echo -e "  → Setting up $description..."

    if op read "$op_reference" &> /dev/null; then
        op read "$op_reference" > "$target"
        echo -e "${GREEN}  ✓ Created $description from 1Password${NC}"
    else
        echo -e "${YELLOW}  ⊙ 1Password reference not found, using template${NC}"
        cp "$template" "$target"
        echo -e "${YELLOW}    Please edit $target and add your secrets${NC}"
    fi
}

# Setup OpenCode config
echo -e "\n${GREEN}OpenCode Configuration:${NC}"
OPENCODE_CONFIG="$HOME/.config/opencode/opencode.json"
OPENCODE_TEMPLATE="$HOME/.config/opencode/opencode.json.template"
OPENCODE_OP_REF="op://Personal/OpenCode/config.json"

if [ -f "$OPENCODE_CONFIG" ]; then
    echo -e "${YELLOW}  ⊙ OpenCode config already exists${NC}"
else
    if [ -f "$OPENCODE_TEMPLATE" ]; then
        echo -e "  → Creating OpenCode config..."

        # Try to read from 1Password
        if op read "$OPENCODE_OP_REF" &> /dev/null; then
            op read "$OPENCODE_OP_REF" > "$OPENCODE_CONFIG"
            echo -e "${GREEN}  ✓ Created from 1Password${NC}"
        else
            # No 1Password entry, check for individual secrets
            cp "$OPENCODE_TEMPLATE" "$OPENCODE_CONFIG"

            CONTEXT7_KEY_REF="op://Personal/Context7 API/credential"
            if op read "$CONTEXT7_KEY_REF" &> /dev/null; then
                CONTEXT7_KEY=$(op read "$CONTEXT7_KEY_REF")
                # Use sed to replace the placeholder
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    sed -i '' "s/YOUR_CONTEXT7_API_KEY_HERE/$CONTEXT7_KEY/" "$OPENCODE_CONFIG"
                else
                    sed -i "s/YOUR_CONTEXT7_API_KEY_HERE/$CONTEXT7_KEY/" "$OPENCODE_CONFIG"
                fi
                echo -e "${GREEN}  ✓ Injected Context7 API key from 1Password${NC}"
            else
                echo -e "${YELLOW}  ⊙ Created from template - please add Context7 API key${NC}"
                echo -e "${YELLOW}    Store in 1Password as: $CONTEXT7_KEY_REF${NC}"
            fi
        fi
    else
        echo -e "${RED}  ✗ Template not found: $OPENCODE_TEMPLATE${NC}"
    fi
fi

# Setup Claude config (if needed in the future)
echo -e "\n${GREEN}Claude Configuration:${NC}"
CLAUDE_CONFIG="$HOME/.config/claude/settings.json"
if [ -f "$CLAUDE_CONFIG" ]; then
    echo -e "${YELLOW}  ⊙ Claude config already exists${NC}"
else
    echo -e "  → Claude settings.json is managed by the app"
    echo -e "  → Auth happens via Claude desktop login"
fi

# Setup Zed config
echo -e "\n${GREEN}Zed Configuration:${NC}"
ZED_CONFIG="$HOME/.config/zed/settings.json"
ZED_TEMPLATE="$HOME/.config/zed/settings.json.template"
if [ -f "$ZED_CONFIG" ]; then
    echo -e "${YELLOW}  ⊙ Zed config already exists${NC}"
else
    if [ -f "$ZED_TEMPLATE" ]; then
        cp "$ZED_TEMPLATE" "$ZED_CONFIG"
        echo -e "${GREEN}  ✓ Created Zed config from template${NC}"
        echo -e "  → Auth via Zed application (GitHub OAuth)"
    fi
fi

echo -e "\n${GREEN}✓ Secret setup complete!${NC}"
echo -e "\nTo store new secrets in 1Password:"
echo -e "  ${YELLOW}op item create --category='API Credential' \\
    --title='Context7 API' \\
    --vault='Personal' \\
    credential=ctx7sk-your-key-here${NC}"
