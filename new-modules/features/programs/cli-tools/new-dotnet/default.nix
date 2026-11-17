{ inputs, ... }:
{
  flake.modules.homeManager.new-dotnet =
    { pkgs, ... }:
    let
      flakeFile = pkgs.replaceVars ./flake.nix.txt {
        nixpkgsRev = inputs.nixpkgs.rev;
      };

      new-dotnet = pkgs.writeShellScriptBin "new-dotnet" (
        builtins.readFile (
          pkgs.replaceVars ./script.sh {
            inherit flakeFile;
          }
        )
      );
    in
    {
      home.packages = [
        new-dotnet
      ];
    };
}
