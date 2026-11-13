{
  inputs,
  pkgs,
  flakeRoot,
  config,
  ...
}:
let
  ayugramPkg = inputs.ayugram-desktop.packages.${pkgs.system}.default;
in
{
  home.packages = [
    ayugramPkg
  ];
  xdg.dataFile."AyuGramDesktop/tdata/ayu_settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/home-manager/ayugram-desktop/ayu_settings.json";
  xdg.dataFile."AyuGramDesktop/tdata/shortcuts-custom.json".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/modules/home-manager/ayugram-desktop/shortcuts-custom.json";
}
