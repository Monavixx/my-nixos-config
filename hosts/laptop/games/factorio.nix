{ pkgs, config, ... }:
let
  factorio = pkgs.buildFHSEnv {
    name = "factorio";
    multiPkgs =
      pkgs: with pkgs; [
        mesa
      ];
    targetPkgs =
      pkgs:
      (with pkgs; [
        libGL
        wayland
        libxkbcommon
        vulkan-loader
        libx11
        libxcursor
        libxinerama
        libxi
        libxrandr
        # xorg.libX11
        # xorg.libXcursor
        # xorg.libXinerama
        # xorg.libXi
        # xorg.libXrandr
        #
        # # Audio and System requirements
        alsa-lib
        gsettings-desktop-schemas
        glib
      ]);
    profile = ''
      export WAYLAND_DISPLAY=''${WAYLAND_DISPLAY:-wayland-1}
      export DISPLAY=''${DISPLAY:-:0}
      export XDG_RUNTIME_DIR=''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
      export SDL_VIDEODRIVER=wayland
    '';

    runScript = "${config.home.homeDirectory}/games/factorio/bin/x64/factorio";
  };

in
{
  home.packages = [
    factorio
  ];
}
