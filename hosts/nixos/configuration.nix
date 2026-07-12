{ config, pkgs, ... }:

let 
  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    sudo nixos-rebuild switch --flake ./nixos
  '';
in
{
  imports = [
    ./docker.nix
    ../../home/thunar.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.luks.devices."luks-3815679e-a773-4c82-be2c-ca08327105af".device = "/dev/disk/by-uuid/3815679e-a773-4c82-be2c-ca08327105af";
  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.services.numlock-on = {
    description = "Enable NumLock before LUKS prompt";
    wantedBy = [ "initrd.target" ];
    before = [ "systemd-cryptsetup@luks-3815679e-a773-4c82-be2c-ca08327105af.service" ];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kbd}/bin/setleds -D +num";
      RemainAfterExit = true;
    };
  };
  #systemd.services.numlock-tty = {
  #  description = "Enable NumLock on all TTYs";
  #  wantedBy = [ "multi-user.target" ];
  #  serviceConfig = {
  #    Type = "oneshot";
  #    RemainAfterExit = true;
  #    ExecStart = ''
  #      ${pkgs.bash}/bin/bash -c '
  #        for tty in /dev/tty1 /dev/tty2 /dev/tty3 /dev/tty4 /dev/tty5 /dev/tty6; do
  #          ${pkgs.kbd}/bin/setleds -D +num < "$tty" > /dev/null 2>&1 || true
  #        done
  #      '
  #    '';
  #  };
  #};

  networking.hostName = "nixos"; # must match flake.nix's nixosConfigurations.<name>
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  environment.systemPackages = with pkgs; [
    kitty
    rebuild
  ];

  programs = {
    bash = {
      enable = true;
      shellAliases = {
        rm = "rm -i";
      };
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
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
