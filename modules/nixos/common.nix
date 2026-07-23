{ config, pkgs, inputs, hostname, ... }:

let 
  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    cd ~/nixos && git add .
    sudo nixos-rebuild switch --flake ~/nixos#${hostname}
  '';
  hyprland-pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./docker.nix
    ./thunar.nix
  ];

  hardware.graphics = {
    package = hyprland-pkgs-unstable.mesa;
  };

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
  services.pipewire.pulse.enable = true;
  services.pipewire.enable = true;

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
    options = "grp:alt_shift_toggle";
  };

  users.users."monavixx" = {
    isNormalUser = true;
    description = "monavixx";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  environment.systemPackages = with pkgs; [
    rebuild
  ];
  
  fonts.packages = with pkgs; [
    nerd-fonts.fantasque-sans-mono
    font-awesome_4
  ];

  programs = {
    bash = {
      enable = true;
      shellAliases = {
        rm = "rm -i";
      };
    };
    hyprland = {
      withUWSM  = true;
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    kdeconnect.enable = true;
    amnezia-vpn.enable = true;
  };

  networking.firewall = {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };

  system.stateVersion = "26.05";
}
