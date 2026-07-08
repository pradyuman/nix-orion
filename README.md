# nix-orion

Nix flake for the [Orion browser](https://orionbrowser.com) by [Kagi](https://help.kagi.com/kagi/company).

### Usage

Add the flake input (macOS-only for now):

```nix
inputs.nix-orion.url = "github:pradyuman/nix-orion";
```

Then add Orion to your packages:

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

Afterwards, you can launch the browser from `Applications` or from your terminal:

```sh
# This will launch the Orion browser.
$ orion
```
