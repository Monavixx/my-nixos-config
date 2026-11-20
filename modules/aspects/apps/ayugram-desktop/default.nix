{ inputs, ... }:
{
  den.aspects.ayugram-desktop = {
    provides.to-hosts.nixos = {
      nix.settings = {
        extra-substituters = [
          "https://ayugram-desktop.cachix.org"
        ];
        extra-trusted-public-keys = [
          "ayugram-desktop.cachix.org-1:AZ5EqHrJsAKL5YkZYLPEsb1FdD9QlypUwQ0REcJftgA="
        ];
      };
    };
    homeManager = { pkgs, lib, ... }: {
      home.packages = [ inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default ];

      home.activation.ayugramSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run install -Dm644 ${./ayu_settings.json} "$HOME/.local/share/AyuGramDesktop/tdata/ayu_settings.json"
        run install -Dm644 ${./shortcuts-custom.json} "$HOME/.local/share/AyuGramDesktop/tdata/shortcuts-custom.json"
      '';
    };
  };
}
