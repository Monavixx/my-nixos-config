{ self, ... }:
{
  flake.modules.nixos.quickshell = {
    security.pam.services = {
      quickshell-lock = {
        unixAuth = true;
        fprintAuth = false;
      };
    };
  };

  flake.modules.homeManager.quickshell = {
    imports = [ self.modules.homeManager.wallpapers ];
  };
}
