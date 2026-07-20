{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.orion;

  orionDomain = "com.kagi.kagimacOS";

  catalog = import ./catalog { inherit lib; };
  catalogDefaults = lib.mapAttrs (_: setting: setting.default) catalog.settings;

  # A null catalog default means the setting should be absent by default.
  defaultKeysToUnset = lib.attrNames (lib.filterAttrs (_: value: value == null) catalogDefaults);

  # Non-null catalog defaults will be merged in with user settings
  defaultsToMerge = lib.filterAttrs (_: value: value != null) catalogDefaults;

  shouldResetOmittedSettings = cfg.omittedSettings == "reset";

  # Merge user settings and catalog defaults.
  mergedSettings =
    if shouldResetOmittedSettings then
      lib.recursiveUpdate defaultsToMerge cfg.settings
    else
      cfg.settings;

  nsColorSettings = lib.filterAttrs (
    name: _: lib.attrByPath [ name "encoding" ] null catalog.settings == "nsColor"
  ) mergedSettings;

  darwinDefaultsSettings = builtins.removeAttrs mergedSettings (lib.attrNames nsColorSettings);

  writeNSColor =
    pkgs.runCommandCC "nix-orion-write-nscolor" { nativeBuildInputs = [ pkgs.swift ]; }
      ''
        swiftc ${./write-nscolor.swift} -o $out
      '';
in
{
  imports = [ ./options.nix ];

  config = lib.mkIf cfg.enable {
    warnings = import ./warnings.nix { inherit cfg lib; };

    home.activation.unsetOrionDefaults =
      lib.mkIf (shouldResetOmittedSettings && defaultKeysToUnset != [ ])
        (
          lib.hm.dag.entryBetween [ "setDarwinDefaults" ] [ "writeBoundary" ] ''
            verboseEcho "Removing Orion settings that are unset by default"

            for name in ${lib.escapeShellArgs defaultKeysToUnset}; do
              if /usr/bin/defaults read ${lib.escapeShellArg orionDomain} "$name" >/dev/null 2>&1; then
                run /usr/bin/defaults delete ${lib.escapeShellArg orionDomain} "$name"
              fi
            done
          ''
        );

    home.activation.writeOrionNSColors = lib.mkIf (nsColorSettings != { }) (
      lib.hm.dag.entryAfter [ "setDarwinDefaults" ] ''
        verboseEcho "Writing encoded Orion colors"

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            name: value:
            "run ${writeNSColor} ${
              lib.escapeShellArgs [
                orionDomain
                name
                value
              ]
            }"
          ) nsColorSettings
        )}
      ''
    );

    targets.darwin.defaults.${orionDomain} = lib.mkIf (
      darwinDefaultsSettings != { }
    ) darwinDefaultsSettings;
  };
}
