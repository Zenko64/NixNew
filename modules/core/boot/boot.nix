# Module responsible for setting a bootloader and a kernel.
{ ... }:
{
  flake.modules.nixos.boot = {pkgs, ...}:
  {
    boot.kernelPackages = pkgs.linuxPackages_latest; # TODO: Allow user to choose kernel
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.editor = false; # Security Measure
    boot.loader.efi.canTouchEfiVariables = true;
  };
}
