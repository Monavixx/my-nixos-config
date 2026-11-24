{ inputs, ... }:
{
  den.aspects.kernel.nixos = { pkgs, ... }: {
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-x86_64-v3;
    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    nixpkgs.overlays = [
      inputs.nix-cachyos-kernel.overlays.pinned
    ];
    nix.settings = {
      extra-substituters = [ "https://cache.lantian.pub/lantian" ];
      extra-trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];
    };
  };
}
