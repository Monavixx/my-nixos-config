{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    unzip
    bind
    kdePackages.qtdeclarative
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    discord-canary
    pavucontrol
    libreoffice
    wl-clipboard
    grim
    slurp
    hyprpolkitagent
    libnotify # notify-send
    obsidian
    bruno
    # google-chrome
    # telegram-desktop
  ];
}
