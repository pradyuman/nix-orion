{
  description = "Nix flake for the Orion browser";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      sources = builtins.fromJSON (builtins.readFile ./sources.json);
      orion-browser = pkgs.callPackage ./package.nix {
        source = sources.darwin.aarch64;
      };
    in
    {
      packages.${system} = {
        inherit orion-browser;
        default = orion-browser;
      };
    };
}
