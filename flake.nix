{
  description = "My Custom NixOS Configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";
    easy-hosts.url = "github:tgirlcloud/easy-hosts";

    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      flake-parts,
      import-tree,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      debug = true;
      systems = [ "x86_64-linux" ];
      imports = [
        # (import-tree ./lib)
        (import-tree ./modules)
        inputs.easy-hosts.flakeModule
      ];

      easy-hosts = {
        path = ./hosts;
        autoConstruct = true;
      };

      # Development Shell For This Configuration
      # Start with "nix develop"
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = [
              pkgs.nixd
              pkgs.nixfmt

              # Testing Machine In Lab
              pkgs.nixos-anywhere
              pkgs.pixiecore
            ];

            shellHook = ''
              alias netdev='sudo pixiecore boot ${inputs.self.nixosConfigurations.installer.config.system.build.kernel}/bzImage ${inputs.self.nixosConfigurations.installer.config.system.build.netbootRamdisk}/initrd --cmdline "init=${inputs.self.nixosConfigurations.installer.config.system.build.toplevel}/init"'

              echo "-----Zenko64's NixOS Development Shell-----"
              echo "Aliases:"
              echo " - netdev: Start Installer PXEServer with OpenSSH Enabled."
              echo "-------------------------------------------"
            '';
          };
        };
    };
}
