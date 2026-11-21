{
  den.aspects.libvirt = {
    nixos = { lib, pkgs, ... }: {
      virtualisation.libvirtd = {
        enable = true;
        qemu.swtpm.enable = true;
      };

      programs.virt-manager.enable = true;

      networking.firewall.trustedInterfaces = [ "virbr0" ];

      systemd.services.libvirt-default-network = {
        description = "Start libvirt default network";
        after = [ "libvirtd.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${lib.getExe' pkgs.libvirt "virsh"} net-start default";
          ExecStop = "${lib.getExe' pkgs.libvirt "virsh"} net-destroy default";
          User = "root";
        };
      };
    };
    user = {
      extraGroups = [ "libvirtd" ];
    };
  };
}
