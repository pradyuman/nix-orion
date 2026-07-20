# τ SettingValue = null | Bool | Int | Float | String | [ SettingValue ] | { String = SettingValue; }
# τ ScalarSetting = {
#     type :: "bool" | "data" | "float" | "int" | "list" | "string";
#     default :: SettingValue;
#   }
#
# τ EnumSetting = {
#     type :: "enum";
#     default :: SettingValue;
#     values :: [ SettingValue ];
#   }
#
# τ ListField = {
#     static :: [ SettingValue ];
#     patterns? :: [ String ];
#   }
#
# τ AttrsSetting = {
#     type :: "attrs";
#     default :: SettingValue;
#
#     # When present, constraints apply to the listed fields
#     # while unlisted fields pass through unchanged.
#     fields? :: { String = ListField; };
#   }
#
# τ Setting =
#     ScalarSetting
#   | EnumSetting
#   | AttrsSetting
#
# τ Catalog = { settings :: { String = Setting; }; }

{ lib }:

let
  typePredicates = {
    attrs = _: builtins.isAttrs;
    bool = _: builtins.isBool;
    # Nix and Home Manager's plist generator cannot represent plist data.
    data = _: _: false;
    enum = setting: value: builtins.elem value setting.values;
    float = _: builtins.isFloat;
    int = _: builtins.isInt;
    list = _: builtins.isList;
    string = _: builtins.isString;
  };

  settingTypes = builtins.attrNames typePredicates;

  isValidValue = setting: typePredicates.${setting.type} setting;

  validate =
    settings:
    let
      settingsWithoutDefaults = lib.attrNames (
        lib.filterAttrs (_: setting: !(setting ? default)) settings
      );
      settingsWithoutTypes = lib.attrNames (lib.filterAttrs (_: setting: !(setting ? type)) settings);
      settingsWithUnknownTypes = lib.attrNames (
        lib.filterAttrs (_: setting: !(builtins.elem setting.type settingTypes)) settings
      );
      settingsWithInvalidConstraints = lib.attrNames (
        lib.filterAttrs (
          _: setting:
          !(
            if setting.type == "enum" then
              setting ? values && builtins.isList setting.values && setting.values != [ ] && !(setting ? fields)
            else if setting.type == "attrs" then
              !(setting ? values) && (!(setting ? fields) || builtins.isAttrs setting.fields)
            else
              !(setting ? values) && !(setting ? fields)
          )
        ) settings
      );
      settingsWithInvalidDefaults = lib.attrNames (
        lib.filterAttrs (
          _: setting: setting.default != null && !(isValidValue setting setting.default)
        ) settings
      );
    in
    assert lib.assertMsg (settingsWithoutDefaults == [ ]) ''
      Orion settings catalog entries must define a default:
      ${lib.concatStringsSep ", " settingsWithoutDefaults}
    '';
    assert lib.assertMsg (settingsWithoutTypes == [ ]) ''
      Orion settings catalog entries must define a type:
      ${lib.concatStringsSep ", " settingsWithoutTypes}
    '';
    assert lib.assertMsg (settingsWithUnknownTypes == [ ]) ''
      Orion settings catalog entries use unknown types:
      ${lib.concatStringsSep ", " settingsWithUnknownTypes}
    '';
    assert lib.assertMsg (settingsWithInvalidConstraints == [ ]) ''
      Orion settings catalog entries have constraints incompatible with their types:
      ${lib.concatStringsSep ", " settingsWithInvalidConstraints}
    '';
    assert lib.assertMsg (settingsWithInvalidDefaults == [ ]) ''
      Orion settings catalog defaults do not match their declared types:
      ${lib.concatStringsSep ", " settingsWithInvalidDefaults}
    '';
    settings;
in
{
  inherit validate;
}
