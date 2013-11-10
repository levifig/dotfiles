# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_CONFIG=$HOME/.zsh
ZSH_THEME="gentoo"
COMPLETION_WAITING_DOTS="true"
plugins=(brew cap gem git git-flow github npm osx pow rails rails3 ruby extract)

source $ZSH/oh-my-zsh.sh
source $ZSH_CONFIG/*.sh

# Customize to your needs...
export PATH=/usr/local/bin:/bin:/usr/sbin:/sbin:/usr/bin:/usr/X11/bin

# =================== #
#  Personal Settings  #
# =================== #
unsetopt correct_all

alias m='mvim'
alias v='vim'
alias weechat='weechat-curses'
alias twitter='ttytter'
alias adn='texapp'
alias t='tmux -2'
alias zr='source ~/.zshrc'
alias l='ls -la'

BUNDLED_COMMANDS="ruby rails"
eval "$(rbenv init -)"

export TERM='screen-256color'
export EDITOR='mvim -f --nomru'
export PYTHONPATH='/usr/local/lib/python2.7/site-packages/'
export NODE_PATH='/usr/local/lib/node'
export SSL_CERT_FILE='/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt'

[[ -s "$HOME/.tmuxifier/init.sh" ]] && source "$HOME/.tmuxifier/init.sh"
