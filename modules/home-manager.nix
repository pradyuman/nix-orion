{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.orion;
in
{
  options.programs.orion = {
    enable = lib.mkEnableOption "Orion browser";

    package = lib.mkPackageOption pkgs "orion-browser" { };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = lib.literalExpression ''
        {
          ShowTitlesInTabs = true;
          TabStyle = "treeStyle";
          CustomAppIcon = "appicon3";
          NSUserKeyEquivalents = {
            "Show Sidebar" = "@s";
            "Hide Sidebar" = "@s";

            # Save Page holds cmd-s by default.
            # It must move for the sidebar binding to work.
            "Save Page…" = "@^s";
          };
        }
      '';
      description = "Raw Orion preferences written to the com.kagi.kagimacOS defaults domain on Darwin.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.isDarwin;
        message = "programs.orion currently only supports Darwin.";
      }
    ];

    home.packages = [ cfg.package ];

    targets.darwin.defaults."com.kagi.kagimacOS" = lib.mkIf (cfg.settings != { }) cfg.settings;
  };
}
