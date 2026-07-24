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
      settingsCatalog = import ./modules/home-manager/settings/catalog { lib = nixpkgs.lib; };
      settingsCatalogJSON = pkgs.writeText "orion-settings-catalog.json" (
        builtins.toJSON settingsCatalog.settings
      );
      orionConfigGeneratorBinary =
        pkgs.runCommandCC "orion-config-generator"
          {
            nativeBuildInputs = [ pkgs.swift ];
          }
          ''
            mkdir -p "$out/bin"
            swiftc -framework AppKit \
              ${./scripts/generate-config.swift} \
              -o "$out/bin/orion-generate-config-raw"
          '';
      orionConfigGenerator = pkgs.writeShellApplication {
        name = "orion-generate-config";
        text = ''
          exec ${orionConfigGeneratorBinary}/bin/orion-generate-config-raw \
            --catalog ${settingsCatalogJSON} "$@"
        '';
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
        orion-config-generator = orionConfigGenerator;
        default = pkgs.orion-browser;
      };

      apps.${system}.generate-config = {
        type = "app";
        program = "${orionConfigGenerator}/bin/orion-generate-config";
      };

      checks.${system} = {
        settings =
          pkgs.runCommand "settings-tests"
            {
              nativeBuildInputs = [ pkgs.nix-unit ];
            }
            ''
              nix-unit \
                --gc-roots-dir "$TMPDIR" \
                --arg lib 'import ${nixpkgs}/lib' \
                ${./.}/tests/settings
              touch "$out"
            '';

        generate-config =
          pkgs.runCommand "generate-config-tests"
            {
              nativeBuildInputs = [
                orionConfigGenerator
                pkgs.diffutils
                pkgs.nix
              ];
            }
            ''
              orion-generate-config \
                --input ${./tests/generate-config/preferences.plist} \
                --output generated.nix
              diff -u ${./tests/generate-config/expected.nix} generated.nix
              nix-instantiate --parse generated.nix >/dev/null

              if orion-generate-config \
                --input ${./tests/generate-config/preferences.plist} \
                --output generated.nix 2>/dev/null; then
                echo "generator replaced an existing file without --force" >&2
                exit 1
              fi

              orion-generate-config \
                --input ${./tests/generate-config/preferences.plist} \
                --include-defaults \
                --force \
                --output generated.nix
              grep -F '"DefaultFontSize" = 16;' generated.nix >/dev/null

              if orion-generate-config \
                --domain com.example.missing-orion-domain 2>/dev/null; then
                echo "generator accepted a missing preference domain" >&2
                exit 1
              fi
              touch "$out"
            '';
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
