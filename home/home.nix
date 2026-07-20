{ config, pkgs, inputs, ... }:
let
	rider-plugins = inputs.nix-jetbrains-plugins.lib.pluginsForIde pkgs pkgs.jetbrains.rider [
	  "com.github.copilot"
    "ca.nosuchcompany.rider.plugins.mediatr"
	];
  awww-random = (pkgs.writeShellScriptBin "awww-random" (builtins.readFile ./scripts/awww-random.sh));
in
{
  home.username = "monavixx";
  home.homeDirectory = "/home/monavixx";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    
  };
  
  imports = [
    ./awww.nix
    ./hourly-productivity-control.nix
    ./waybar.nix
    ./hyprland.nix
    inputs.catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "flamingo";
  };
  programs.home-manager.enable = true;
  
  services.swaync = {
    enable = true;
  };

  services.playerctld.enable = true;
  _module.args.awww-random = awww-random;

  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-flamingo-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "flamingo" ];
        size = "standard";
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "kvantum";
  };
  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "catppuccin-mocha-flamingo-standard";
  };
  # user-level packages (no root needed, only visible when logged in as you)
  home.packages = with pkgs; [
    inputs.inputactions-ctl.packages.${pkgs.stdenv.hostPlatform.system}.default
    wl-clipboard
    grim
    slurp
    awww-random
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    hyprpolkitagent
    libnotify #notify-send
    obsidian
    bruno
    pkgs.catppuccin-cursors.mochaDark
    google-chrome
    telegram-desktop
    (buildFHSEnv {
      name = "rider"; 
      targetPkgs = pkgs: with pkgs; [
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
        export XCURSOR_THEME="catppuccin-mocha-dark-cursors"
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
    categories = [ "Development" "IDE" ];
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
      vicinae-extensions = pkgs.fetchFromGitHub {
        owner = "vicinaehq";
        repo = "extensions";
        rev = "5d1d31a698d5ac0b25b7391fcce3d920cd9c552e";
        hash = "sha256-u9QmD1FnLf+64o60L4ldx81m88eeK5/EgNYTEAt9qIo=";
      } + "/extensions";
    in {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
      close_on_focus_loss = true;
      closeOnEscape = true;
      applicationLaunchPrefix = "uwsm app -- ";
      launcher_window = {
        opacity = 0.7;
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
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit"; # Or your compositor's exit command
        text = "Logout";
        keybind = "e";
      }
      {
        label = "lock";
        action = "hyprlock"; # Assumes you have swaylock installed
        text = "Lock";
        keybind = "l";
      }
    ];
  };
}
