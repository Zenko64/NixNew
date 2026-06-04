# Catppuccin Mocha Theme (Stylix)
{ inputs, ... }:
{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      namespace,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      config = lib.mkIf (config.${namespace}.desktop.theme == "catppuccin-mocha") {
        stylix = {
          enable = true;
          polarity = "dark";

          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

          opacity.desktop = 0.8;
          opacity.popups = 0.8;

          cursor = {
            package = pkgs.nordzy-cursor-theme;
            name = "Nordzy-catppuccin-mocha-sky";
            size = 24;
          };
          icons = {
            enable = true;
            package = pkgs.nordzy-icon-theme;
            dark = "Nordzy-cyan-dark";
            light = "Nordzy-cyan";
          };
        };
      };
    };

  flake.modules.homeManager.desktop =
    {
      config,
      lib,
      namespace,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf (config.${namespace}.desktop.theme == "catppuccin-mocha") {
        stylix = {
          enable = true;
          polarity = "dark";

          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

          opacity.desktop = 0.8;
          opacity.popups = 0.8;

          cursor = {
            package = pkgs.nordzy-cursor-theme;
            name = "Nordzy-catppuccin-mocha-sky";
            size = 24;
          };
          icons = {
            enable = true;
            package = pkgs.nordzy-icon-theme;
            dark = "Nordzy-cyan-dark";
            light = "Nordzy-cyan";
          };
        };
      };
    };
}
