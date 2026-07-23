{ lib }:

{
  smoke = import ./smoke.nix { inherit lib; };
}
