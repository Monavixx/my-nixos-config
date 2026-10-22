{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    statix
    deadnix
    streamrip
    kdePackages.krdp
    kdePackages.krdc
    roslyn-ls
    vlc
    p7zip
    wev
    github-copilot-cli
    nodejs-slim_latest
    rmpc
    ffmpeg
    fd
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    discord-canary
    pavucontrol
    libreoffice
    wl-clipboard
    grim
    slurp
    (import ./custom-commands/awww-random/awww-random.nix { inherit pkgs; })
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
