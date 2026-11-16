{ inputs, pkgs, ... }:
{
  imports = [
    inputs.reaper-flake.homeModules.reaper
  ];
  programs.reaper = {
    enable = true;
    experimental.swell-wayland.enable = true;
    # swell.colortheme = {
    #   enable = true;
    #   preset = inputs.reaper-flake.packages.${pkgs.system}.realinux-dark-swell-theme;
    # };
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
}
