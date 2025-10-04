source "$ZDOTDIR/zshrc"


test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh"


# bun completions
[ -s "/Users/levifig/.bun/_bun" ] && source "/Users/levifig/.bun/_bun"
