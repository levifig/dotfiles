# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_CONFIG=$HOME/.zsh
ZSH_THEME="gentoo"
COMPLETION_WAITING_DOTS="true"
plugins=(brew bundler cap cloudapp gem git git-flow github heroku node npm osx pow rails rails3 ruby extract vi-mode)

source $ZSH/oh-my-zsh.sh
source $ZSH_CONFIG/*.sh

# Customize to your needs...
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/local

# =================== #
#  Personal Settings  #
# =================== #
unsetopt correct_all

alias m='mvim'
alias vi='vim'

BUNDLED_COMMANDS="ruby rails"
# eval "$(rbenv init -)"

export EDITOR='mvim -f -c "au VimLeave * !open -a iTerm"'

# RVM
[[ -s "/Users/levifig/.rvm/scripts/rvm" ]] && source "/Users/levifig/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
