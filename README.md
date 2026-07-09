# nix-orion

Nix flake for the [Orion browser](https://orionbrowser.com) by [Kagi](https://help.kagi.com/kagi/company).

## Configuration

Add the flake input (macOS-only for now):

```nix
inputs.nix-orion.url = "github:pradyuman/nix-orion";
```

Then use the package with one of the options outlined below.

### Use the Home Manager module

```nix
{
  imports = [
    inputs.nix-orion.homeModules.default
  ];

  # This makes pkgs.orion-browser available to the module.
  nixpkgs.overlays = [
    inputs.nix-orion.overlays.default
  ];

  programs.orion = {
    enable = true;

    settings = {
      ShowTitlesInTabs = true;
      TabStyle = "treeStyle";
      CustomAppIcon = "appicon3";
      NSUserKeyEquivalents = {
        "Show Sidebar" = "@s";
        "Hide Sidebar" = "@s";

        # Save Page holds cmd-s by default.
        # It must move for the sidebar binding to work.
        "Save Page…" = "@^s";
      };
    };
  };
}
```

### Use the package directly

```nix
# nix-darwin
environment.systemPackages = [
  inputs.nix-orion.packages.${pkgs.stdenv.hostPlatform.system}.orion-browser
];

# Home Manager
home.packages = [
  inputs.nix-orion.packages.${pkgs.stdenv.hostPlatform.system}.orion-browser
];
```

### Use the overlay

Add the overlay in your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-orion.url = "github:pradyuman/nix-orion";
  };

  outputs =
    inputs@{ nix-darwin, ... }:
    {
      darwinConfigurations.hostname = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };

        modules = [
          {
            nixpkgs.overlays = [ inputs.nix-orion.overlays.default ];
          }
        ];
      };
    };
}
```

Then use `pkgs.orion-browser`:

```nix
# nix-darwin
environment.systemPackages = [
  pkgs.orion-browser
];

# Home Manager
home.packages = [
  pkgs.orion-browser
];
```

## Usage

Once configured, you can launch the browser from `Applications` or from your terminal:

```sh
# This will launch the Orion browser.
$ orion
```
