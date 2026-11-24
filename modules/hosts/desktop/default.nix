{ den, ... }:
{
  den.hosts.x86_64-linux.desktop = {
    users.monavixx = import ../../users/monavixx/_user.nix;
  };

  den.aspects.desktop = {
    includes = [
      den.aspects.lanzaboote
      den.aspects.workstation
    ];
    nixos = { config, ... }: {
      imports = [ ./_hardware-configuration.nix ];

      fileSystems."/".options = [ "noatime" ];
      fileSystems."/home".options = [ "noatime" ];
      fileSystems."/hdd".options = [ "noatime" ];

      services.xserver.videoDrivers = [ "nvidia" ];
      boot.initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
      boot.blacklistedKernelModules = [
        "nouveau"
      ];
      hardware = {
        nvidia = {
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
          modesetting.enable = true;

          # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
          # Enable this if you have graphical corruption issues or application crashes after waking
          # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
          # of just the bare essentials.
          powerManagement.enable = false;

          powerManagement.finegrained = false;
          open = false;

          # Enable the Nvidia settings menu,
          # accessible via `nvidia-settings`.
          nvidiaSettings = true;
        };
        graphics = {
          enable = true;
          enable32Bit = true;
        };
      };
      powerManagement.cpuFreqGovernor = "performance";
    };

    provides.to-users.homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ guitarix ];
      xdg.configFile."hypr/host.lua".source = ./hyprland.lua;
    };
  };
}
