{ modulesPath, ... }:
{
  imports = [ "${modulesPath}/installer/netboot/netboot.nix" ];

  services.openssh.enable = true;
  services.openssh.settings = {
    UseDns = true;
    PasswordAuthentication = true;
    PermitRootLogin = "yes";
    PermitEmptyPasswords = true;
  };

  users.users.root.initialPassword = "";
}