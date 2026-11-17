{ config, lib, ... }:
let
  withLibvirtUsers = lib.filterAttrs (_: h: h.libvirt.users != [ ]) config.hosts;
in
{
  # extends the `hosts` schema (default = { } stays in the core declaration)
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.libvirt.users = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Users on this host allowed to manage VMs.";
        };
      }
    );
  };

  config = lib.mkMerge [
    {
      flake.modules.nixos.libvirt = { lib, pkgs, ... }: {
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
    }
    {
      # per-host data -> group memberships
      flake.modules.nixos = lib.mapAttrs' (
        name: host:
        lib.nameValuePair "host-${name}" (
          { config, ... }: {
            users.users = lib.genAttrs host.libvirt.users (_: {
              extraGroups = [ "libvirtd" ];
            });

            assertions = [
              {
                assertion = lib.all (u: lib.elem u host.users) host.libvirt.users;
                message = "hosts.${name}.libvirt.users names a user without an account on this host.";
              }
              {
                assertion = config.virtualisation.libvirtd.enable;
                message = "hosts.${name}.libvirt.users is set, but the host doesn't import the libvirt feature.";
              }
            ];
          }
        )
      ) withLibvirtUsers;
    }
  ];
}
