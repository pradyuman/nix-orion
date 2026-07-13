final: _prev:

let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  sourcesBySystem = {
    aarch64-darwin = sources.darwin.aarch64;
  };
  source =
    sourcesBySystem.${final.stdenv.hostPlatform.system}
      or (throw "nix-orion currently supports only aarch64-darwin");
in
{
  orion-browser = final.callPackage ./package.nix {
    inherit source;
  };
}
