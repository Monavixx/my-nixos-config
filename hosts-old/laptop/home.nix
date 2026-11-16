{
  # pkgs,
  ...
}:
{
  imports = [
    ../../modules/home-manager/common.nix
    ./games/factorio.nix
  ];

  # home.packages = with pkgs; [
  # ];

}
