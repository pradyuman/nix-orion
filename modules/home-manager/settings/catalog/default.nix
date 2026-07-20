{ lib }:

let
  schema = import ./schema.nix { inherit lib; };

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
in
{
  settings = schema.validate settings;
}
