# τ SettingValue = null | Bool | Int | String | [ SettingValue ] | { String = SettingValue; }
# τ ListSchema = { static :: [ SettingValue ]; patterns? :: [ String ]; }
# τ Setting = {
#     default :: SettingValue;
#     values? :: [ SettingValue ] | { String = ListSchema; };
#   }
# τ Catalog = { settings :: { String = Setting; }; }
{ lib }:

let
  settings = lib.mergeAttrsList (
    map import [
      ./advanced.nix
      ./appearance.nix
      ./browsing.nix
      ./general.nix
      ./other.nix
      ./passwords.nix
      ./privacy.nix
      ./search.nix
      ./tabs.nix
      ./toolbar.nix
    ]
  );
  settingsWithoutDefaults = lib.attrNames (
    lib.filterAttrs (_: setting: !(setting ? default)) settings
  );
in
assert lib.assertMsg (settingsWithoutDefaults == [ ]) ''
  Orion settings catalog entries must define a default:
  ${lib.concatStringsSep ", " settingsWithoutDefaults}
'';
{
  inherit settings;
}
