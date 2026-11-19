{
  den.aspects.kernel.nixos = { pkgs, ... }: {
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
