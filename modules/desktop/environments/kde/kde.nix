{
  flake.modules.nixos.desktop =
    {
      namespace,
      lib,
      config,
      ...
    }:
    {
      options.${namespace}.desktop.environments.kde.enable = lib.mkEnableOption "Enable The KDE Plasma Desktop Environment.";
      config = lib.mkIf config.${namespace}.desktop.environments.kde.enable {
        services.desktopManager.plasma6.enable = true;
      };
    };
}
