{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  flavor = "mocha";
  accent = "flamingo";
  rider-plugins = inputs.nix-jetbrains-plugins.lib.pluginsForIde pkgs pkgs.jetbrains.rider [
    "com.github.copilot"
    "ca.nosuchcompany.rider.plugins.mediatr"
    "com.github.catppuccin.jetbrains"
    "Key Promoter X"
  ];
  awww-random = (
    pkgs.writeShellScriptBin "awww-random" (builtins.readFile ../../scripts/awww-random.sh)
  );
in
{
  home.username = "monavixx";
  home.homeDirectory = "/home/monavixx";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    SAL_USE_VCLPLUGIN = "gtk4"; # or "gtk" for GTK3
    GDK_BACKEND = "wayland";
    NIXOS_OZONE_WL = "1";
  };
  home.sessionPath = [
  ];

  _module.args.awww-random = awww-random;
  imports = [
    # ./nvf.nix
    ./neovim/neovim.nix
    ./awww.nix
    ./hourly-productivity-control.nix
    ./waybar.nix
    ./hyprland.nix
    inputs.catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    autoEnable = true;
    inherit flavor;
    inherit accent;
  };
  programs.home-manager.enable = true;

  services.swaync = {
    enable = true;
  };

  services.playerctld.enable = true;

  #xdg.mimeApps = {
  #  enable = true;
  #  defaultApplications = {
  #    "application/json" = "dev.zed.Zed.desktop";
  #    "application/schema+json" = "dev.zed.Zed.desktop";
  #  };
  #};

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-${flavor}-${accent}-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ accent ];
        size = "standard";
        variant = flavor;
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
    style.name = "kvantum";
  };
  home.pointerCursor = {
    enable = true;
    name = "catppuccin-${flavor}-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "catppuccin-${flavor}-${accent}-standard";
  };
  # user-level packages (no root needed, only visible when logged in as you)
  home.packages = with pkgs; [
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    discord-canary
    pavucontrol
    libreoffice-fresh
    wl-clipboard
    grim
    slurp
    awww-random
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    hyprpolkitagent
    libnotify # notify-send
    obsidian
    bruno
    pkgs.catppuccin-cursors.mochaDark
    google-chrome
    telegram-desktop
    (buildFHSEnv {
      name = "rider";
      targetPkgs =
        pkgs: with pkgs; [
          (pkgs.jetbrains.plugins.addPlugins jetbrains.rider (lib.attrValues rider-plugins))
          dotnet-sdk_10
          zlib
          glibc
          icu
          openssl
          catppuccin-cursors.mochaDark
          curl
        ];
      # Inject the variable INSIDE the FHS environment before launching Rider
      runScript = pkgs.writeScript "rider-wrapper" ''
        #!/bin/sh
        export DOTNET_ROOT="${pkgs.dotnet-sdk_10}"
        export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
        export NIXOS_OZONE_HL="1"
        export XCURSOR_THEME="catppuccin-${flavor}-dark-cursors"
        export XCURSOR_SIZE="24"
        export HYPRCURSOR_SIZE="24"
        export PATH="$HOME/.dotnet/tools:$PATH"
        exec rider "$@"
      '';
    })
  ];
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
    ];
  };
  programs.mpv = {
    enable = true;
    package = (
      pkgs.mpv.override {
        scripts = with pkgs.mpvScripts; [
          #uosc
          sponsorblock
          quality-menu
        ];

        mpv-unwrapped = pkgs.mpv-unwrapped.override {
          waylandSupport = true;
        };
      }
    );

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
      cache-default = 4000000;
    };
  };

  programs.yt-dlp = {
    enable = true;
  };

  xdg.desktopEntries.rider = {
    name = "Rider";
    genericName = "IDE";
    exec = "rider %F";
    icon = "rider"; # or a path to an icon if the name doesn't resolve
    terminal = false;
    categories = [
      "Development"
      "IDE"
    ];
  };

  programs.yazi = {
    enable = true;
  };
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.6";
    };
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      sumneko.lua
    ];
    profiles.default.userSettings = {
      "editor.fontFamily" = "'FantasqueSansM Nerd Font', 'JetBrains Mono', monospace";
      "editor.fontLigatures" = true;
    };
  };

  programs.vicinae =
    let
      vicinae-extensions =
        pkgs.fetchFromGitHub {
          owner = "vicinaehq";
          repo = "extensions";
          rev = "5d1d31a698d5ac0b25b7391fcce3d920cd9c552e";
          hash = "sha256-u9QmD1FnLf+64o60L4ldx81m88eeK5/EgNYTEAt9qIo=";
        }
        + "/extensions";
    in
    {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
      };
      settings = {
        close_on_focus_loss = true;
        pop_to_root_on_close = true;
        launcher_window = {
          opacity = 0.7;
        };
        input_server = {
          enabled = false;
        };
        theme = {
          dark = {
            icon_theme = "Papirus-Dark";
          };
        };
        fallbacks = [ ];
        providers = {
          files = {
            enabled = false;
            preferences = {
              autoIndexing = false;
            };
          };
          applications = {
            preferences = {
              launchPrefix = "uwsm app -- ";
            };
          };
        };
      };
      extensions = [
        (config.lib.vicinae.mkExtension {
          name = "nix";
          src = vicinae-extensions + "/nix";
        })
        (config.lib.vicinae.mkRayCastExtension {
          name = "obsidian";
          rev = "14455eda4fb82586bd177c8805cb37b08f2a1336";
          sha256 = "sha256-3qBCTZIHTyUn7vYwd2HoZJ6RAcba+bDbcGm1dn07DSI=";
        })
      ];
    };
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "monavixx";
        email = "dperelygin0@gmail.com";
      };
    };
  };
  programs.hyprlock.enable = true;

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "logout";
        action = "command -v uwsm >/dev/null 2>&1 && uwsm stop || hyprctl dispatch 'hl.dsp.exit()'";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
    ];
  };
  programs.bash.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
