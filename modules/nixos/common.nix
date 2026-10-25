{
  config,
  pkgs,
  inputs,
  hostname,
  username,
  ...
}:

{
  imports = [
    ./virt-manager.nix
    ./rqbit.nix
    ./docker.nix
    ./thunar.nix
    ./firewall.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.systemd.enable = true;
  security.polkit.enable = true;

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "daily" ];
  nix.gc = {
    automatic = true;
    dates = "*-*-* 00:00:00/3";
    options = "--delete-older-than 14d";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  networking.hostName = hostname; # must match flake.nix's nixosConfigurations.<name>
  networking.networkmanager.enable = true;

  services.logind.settings.Login.HandlePowerKey = "ignore";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "";
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
    shell = pkgs.zsh;
  };
  environment.shells = [ pkgs.zsh ];
  system.userActivationScripts.zshrc = "touch ${
    config.home-manager.users.${username}.home.homeDirectory
  }/.zshrc";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fantasque-sans-mono
    font-awesome_4
  ];
  programs = {
    zsh = {
      enable = true;
    };
    bash = {
      enable = true;
      shellAliases = {
        rm = "rm -i";
      };
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
