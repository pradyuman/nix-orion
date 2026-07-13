# nix-orion

Nix flake for the [Orion browser](https://orionbrowser.com) by [Kagi](https://help.kagi.com/kagi/company).

## Quick start

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add nix-orion to your flake inputs
    nix-orion.url = "github:pradyuman/nix-orion";
  };

  outputs =
    {
      home-manager,
      nix-orion,
      nixpkgs,
      ...
    }:
    {
      homeConfigurations."your-user" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";

          # Updates to pkgs.orion-browser in nixpkgs typically arrive on a delay.
          # If you don't mind the delay, you can omit this overlay.
          overlays = [ nix-orion.overlays.default ];
        };

        modules = [
          # Add the Home Manager module
          nix-orion.homeModules.default
          
          # Configure your settings (deterministic by default)
          {
            programs.orion = {
              enable = true;
              settings = {
                ShowTitlesInTabs = true;
                TabStyle = "treeStyle";
                ...
              };
            };
          }
        ];
      };
    };
}
```

## Settings

`programs.orion.settings` maps Orion preference keys to your desired values:

```nix
programs.orion.settings = {
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
```

By default, nix-orion aims to make Orion settings deterministic. Removing an option from
`programs.orion.settings` resets it to the default recorded in the
[settings catalog](modules/home-manager/settings/catalog/settings.nix) instead
of leaving the previous value in Orion. If the catalog default is `null`, the
preference key is removed.

To leave unconfigured settings unchanged:

```nix
programs.orion = {
  resetUnconfiguredSettings = false;
  settings.ShowTitlesInTabs = true;
};
```

The [settings catalog](modules/home-manager/settings/catalog/settings.nix)
lists surveyed keys and defaults. The
[settings survey](modules/home-manager/settings/catalog/survey.md) maps those
keys back to Orion's visible Settings controls.

This is a best-effort catalog and may miss hidden, conditional, or dynamically
created preferences. If you notice anything missing, please
[file an issue](https://github.com/pradyuman/nix-orion/issues/new) or submit a
pull request. The [settings README](modules/home-manager/settings/README.md)
documents how the catalog is maintained.
