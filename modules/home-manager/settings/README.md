# Orion settings

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


## Catalog format

Every entry in `catalog/settings.nix` needs to have a `default` value or be set to `null`. A default of `null` means the preference key should
be absent in the defaults domain.

Entries with a known finite set of raw values also have a `values` list:

```nix
TabStyle = {
  default = "compact";
  values = [
    "horizontal"
    "compact"
    "treeStyle"
  ];
};
```

## Surveying Orion settings

Until Kagi provides an official catalog of preferences, I've created a
[skill](../../../.agents/skills/survey-orion-settings/SKILL.md) to survey Orion
preferences and update the catalog. The current results are in the
[settings survey](catalog/survey.md).

For static analysis, the skill uses Rizin and Ghidra to find preference keys,
raw enum values, and directly initialized Boolean defaults in the Orion binary.
It also searches Orion's compiled interface files and localized resources.

For runtime analysis, the skill uses Codex Computer Use to inspect each Settings
tab, change one control at a time, and diff the `com.kagi.kagimacOS` plist. It
restores each control afterward and keeps any screenshots temporary.

Each survey resets Orion's local preference domain before runtime checks, since
starting from a clean baseline makes the observed defaults reproducible and
avoids carrying local state into the catalog.

The skill is currently designed around Codex Computer Use because I haven't
found an alternative with comparable quality and reliability. I'd like to make
it work across other models and harnesses as those tools improve.

This method isn't foolproof, so if you find a missing preference or see any
other gaps, please [file an issue](https://github.com/pradyuman/nix-orion/issues/new)
or submit a pull request.
