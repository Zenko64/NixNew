{ ... }:
let
  shells = [ ];
in
{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      namespace,
      ...
    }:
    {
      options.${namespace}.desktop.compositors.niri = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enables the Niri Window Manager.";
        };
        shell = lib.mkOption {
          type = lib.types.nullOr (lib.types.enum shells);
          default = null;
          description = "Niri Shell To Use.";
        };
      };

      config = lib.mkIf config.${namespace}.desktop.compositors.niri.enable {
        programs.niri = {
          enable = true;
          useNautilus = true;
        };
      };
    };

  flake.modules.homeManager.desktop =
    {
      namespace,
      lib,
      osConfig,
      ...
    }:
    {
      options.${namespace}.desktop.compositors.niri = {
        shell = lib.mkOption {
          type = lib.types.nullOr (lib.types.enum shells);
          default = osConfig.${namespace}.desktop.compositors.niri.shell;
          description = "Niri Shell To Use.";
        };
      };

      config = lib.mkIf osConfig.${namespace}.desktop.compositors.niri.enable {
      };
    };

}
