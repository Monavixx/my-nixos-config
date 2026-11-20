{
  den.aspects.rebuild.homeManager =
    { pkgs, host, ... }:
    let
      rebuild = pkgs.writeShellScriptBin "rebuild" ''
        cd ~/nixos && git add .
        sudo nixos-rebuild switch --flake ~/nixos#${host.name}
      '';
    in
    {
      home.packages = [ rebuild ];
    };
}
