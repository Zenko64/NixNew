{
  flake.modules.nixos.server =
    { ... }:
    {
      security = {
        # Enable process confinement
        apparmor = {
          enable = true;
          killUnconfinedConfinables = true;
        };

        # Log reads and writes to sensitive directories
        auditd.enable = true;
        audit = {
          enable = true;
          rules = [
            "-w /run/current-system -p wa -k nixos-config"
          ];
        };
      };
      services = {
        fail2ban = {
          enable = true;

          maxretry = 6;
          bantime = "30m";

          # TODO: Add a abstracted options to this ignoreIPs
          ignoreIP = [
            "127.0.0.1/8"
            "::1/128"
          ];
        };
      };
    };
}
