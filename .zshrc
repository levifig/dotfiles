# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(brew bundler cap cloudapp gem git git-flow github heroku node npm osx pow rails rails3 ruby extract vi-mode)

source $ZSH/oh-my-zsh.sh
source $HOME/.zsh

# Customize to your needs...
export PATH=$HOME/.rbenv/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin:/usr/local

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
