{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    github-copilot-cli
    nodejs-slim_latest
    rmpc
    ffmpeg
    fd
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    discord-canary
    pavucontrol
    libreoffice-fresh
    wl-clipboard
    grim
    slurp
    (import ./awww-random.nix { inherit pkgs; })
    inputs.awww.packages.${pkgs.stdenv.hostPlatform.system}.awww
    hyprpolkitagent
    libnotify # notify-send
    obsidian
    bruno
    pkgs.catppuccin-cursors.mochaDark
    google-chrome
    telegram-desktop
  ];
}
