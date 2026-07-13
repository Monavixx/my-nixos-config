{ config, pkgs, inputs, ... }:
let
	rider-plugins = inputs.nix-jetbrains-plugins.lib.pluginsForIde pkgs pkgs.jetbrains.rider [
	  "com.github.copilot"
	];
in
{
  home.username = "monavixx";
  home.homeDirectory = "/home/monavixx";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    XCURSOR_THEME = "catppuccin-mocha-dark-cursors";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    NIXOS_OZONE_HL = "1";
  };

  imports = [
    ./waybar.nix
    ./hyprland.nix
    #./theme.nix
    inputs.catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "flamingo";
  };
  programs.home-manager.enable = true;
  # user-level packages (no root needed, only visible when logged in as you)
  home.packages = with pkgs; [
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
        exec rider "$@"
      '';
    })
  ];

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
  };
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
      close_on_focus_loss = true;
      launcher_window = {
        opacity = 0.7;
      };
    };
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
