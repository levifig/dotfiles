{ config, pkgs, lib, ... }:

{
  programs.tmux = {
    enable = true;

    # Basic settings
    terminal = "xterm-256color";
    historyLimit = 100000;
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 0;

    # Prefix key
    prefix = "C-a";

    # Plugins
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      pain-control
      resurrect
      continuum
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "git cpu-usage ram-usage"
          set -g @dracula-show-powerline true
          set -g @dracula-show-left-icon session
        '';
      }
    ];

    # Extra configuration
    extraConfig = ''
      # True color support
      set-option -sa terminal-overrides ",xterm*:Tc"
      set-option -g focus-events on
      set-window-option -g xterm-keys on

      # Window settings
      set -g renumber-windows on
      set -g set-clipboard on
      set-option -g allow-rename on
      set-window-option -g mode-keys vi

      # Split commands
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Window navigation
      bind t next-window
      bind T previous-window
      bind C-o rotate-window -D

      # Quick window switching
      bind -n S-Left previous-window
      bind -n S-Right next-window

      # Window swapping
      bind -n C-S-Left swap-window -t -1\; select-window -t -1
      bind -n C-S-Right swap-window -t +1\; select-window -t +1

      # Session management
      bind S choose-session
      bind -n M-b switch-client -l
      bind -n M-n switch-client -n
      bind -n M-p switch-client -p

      # Copy mode
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle

      # Status bar
      set-window-option -g monitor-activity on
      set -g visual-activity off
      set -g status-interval 2
      set -g status-position top
      set -g status-left-length 200

      # Resurrect/Continuum settings
      set -g @resurrect-strategy-vim 'session'
      set -g @resurrect-strategy-nvim 'session'
      set -g @resurrect-capture-pane-contents 'on'
      set -g @continuum-restore 'on'

      # Session switcher with fzf
      bind C-j display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
    '';
  };
}