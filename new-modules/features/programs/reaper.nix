{ inputs, ... }:
{
  flake.modules.homeManager.reaper =
    { pkgs, ... }:
    {
      imports = [
        inputs.reaper-flake.homeModules.reaper
      ];
      programs.reaper = {
        enable = true;
        experimental.swell-wayland.enable = true;
        packages = with pkgs; [
          pipewire.jack
          freetype
          libpng
          zlib
          fontconfig
          libepoxy
          gtk3
          cairo
          glib
        ];
      };
    };
}
