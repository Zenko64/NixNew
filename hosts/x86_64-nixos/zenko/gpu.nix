{ ... }:
{
  nixpkgs.config.cudaSupport = true; # Enable CUDA Accelerated packages
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [
    "xe"
    "nvidia"
  ];
  boot.initrd.kernelModules = [ "xe" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0@0:2:0"; # 0000:00:02.0
      nvidiaBusId = "PCI:1@0:0:0"; # 0000:01:00.0
    };
  };
}
