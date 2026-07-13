{
  config,
  lib,
  ...
}:

let
  cfg = config.programs.orion;

  orionDomain = "com.kagi.kagimacOS";

  catalog = import ./catalog { inherit lib; };
  catalogDefaults = lib.mapAttrs (_: setting: setting.default) catalog.settings;

  # A null catalog default means the preference should be absent by default.
  defaultKeysToUnset = lib.attrNames (lib.filterAttrs (_: value: value == null) catalogDefaults);

  # Non-null catalog defaults will be merged in with user settings
  defaultsToMerge = lib.filterAttrs (_: value: value != null) catalogDefaults;

  # Merge user settings and catalog defaults.
  mergedSettings =
    if cfg.resetUnconfiguredSettings then
      lib.recursiveUpdate defaultsToMerge cfg.settings
    else
      cfg.settings;
in
{
  imports = [ ./options.nix ];

  config = lib.mkIf cfg.enable {
    warnings = import ./warnings.nix { inherit cfg lib; };

    home.activation.unsetOrionDefaults =
      lib.mkIf (cfg.resetUnconfiguredSettings && defaultKeysToUnset != [ ])
        (
          lib.hm.dag.entryBetween [ "setDarwinDefaults" ] [ "writeBoundary" ] ''
            verboseEcho "Removing Orion preferences that are unset by default"

            for name in ${lib.escapeShellArgs defaultKeysToUnset}; do
              if /usr/bin/defaults read ${lib.escapeShellArg orionDomain} "$name" >/dev/null 2>&1; then
                run /usr/bin/defaults delete ${lib.escapeShellArg orionDomain} "$name"
              fi
            done
          ''
        );

    targets.darwin.defaults.${orionDomain} = lib.mkIf (mergedSettings != { }) mergedSettings;
  };
}
