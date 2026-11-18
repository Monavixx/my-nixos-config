{ den, inputs, ... }:
{
  den.aspects.laptop = {
    includes = [ den.aspects.fprintd ];

    nixos =
      { pkgs, ... }:
      let
        libfprint = pkgs.callPackage ./_libfprint.nix {
          src = inputs.libfprint-ft9362-src;
        };
      in
      {
        # fprintd must use our modified libfprint
        services.fprintd.package = pkgs.fprintd.override { inherit libfprint; };
      };
  };
}
