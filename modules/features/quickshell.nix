{
  flake.modules.nixos.quickshell = {
    security.pam.services = {
      quickshell-lock = {
        unixAuth = true;
        fprintAuth = false;
      };
    };
  };
}
