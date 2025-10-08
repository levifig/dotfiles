#!/usr/bin/env zsh
# Cached completion system for faster ZSH startup

_cache_completion() {
    local tool=$1
    local command=$2
    local cache_file="$XDG_CACHE_HOME/zsh/${tool}_completion.zsh"
    local tool_path=$(command -v $tool)
    
    # Create cache directory if it doesn't exist
    [[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
    
    local should_regenerate=false
    
    # Check if cache needs regeneration
    if [[ ! -f "$cache_file" ]]; then
        should_regenerate=true
    elif [[ "$tool_path" -nt "$cache_file" ]]; then
        should_regenerate=true
    elif [[ -n "$FORCE_COMPLETION_REFRESH" ]]; then
        should_regenerate=true
    fi
    
    # Regenerate cache if needed
    if $should_regenerate; then
        echo "# Cached completion for $tool" > "$cache_file"
        echo "# Generated on $(date)" >> "$cache_file"
        echo "# Tool path: $tool_path" >> "$cache_file"
        echo "# Tool version: $(eval "$tool --version 2>/dev/null | head -1")" >> "$cache_file"
        echo "" >> "$cache_file"
        
        # Generate and cache the completion
        eval "$command" >> "$cache_file" 2>/dev/null
        
        # Add error handling
        if [[ $? -ne 0 ]]; then
            echo "# Error generating completion for $tool" >> "$cache_file"
            return 1
        fi
    fi
    
    # Source the cached completion
    if [[ -f "$cache_file" ]] && [[ -s "$cache_file" ]]; then
        source "$cache_file"
    fi
}

_cache_or_eval() {
    local tool=$1
    local command=$2
    
    if command -v "$tool" &>/dev/null; then
        _cache_completion "$tool" "$command"
    fi
}

# Batch function for multiple completions
_cache_completions() {
    local -A completions
    completions=("$@")
    
    for tool command in "${(@kv)completions}"; do
        if command -v "$tool" &>/dev/null; then
            _cache_completion "$tool" "$command"
        fi
    done
}

# Helper function to refresh all completion caches
refresh_completion_cache() {
    echo "Refreshing completion caches..."
    FORCE_COMPLETION_REFRESH=1
    rm -f "$XDG_CACHE_HOME/zsh"/*_completion.zsh 2>/dev/null
    echo "Cache cleared. Restart your shell to regenerate."
}
