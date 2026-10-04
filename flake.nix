{
  description = "Nix flake for the Orion browser";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      treefmt-nix,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        treefmt-nix.flakeModule
        ./tests
      ];

      systems = [ "aarch64-darwin" ];

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfreePredicate = package: inputs.nixpkgs.lib.getName package == "orion-browser";
            overlays = [ inputs.self.overlays.default ];
          };

          packages = {
            inherit (pkgs) orion-browser;
            default = pkgs.orion-browser;
          };

          devShells.survey = pkgs.mkShell {
            packages = with pkgs; [
              ghidra
              rizin
            ];
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              actionlint.enable = true;
              mdformat = {
                enable = true;
                plugins = ps: [
                  ps.mdformat-frontmatter
                  ps.mdformat-gfm
                ];
                settings.number = true;
              };
              nixfmt.enable = true;
              shellcheck.enable = true;
            };
          };
        };

      flake = {
        overlays.default = import ./overlay.nix;
        homeModules.default = ./modules/home-manager;
      };
    };
}
