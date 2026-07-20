{ lib, ... }:

let
  catalog = import ./catalog { inherit lib; };

  # Used to distinguish omitted settings from configured values so "preserve" mode
  # can leave them unchanged and "reset" mode can apply their catalog defaults.
  omitted = {
    _nixOrionOmitted = true;
  };

  settingOptionTypes = {
    attrs = lib.types.attrs;
    bool = lib.types.bool;
    data = (lib.types.addCheck lib.types.anything (_: false)) // {
      description = "raw plist data, which Home Manager's plist generator cannot write";
    };
    float = lib.types.float;
    int = lib.types.int;
    list = lib.types.listOf lib.types.anything;
    string = lib.types.str;
  };

  settingOrOmittedOptionType =
    type:
    (lib.types.either (lib.types.enum [ omitted ]) type)
    // {
      inherit (type) description;
    };

  # Test whether an element is accepted by a list field.
  # τ isValidListFieldElement :: ListField -> SettingValue -> Bool
  isValidListFieldElement =
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

  listFieldElementOptionType =
    listField:
    (lib.types.addCheck lib.types.anything (isValidListFieldElement listField))
    // {
      description = "allowed value for an Orion list field";
    };

  listFieldOptionType = listField: lib.types.listOf (listFieldElementOptionType listField);

  attrsSettingOptionType =
    fields:
    lib.types.submodule {
      freeformType = lib.types.attrsOf lib.types.anything;
      options = lib.mapAttrs (
        _: listField:
        lib.mkOption {
          type = settingOrOmittedOptionType (listFieldOptionType listField);
          default = omitted;
        }
      ) fields;
    };

  settingOptionType =
    setting:
    if setting.type == "enum" then
      lib.types.enum setting.values
    else if setting.type == "attrs" && setting ? fields then
      attrsSettingOptionType setting.fields
    else
      settingOptionTypes.${setting.type};

  settingOptions = lib.mapAttrs (
    _: setting:
    lib.mkOption {
      type = settingOrOmittedOptionType (settingOptionType setting);
      default = omitted;
      apply =
        value:
        if value != omitted && setting.type == "attrs" && setting ? fields then
          lib.filterAttrs (_: nestedValue: nestedValue != omitted) value
        else
          value;
    }
  ) catalog.settings;
in
{
  options.programs.orion = {
    omittedSettings = lib.mkOption {
      type = lib.types.enum [
        "reset"
        "preserve"
      ];
      default = "reset";
      description = ''
        How to handle settings omitted from {option}`programs.orion.settings`:

        - `"reset"` applies nix-orion's defaults
        - `"preserve"` leaves existing values unchanged
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.anything;
        options = settingOptions;
      };
      default = { };
      apply = lib.filterAttrs (_: value: value != omitted);
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
      description = "Orion settings written to the `com.kagi.kagimacOS` defaults domain on Darwin.";
    };
  };
}
