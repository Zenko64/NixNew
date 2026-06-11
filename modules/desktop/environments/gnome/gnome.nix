{
  flake.nixos.modules.desktop =
    {
      namespace,
      config,
      lib,
      ...
    }:
    {
      options.${namespace}.desktop.environments.gnome.enable =
        lib.mkEnableOption "Enable The GNOME Desktop Environment.";
      config = lib.mkIf config.${namespace}.desktop.environments.gnome.enable {
        services.desktopManager.gnome.enable = true;
      };
    };
}
