{
  description = "Nix flake for the Orion browser";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "aarch64-darwin";
      overlay = import ./overlay.nix;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ overlay ];
      };
    in
    {
      packages.${system} = {
        inherit (pkgs) orion-browser;
        default = pkgs.orion-browser;
      };

      overlays.default = overlay;

      homeModules.default = ./modules/home-manager.nix;
    };
}
