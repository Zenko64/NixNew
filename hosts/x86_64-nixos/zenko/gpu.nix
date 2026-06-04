{ ... }:
{
  nixpkgs.config.cudaSupport = true;
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0@0:2:0"; # 0000:00:02.0
        nvidiaBusId = "PCI:1@0:0:0"; # 0000:01:00.0
      };
    };
  };

  boot = {
    blacklistedKernelModules = [ "nouveau" ];
    initrd.kernelModules = [ "xe" ];
  };

  services.xserver.videoDrivers = [
    "xe"
    "nvidia"
  ];
}
