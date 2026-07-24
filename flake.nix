{
  description = "Nix flake for the Orion browser";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    {
      nixpkgs,
      home-manager,
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

      checks.${system}.settings =
        pkgs.runCommand "settings-tests"
          {
            nativeBuildInputs = [ pkgs.nix-unit ];
          }
          ''
            nix-unit \
              --gc-roots-dir "$TMPDIR" \
              --arg homeManagerLib 'import ${home-manager}/lib {
                lib = import ${nixpkgs}/lib;
              }' \
              --arg pkgs 'import ${nixpkgs} {
                system = "${system}";
                config.allowUnfree = true;
                overlays = [ (import ${./.}/overlay.nix) ];
              }' \
              ${./.}/tests/settings
            touch "$out"
          '';

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
