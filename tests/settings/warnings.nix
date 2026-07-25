{ lib }:

let
  sources = builtins.fromJSON (builtins.readFile ../../sources.json);
  orionVersion = sources.darwin.aarch64.version;

  warnings =
    {
      omittedSettings ? "reset",
      package ? {
        version = orionVersion;
      },
    }:
    import ../../modules/home-manager/settings/warnings.nix {
      cfg = {
        inherit omittedSettings package;
      };
      inherit lib;
    };
in
{
  # Reset mode should not warn when the package and catalog versions match.
  testMatchingVersion = {
    expr = warnings { };
    expected = [ ];
  };

  # Reset mode should warn when the package and catalog versions differ.
  testMismatchedVersion = {
    expr =
      let
        warning = builtins.head (warnings {
          package.version = "different";
        });
      in
      lib.all (fragment: lib.hasInfix fragment warning) [
        "programs.orion.omittedSettings = \"reset\""
        orionVersion
        "different"
      ];

    expected = true;
  };

  # Preserve mode does not use catalog defaults, so a version mismatch should not warn.
  testPreserveMode = {
    expr = warnings {
      omittedSettings = "preserve";
      package.version = "different";
    };
    expected = [ ];
  };
}
