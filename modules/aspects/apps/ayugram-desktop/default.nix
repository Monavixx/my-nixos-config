{ inputs, ... }:
{
  den.aspects.ayugram-desktop.homeManager = { pkgs, lib, ... }: {
    home.packages = [ inputs.ayugram-desktop.packages.${pkgs.stdenv.hostPlatform.system}.default ];

    home.activation.ayugramSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run install -Dm644 ${./ayu_settings.json} "$HOME/.local/share/AyuGramDesktop/tdata/ayu_settings.json"
      run install -Dm644 ${./shortcuts-custom.json} "$HOME/.local/share/AyuGramDesktop/tdata/shortcuts-custom.json"
    '';
  };
}
