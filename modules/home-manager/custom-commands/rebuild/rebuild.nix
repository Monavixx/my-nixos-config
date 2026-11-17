{ hostname, pkgs, ... }:
let
  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    cd ~/nixos && git add .
    sudo nixos-rebuild switch --flake ~/nixos#${hostname}
  '';
in
{
  home.packages = [ rebuild ];
}
