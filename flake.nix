{
  description = "Nix flake for the Orion browser";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      treefmt-nix,
      ...
    }:
    let
      system = "aarch64-darwin";
      overlay = import ./overlay.nix;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ overlay ];
      };
      treefmt = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs = {
          mdformat = {
            enable = true;
            plugins = ps: [
              ps.mdformat-frontmatter
              ps.mdformat-gfm
            ];
            settings.number = true;
          };
          nixfmt.enable = true;
        };
      };
    in
    {
      packages.${system} = {
        inherit (pkgs) orion-browser;
        default = pkgs.orion-browser;
      };

      devShells.${system}.survey = pkgs.mkShell {
        packages = with pkgs; [
          ghidra
          rizin
        ];
      };

      formatter.${system} = treefmt.config.build.wrapper;

      overlays.default = overlay;

      homeModules.default = ./modules/home-manager;
    };
}
