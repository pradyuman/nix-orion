{
  cfg,
  lib,
}:

let
  catalog = import ./catalog { inherit lib; };
  sources = builtins.fromJSON (builtins.readFile ../../../sources.json);
  orionVersion = sources.darwin.aarch64.version;

  # Test whether a list element matches a static value or dynamic pattern.
  # τ isValidListElement :: ListSchema -> SettingValue -> Bool
  isValidListElement =
    {
      static,
      patterns ? [ ],
    }:
    value:
    let
      matchesStatic = builtins.elem value static;
      matchesPattern =
        builtins.isString value && lib.any (pattern: builtins.match pattern value != null) patterns;
    in
    matchesStatic || matchesPattern;

  # Validate a configured list field against its schema in the catalog.
  # τ warningsForListField :: {
  #     settingKey :: String;
  #     listFieldKey :: String;
  #   } -> [ String ]
  warningsForListField =
    {
      settingKey,
      listFieldKey,
    }:
    let
      listSchema = catalog.settings.${settingKey}.values.${listFieldKey};
      configuredPath = [
        settingKey
        listFieldKey
      ];
      hasConfiguredValue = lib.hasAttrByPath configuredPath cfg.settings;
      configuredValue = lib.attrByPath configuredPath null cfg.settings;
      settingPath = ''programs.orion.settings.${settingKey}."${listFieldKey}"'';
    in
    if !hasConfiguredValue then
      [ ]
    else if !builtins.isList configuredValue then
      [
        ''
          ${settingPath} must be a list.
        ''
      ]
    else
      let
        invalidElements = lib.filter (value: !(isValidListElement listSchema value)) configuredValue;
      in
      lib.optional (invalidElements != [ ]) ''
        ${settingPath} contains values that have not been surveyed:
        ${lib.concatMapStringsSep ", " builtins.toJSON invalidElements}.
      '';

  # Validate each configured setting against any constraints in the catalog.
  settingsValueWarnings = lib.concatLists (
    lib.mapAttrsToList (
      settingKey: configuredValue:
      let
        valueConstraints = catalog.settings.${settingKey}.values or null;
      in
      # Surface a warning if the configured value does not match the list of values in the catalog.
      if builtins.isList valueConstraints then
        lib.optional (!(builtins.elem configuredValue valueConstraints)) ''
          programs.orion.settings.${settingKey} is set to ${builtins.toJSON configuredValue}, which is not one of the surveyed values:
          ${lib.concatMapStringsSep ", " builtins.toJSON valueConstraints}.
        ''
      # Surface a warning if the configured value does not match the nested schema in the catalog.
      else if builtins.isAttrs valueConstraints then
        lib.concatMap (listFieldKey: warningsForListField { inherit settingKey listFieldKey; }) (
          builtins.attrNames valueConstraints
        )
      # Otherwise, the catalog does not specify constraints on the setting's value.
      else
        [ ]
    ) cfg.settings
  );

in
lib.optional (cfg.resetUnconfiguredSettings && (cfg.package.version or null) != orionVersion) ''
  programs.orion.resetUnconfiguredSettings targets Orion version
  ${orionVersion}, but the configured package version is
  ${cfg.package.version or "unknown"}. Orion settings may differ between these versions.
''
++ settingsValueWarnings
