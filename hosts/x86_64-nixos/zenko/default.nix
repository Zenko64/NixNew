{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./gpu.nix
    ./networks.nix
  ];

  programs.nix-ld.enable = true;

  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "rd.udev.log_level=3"
  ];

  boot.plymouth = {
    enable = true;
    theme = "bootTheme";
    themePackages = [ pkgs.main.bootTheme ];
  };

  boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.windows."00-windows" = {
    # efiDeviceHandle obtained via EDK2 UEFI Shell.
    title = "Windows";
    efiDeviceHandle = "FS0";
    sortKey = "00";
  };

  #main = {
  #  desktops.hyprland = {
  #    enable = true;
  #    settings = {
  #      input = {
  #        kb_layout = "pt";
  #      };
  #      device = [
  #        {
  #          name = "foca0001:00-2808:0106-touchpad";
  #          natural_scroll = true;
  #        }
  #      ];
  #    };
  #  };
#
  #  greeter = "greetd";
  #  desktop.theme = "catppuccin-mocha";
  #  users.simi = {
  #    fullName = "Zenko";
  #    email = "simi.git@outlook.com";
  #    shell = "fish";
  #  };
  #};

  programs.steam.enable = true;
  services.flatpak.enable = true;

  services.asusd.enable = true;

  services.ollama = {
    enable = false;
    package = pkgs.ollama-cuda;
  };

  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "pt-latin1";
  

  zramSwap.enable = true;

  # Never change after initial install.
  system.stateVersion = "25.11";
}
