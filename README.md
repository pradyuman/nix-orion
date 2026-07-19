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

You can declaratively specify your settings with `programs.orion.settings`.

### General settings

```nix
programs.orion.settings = {
  ShowTitlesInTabs = true;
  TabStyle = "treeStyle";
  CustomAppIcon = "appicon3";
};
```

For more settings, see the
[settings catalog](modules/home-manager/settings/catalog/default.nix), which
lists surveyed keys and defaults, and the
[settings survey](modules/home-manager/settings/catalog/survey.md), which maps
those keys to Orion's visible controls.

### Toolbar configuration

Orion stores the active toolbar order in `TB Item Identifiers`. For Standard
and Vertical tabs, configure it under `ToolbarConfiguration`. For Compact tabs,
use `ToolbarConfigurationForCompactTabs`. The
[settings survey](modules/home-manager/settings/catalog/survey.md#toolbar-customization)
lists the available item identifiers.

Example:

```nix
programs.orion.settings = {
  ToolbarConfiguration = {
    "TB Item Identifiers" = [
      "toggleSidebar"
      "NSToolbarSidebarTrackingSeparatorItemIdentifier"
      "NSToolbarFlexibleSpaceItem"
      "locationBar"
      "NSToolbarFlexibleSpaceItem"
    ];
  };
};
```

### Keyboard shortcuts

macOS menu-item shortcuts use the `NSUserKeyEquivalents` attribute set:

```nix
programs.orion.settings.NSUserKeyEquivalents = {
  "Show Sidebar" = "@s";
  "Hide Sidebar" = "@s";

  # Save Page holds Command-S by default.
  # It must move for the sidebar binding to work.
  "Save Page…" = "@^s";
};
```

Shortcut modifiers use `@` for Command, `$` for Shift, `~` for Option, and `^`
for Control. Menu-item names must match Orion's labels exactly.

### Determinism

By default, nix-orion aims to make Orion settings deterministic. Removing an option from
`programs.orion.settings` resets it to the default recorded in the
[settings catalog](modules/home-manager/settings/catalog/default.nix) instead
of leaving the previous value in Orion. If the catalog default is `null`, the
setting key is removed.

To leave unconfigured settings unchanged:

```nix
programs.orion = {
  resetUnconfiguredSettings = false;
  settings.ShowTitlesInTabs = true;
};
```

The [settings README](modules/home-manager/settings/README.md) documents how the
catalog is maintained. If you notice anything missing from the catalog, please
[file an issue](https://github.com/pradyuman/nix-orion/issues/new) or submit a
pull request.
