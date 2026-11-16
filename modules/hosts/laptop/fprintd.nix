{ inputs, ... }:
{
  flake.modules.nixos.host-laptop =
    { pkgs, ... }:
    {
      imports = [
        inputs.self.modules.nixos.fprintd
      ];
      my.fprintd.libfprint.package = pkgs.callPackage ./_libfprint.nix {
        src = inputs.libfprint-ft9362-src;
      };
    };
}
