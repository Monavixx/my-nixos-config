{
  flake.modules.homeManager.rebuild =
    {
      config,
      pkgs,
      ...
    }:
    let
      rebuild = pkgs.writeShellScriptBin "rebuild" ''
        cd ~/nixos && git add .
        sudo nixos-rebuild switch --flake ~/nixos#${config.my.hostname}
      '';
    in
    {
      home.packages = [ rebuild ];
    };
}
