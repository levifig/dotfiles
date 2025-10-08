##
# This file is sourced on all invocations of the zsh shell.
# Source: https://github.com/leebyron/dotfiles
##

[[ -v __ZSHENV_SOURCED ]] && return
__ZSHENV_SOURCED=1

set -a
source ~/.config/xdg.env
[ -f ~/.config/local.env ] && source ~/.config/local.env
