{
  cfg,
  lib,
}:

let
  catalog = import ./catalog { inherit lib; };
  sources = builtins.fromJSON (builtins.readFile ../../../sources.json);
  orionVersion = sources.darwin.aarch64.version;

  # User-provided values outside the list of surveyed values.
  settingsWithUnknownValues = lib.filterAttrs (
    name: value:
    let
      knownValues = catalog.settings.${name}.values or null;
    in
    knownValues != null && !(builtins.elem value knownValues)
  ) cfg.settings;
in
lib.optional (cfg.resetUnconfiguredSettings && (cfg.package.version or null) != orionVersion) ''
  programs.orion.resetUnconfiguredSettings targets Orion version
  ${orionVersion}, but the configured package version is
  ${cfg.package.version or "unknown"}. Orion settings may differ between these versions.
''
++ lib.mapAttrsToList (name: value: ''
  programs.orion.settings.${name} is set to ${builtins.toJSON value}, which is not one of the surveyed values:
  ${lib.concatMapStringsSep ", " builtins.toJSON catalog.settings.${name}.values}.
'') settingsWithUnknownValues
