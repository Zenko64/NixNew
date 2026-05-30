# TODO: Later down check if this should be a host-level setting, and on DE we enable required packages depending on bluetooth state or abstract
{ ... }:
{
  flake.modules.nixos.bluetooth = {...}: {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
