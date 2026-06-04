# System Services Module
{
  flake.modules.nixos.core =
    { ... }:
    {
      system.autoUpgrade = {
        enable = true;
        dates = "24:00";
        allowReboot = false;
      };

      security.polkit.enable = true;
      security.rtkit.enable = true;

      services.dbus.enable = true;
    };
}
