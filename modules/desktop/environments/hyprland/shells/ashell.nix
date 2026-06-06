{
  flake.modules.homeManager.desktop =
    {
      lib,
      config,
      namespace,
      ...
    }:
    {
      config = lib.mkIf config.${namespace}.desktop.environments.hyprland.enable (
        lib.mkIf (config.${namespace}.desktop.environments.hyprland.shell == "ashell") {
          programs.ashell.enable = true;
        }
      );
    };
}
