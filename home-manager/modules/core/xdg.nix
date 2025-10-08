{ config, lib, ... }:

{
  # Extended XDG Base Directory compliance
  # Ports ~/.config/xdg.env to Nix for full reproducibility

  home.sessionVariables = {
    # Note: Standard XDG Base Directory vars (CONFIG_HOME, DATA_HOME, etc.) are set in home.nix

    # XDG User Directories
    # https://wiki.archlinux.org/title/XDG_user_directories
    XDG_DESKTOP_DIR = "${config.home.homeDirectory}/Desktop";
    XDG_DOCUMENTS_DIR = "${config.home.homeDirectory}/Documents";
    XDG_DOWNLOAD_DIR = "${config.home.homeDirectory}/Downloads";
    XDG_MUSIC_DIR = "${config.home.homeDirectory}/Music";
    XDG_PICTURES_DIR = "${config.home.homeDirectory}/Pictures";
    XDG_PUBLICSHARE_DIR = "${config.home.homeDirectory}/Public";
    XDG_VIDEOS_DIR = "${config.home.homeDirectory}/Movies";  # macOS uses "Movies"
    XDG_BIN_HOME = "${config.home.homeDirectory}/.local/bin";

    # Language/Tool-specific XDG-compliant paths
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    GOPATH = "${config.xdg.dataHome}/go";

    # Node.js / NPM
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    NPM_CONFIG_TMP = "\${XDG_RUNTIME_DIR}/npm";  # Runtime-specific
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/config";
    NVM_DIR = "${config.xdg.dataHome}/nvm";
    NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_repl_history";

    # Python
    PYENV_ROOT = "${config.xdg.dataHome}/pyenv";
    PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
    PYTHONUSERBASE = "${config.xdg.dataHome}/python";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    WORKON_HOME = "${config.xdg.dataHome}/virtualenvs";

    # Docker
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    MACHINE_STORAGE_PATH = "${config.xdg.dataHome}/docker_machine";

    # Other development tools
    RIPGREP_CONFIG_PATH = "${config.xdg.configHome}/ripgrep/config";
    GNUPGHOME = "${config.xdg.configHome}/gnupg";
    FFMPEG_DATADIR = "${config.xdg.configHome}/ffmpeg";
    MYPY_CACHE_DIR = "${config.xdg.cacheHome}/mypy";

    # Shell history (zsh-specific HISTFILE is in modules/shell/zsh.nix)
    LESSHISTFILE = "${config.xdg.stateHome}/less_history";
  };

  # Note: ZDOTDIR and ZCACHEDIR are already set in modules/shell/zsh.nix
  # Note: BREW_PREFIX is platform-specific and set in platform/darwin-base.nix
}
