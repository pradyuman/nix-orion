# Catalog :: { settings :: { String = Setting; }; }
{ lib }:

let
  settings = import ./settings.nix;
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
