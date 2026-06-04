# Boot & Kernel
{
  flake.modules.nixos.core =
    { lib, pkgs, ... }:
    {
      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.systemd-boot.editor = false; # Security Measure
      boot.loader.systemd-boot.enable = true;
    };
}
