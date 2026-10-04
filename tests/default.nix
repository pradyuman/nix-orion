{ inputs, ... }:

{
  perSystem =
    {
      pkgs,
      system,
      ...
    }:
    {
      checks = {
        orion-browser = pkgs.orion-browser;

        settings =
          pkgs.runCommand "settings-tests"
            {
              nativeBuildInputs = [ pkgs.nix-unit ];
            }
            ''
              nix-unit \
                --arg homeManagerLib 'import ${inputs.home-manager}/lib {
                  lib = import ${inputs.nixpkgs}/lib;
                }' \
                --arg pkgs 'import ${inputs.nixpkgs} {
                  system = "${system}";
                  config.allowUnfreePredicate =
                    package: (import ${inputs.nixpkgs}/lib).getName package == "orion-browser";
                  overlays = [ (import ${../.}/overlay.nix) ];
                }' \
                ${../.}/tests/settings
              touch "$out"
            '';
      };
    };
}
