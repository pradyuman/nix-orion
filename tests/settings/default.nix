{
  homeManagerLib,
  pkgs,
}:

let
  common = import ./common.nix { inherit homeManagerLib pkgs; };
in
{
  activation = import ./activation.nix {
    inherit (common) evalHome orionDomain;
    inherit (pkgs) lib;
  };
  options = import ./options.nix { inherit (pkgs) lib; };
  output = import ./output.nix {
    inherit (common) evalHome orionDomain;
  };
}
