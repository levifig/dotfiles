#!/usr/bin/env zsh
# Lazy loading system for faster ZSH startup

_lazy_load() {
    local tool=$1
    local completion_cmd=$2
    
    if command -v "$tool" &>/dev/null; then
        # Create a wrapper function that loads completion on first use
        eval "$tool() {
            unfunction $tool
            $completion_cmd
            $tool \"\$@\"
        }"
    fi
}

# Setup lazy loading for expensive completions
_setup_lazy_completions() {
    _lazy_load "gh" "eval \"\$(gh completion -s zsh)\""
    _lazy_load "op" "eval \"\$(op completion zsh)\"; compdef _op op"
}