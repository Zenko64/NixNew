{ ... }:
{
  nixpkgs.config.cudaSupport = true; # Enable CUDA Accelerated packages
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
  ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Load Nvidia Early
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  # Disable the dummy plug
  boot.kernelParams = [ "video=HDMI-A-3:d" ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;
  };
}
