{ self, inputs, ... }:
{
  flake.modules.homeManager.ayugram-desktop =
    { config, pkgs, ... }:
    let
      ayugram = inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default;

      live =
        file:
        config.lib.file.mkOutOfStoreSymlink "${config.my.flakeRoot}/modules/features/programs/ayugram-desktop/${file}";
    in
    {
      imports = [ self.modules.homeManager.flake-root ];

      home.packages = [ ayugram ];

      xdg.dataFile."AyuGramDesktop/tdata/ayu_settings.json".source = live "ayu_settings.json";
      xdg.dataFile."AyuGramDesktop/tdata/shortcuts-custom.json".source = live "shortcuts-custom.json";
    };
}
