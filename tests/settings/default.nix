{
  homeManagerLib,
  pkgs,
}:

{
  options = import ./options.nix { inherit (pkgs) lib; };
  output = import ./output.nix { inherit homeManagerLib pkgs; };
}
