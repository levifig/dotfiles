{ config, lib, pkgs, ... }:

{
  # Deploy vim runtime files to ~/.vim/
  home.file.".vim/autoload" = lib.mkIf
    (builtins.pathExists ../../../config/vim/autoload) {
    source = ../../../config/vim/autoload;
    recursive = true;
  };

  # Deploy vimrc to ~/.vimrc
  home.file.".vimrc" = lib.mkIf
    (builtins.pathExists ../../../config/vim/vimrc) {
    source = ../../../config/vim/vimrc;
  };

  # Deploy gvimrc to ~/.gvimrc
  home.file.".gvimrc" = lib.mkIf
    (builtins.pathExists ../../../config/vim/gvimrc) {
    source = ../../../config/vim/gvimrc;
  };
}
