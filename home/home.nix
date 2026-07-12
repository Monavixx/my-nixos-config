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

  imports = [
    ./waybar.nix
    ./hyprland.nix
  ];
  programs.home-manager.enable = true;
  # user-level packages (no root needed, only visible when logged in as you)
  home.packages = with pkgs; [
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
	curl
      ];
      # Inject the variable INSIDE the FHS environment before launching Rider
      runScript = pkgs.writeScript "rider-wrapper" ''
        #!/bin/sh
        export DOTNET_ROOT="${pkgs.dotnet-sdk_10}"
        export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
	export NIXOS_OZONE_HL="1"
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
}
