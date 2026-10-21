{ pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;

    qemu.swtpm.enable = true;
    # qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };

  programs.virt-manager.enable = true;

  users.users."monavixx".extraGroups = [
    "libvirtd"
  ];

  environment.systemPackages = with pkgs; [
    dnsmasq
  ];
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  systemd.services.libvirt-default-network = {
    description = "Start libvirt default network";
    after = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
      ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
      User = "root";
    };
  };

}
