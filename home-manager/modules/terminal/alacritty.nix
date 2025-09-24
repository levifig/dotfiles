{ config, pkgs, lib, ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      # Environment variables
      env = {
        TERM = "xterm-256color";
        WINIT_X11_SCALE_FACTOR = "1";
      };

      # Window configuration
      window = {
        decorations = "buttonless";
        dynamic_padding = true;
        dynamic_title = true;
        opacity = 0.97;
        title = "Alacritty";

        padding = {
          x = 25;
          y = 15;
        };

        class = {
          general = "Alacritty";
          instance = "Alacritty";
        };
      };

      # Font configuration
      font = {
        size = 19.0;

        normal = {
          family = "PragmataPro Liga";
          style = "Regular";
        };

        bold = {
          family = "PragmataPro Liga";
          style = "Bold";
        };

        italic = {
          family = "PragmataPro Liga";
          style = "Italic";
        };

        bold_italic = {
          family = "PragmataPro Liga";
          style = "Bold Italic";
        };

        offset = {
          x = 0;
          y = 2;
        };
      };

      # Colors - Ayu Mirage theme
      colors = {
        draw_bold_text_with_bright_colors = true;

        primary = {
          background = "#1f2430";
          foreground = "#cbccc6";
        };

        normal = {
          black = "#191e2a";
          red = "#ff3333";
          green = "#bae67e";
          yellow = "#ffa759";
          blue = "#73d0ff";
          magenta = "#d4bfff";
          cyan = "#95e6cb";
          white = "#c7c7c7";
        };

        bright = {
          black = "#686868";
          red = "#f27983";
          green = "#a6cc70";
          yellow = "#ffcc66";
          blue = "#5ccfe6";
          magenta = "#cfbafa";
          cyan = "#95e6cb";
          white = "#ffffff";
        };

        cursor = {
          text = "#1f2430";
          cursor = "#ffcc66";
        };

        selection = {
          text = "CellForeground";
          background = "#33415e";
        };
      };

      # Key bindings
      keyboard.bindings = [
        {
          key = "Return";
          mods = "Super";
          action = "CreateNewWindow";
        }
        # Add more key bindings as needed
        {
          key = "K";
          mods = "Super";
          action = "ClearHistory";
        }
        {
          key = "V";
          mods = "Super";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Super";
          action = "Copy";
        }
        {
          key = "Q";
          mods = "Super";
          action = "Quit";
        }
        {
          key = "W";
          mods = "Super";
          action = "Quit";
        }
        {
          key = "N";
          mods = "Super";
          action = "CreateNewWindow";
        }
        {
          key = "Equals";
          mods = "Super";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Super";
          action = "DecreaseFontSize";
        }
        {
          key = "Key0";
          mods = "Super";
          action = "ResetFontSize";
        }
      ];

      # Scrolling
      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      # Selection
      selection = {
        save_to_clipboard = true;
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\\t";
      };

      # Mouse
      mouse = {
        hide_when_typing = true;
      };

      # Cursor
      cursor = {
        style = {
          shape = "Block";
          blinking = "Off";
        };
        vi_mode_style = {
          shape = "Underline";
          blinking = "Off";
        };
        unfocused_hollow = true;
      };

      # Live config reload
      live_config_reload = true;

      # Shell (optional - use default from user's shell)
      # shell = {
      #   program = "${pkgs.zsh}/bin/zsh";
      #   args = [ "-l" ];
      # };
    };
  };

  # Create themes directory and link theme files
  xdg.configFile."alacritty/themes" = {
    source = ./alacritty-themes;
    recursive = true;
  };

  # Or if you want to keep using existing themes
  # xdg.configFile."alacritty/themes".source =
  #   config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/alacritty/themes";
}