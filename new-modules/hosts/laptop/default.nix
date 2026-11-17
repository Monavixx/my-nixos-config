{ inputs, self, ... }:
let
  host = "laptop";
in
{
  flake.modules.nixos."host-${host}" =
    { pkgs, ... }:
    let
      hyprland-pkgs-unstable =
        inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [
        self.modules.nixos.base
        self.modules.nixos.workstation

        ./_hardware-configuration.nix
      ];
      security.pam.services = {
        quickshell-fprint = {
          fprintAuth = true;
          unixAuth = false; # fingerprint only; the password has its own service
        };
      };

      fileSystems."/".options = [ "noatime" ];

      boot.initrd.luks.devices."luks-3815679e-a773-4c82-be2c-ca08327105af".device =
        "/dev/disk/by-uuid/3815679e-a773-4c82-be2c-ca08327105af";

      hardware.bluetooth.enable = true;
      services.upower = {
        enable = true;
        percentageLow = 20;
        percentageCritical = 10;
      };

      services.auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        brightnessctl
      ];
      hardware.graphics = {
        package = hyprland-pkgs-unstable.mesa;
      };
    };

  hosts.${host} = {
    users = [
      "monavixx"
    ];
    stateVersion = "26.05";
  };
}
