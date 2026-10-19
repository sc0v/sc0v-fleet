{
  description = "NixOS configuration for the CMU SCC server fleet";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # External NixOS modules.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fleet-owned source repositories.
    cmutli-fleet-secrets = {
      url = "git+ssh://git@github.com/sc0v/sc0v-fleet-secrets.git";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, sops-nix, disko, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      hostSystem = "x86_64-linux";
      mkHost = hostModule: diskModule: nixpkgs.lib.nixosSystem {
        system = hostSystem;
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/base.nix
          diskModule
          disko.nixosModules.disko
          hostModule
          sops-nix.nixosModules.sops
        ];
      };
    in {
      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              age
              git
              sops
            ];
          };
        });

      nixosConfigurations."ops-01.springcarnival.org" = mkHost
        ./hosts/ops-01.springcarnival.org/configuration.nix
        ./hosts/ops-01.springcarnival.org/disko.nix;
    };
}
