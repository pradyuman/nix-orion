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
  imports = [ ./settings ];

  options.programs.orion = {
    enable = lib.mkEnableOption "Orion browser";
    package = lib.mkPackageOption pkgs "orion-browser" { };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.isDarwin;
        message = "programs.orion currently only supports Darwin.";
      }
    ];

    home.packages = [ cfg.package ];
  };
}
