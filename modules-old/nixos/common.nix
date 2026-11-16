{
  pkgs,
  inputs,
  hostname,
  username,
  ...
}:

{
  imports = [
    ./quickshell.nix
    ./nix.nix
    ./virt-manager.nix
    ./rqbit.nix
    ./docker.nix
    ./thunar.nix
    ./firewall.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "usbcore.autosuspend=-1"
    ];
  };

  security = {
    polkit.enable = true;
    pam.loginLimits = [
      {
        domain = "@audio";
        item = "memlock";
        type = "-";
        value = "unlimited";
      }
      {
        domain = "@audio";
        item = "rtprio";
        type = "-";
        value = "95";
      }
      {
        domain = "@audio";
        item = "nice";
        type = "-";
        value = "-19";
      }
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.logind.settings.Login.HandlePowerKey = "ignore";

  environment = {
    systemPackages = [
      inputs.catppuccin.packages.${pkgs.system}.whiskers
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      corefonts
      nerd-fonts.fantasque-sans-mono
      font-awesome_4
    ];
  };
  programs = {
    bash = {
      enable = true;
    };
    hyprland = {
      withUWSM = true;
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    kdeconnect.enable = true;
    amnezia-vpn.enable = true;
  };

  system.stateVersion = "26.05";
}
