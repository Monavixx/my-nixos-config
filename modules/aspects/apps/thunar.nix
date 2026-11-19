{
  den.aspects.thunar.nixos =
    { pkgs, ... }:
    {
      programs.thunar.enable = true;

      programs.thunar.plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];

      # Enable GTK/Xfce settings manager (so Thunar's preferences are saved)
      programs.xfconf.enable = true;

      # Enable volume auto-mounting and trash support (requires gvfs)
      services.gvfs.enable = true;

      # Enable image and video thumbnails (requires tumbler)
      services.tumbler.enable = true;
    };
}
