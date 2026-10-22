{ pkgs, inputs, ... }:
let
  flakeFile = pkgs.replaceVars ./resource-flake.nix {
    nixpkgsRev = inputs.nixpkgs.rev;
  };

  new-dotnet = pkgs.writeShellScriptBin "new-dotnet" (
    builtins.readFile (
      pkgs.replaceVars ./new-dotnet.sh {
        inherit flakeFile;
      }
    )
  );
in
{
  home.packages = [
    new-dotnet
  ];
}
