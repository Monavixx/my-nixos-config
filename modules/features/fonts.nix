{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts = {
      enableDefaultPackages = true;
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        corefonts
        nerd-fonts.fantasque-sans-mono
        font-awesome_4
      ];
    };
  };
}
