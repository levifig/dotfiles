#! /bin/bash


if [ -f ~/.zsh ]
then
  mv ~/.zsh ~/.zsh.before
  ln -s ~/.dotfiles/zsh ~/.zsh
  echo Backing up old .zsh and linking new one...
else
  ln -s ~/.dotfiles/zsh ~/.zsh
  echo Linking .zsh...
fi

if [ -f ~/.zshrc ]
then
  mv ~/.zshrc ~/.zshrc.before
  ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
  echo Backing up old .zshrc and linking new one...
else
  ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
  echo Linking .zshrc...
fi

if [ -f ~/.oh-my-zsh ]
then
  mv ~/.oh-my-zsh ~/.oh-my-zsh.before
  ln -s ~/.dotfiles/oh-my-zsh ~/.oh-my-zsh
  echo Backing up old .oh-my-zsh and linking new one...
else
  ln -s ~/.dotfiles/oh-my-zsh ~/.oh-my-zsh
  echo Linking .oh-my-zsh...
fi

if [ -f ~/.tmux ]
then
  mv ~/.tmux ~/.tmux.before
  ln -s ~/.dotfiles/tmux ~/.tmux
  echo Backing up old .tmux and linking new one...
else
  ln -s ~/.dotfiles/tmux ~/.tmux
  echo Linking .tmux...
fi

if [ -f ~/.tmux.conf ]
then
  mv ~/.tmux.conf ~/.tmux.conf.before
  ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
  echo Backing up old .tmux.conf and linking new one...
else
  ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
  echo Linking .tmux.conf...
fi

if [ -f ~/.tmuxifier ]
then
  mv ~/.tmuxifier ~/.tmuxifier.before
  ln -s ~/.dotfiles/tmuxifier ~/.tmuxifier
  echo Backing up old .tmuxifier and linking new one...
else
  ln -s ~/.dotfiles/tmuxifier ~/.tmuxifier
  echo Linking .tmuxifier...
fi

if [ -f ~/.vim ]
then
  mv ~/.vim ~/.vim.before
  ln -s ~/.dotfiles/vim ~/.vim
  echo Backing up old .vim and linking new one...
else
  ln -s ~/.dotfiles/vim ~/.vim
  echo Linking .vim...
fi

if [ -f ~/.vimrc ]
then
  mv ~/.vimrc ~/.vimrc.before
  ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
  echo Backing up old .vimrc and linking new one...
else
  ln -s ~/.dotfiles/vim/vimrc ~/.vimrc
  echo Linking .vimrc...
fi

if [ -f ~/.gvimrc ]
then
  mv ~/.gvimrc ~/.gvimrc.before
  ln -s ~/.dotfiles/vim/gvimrc ~/.gvimrc
  echo Backing up old .gvimrc and linking new one...
else
  ln -s ~/.dotfiles/vim/gvimrc ~/.gvimrc
  echo Linking .gvimrc...
fi

if [ -f ~/.gemrc ]
then
  mv ~/.gemrc ~/.gemrc.before
  ln -s ~/.dotfiles/system/gemrc ~/.gemrc
  echo Backing up old .gemrc and linking new one...
else
  ln -s ~/.dotfiles/system/gemrc ~/.gemrc
  echo Linking .gemrc...
fi

if [ -f ~/.gitconfig ]
then
  mv ~/.gitconfig ~/.gitconfig.before
  ln -s ~/.dotfiles/system/gitconfig ~/.gitconfig
  echo Backing up old .gitconfig and linking new one...
else
  ln -s ~/.dotfiles/system/gitconfig ~/.gitconfig
  echo Linking .gitconfig...
fi

if [ -f ~/.gitignore.global ]
then
  mv ~/.gitignore.global ~/.gitignore.global.before
  ln -s ~/.dotfiles/system/gitignore.global ~/.gitignore.global
  echo Backing up old .gitignore.global and linking new one...
else
  ln -s ~/.dotfiles/system/gitignore.global ~/.gitignore.global
  echo Linking .gitignore.global...
fi
