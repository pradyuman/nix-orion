---
name: survey-orion-settings
description: Survey the macOS Orion release selected by sources.json and update nix-orion's settings catalog.
---

# Survey Orion Settings

Survey the macOS Orion release selected by sources.json and update nix-orion's
settings catalog.

## Guardrails

- Work from the repository root and preserve unrelated user changes.
- Use `sources.json` to identify the target build, the files in
  `modules/home-manager/settings/catalog` as the previous catalog, static
  analysis for candidate keys and initializer behavior, and runtime UI and
  plist checks for persistence and UI mappings.
- Survey the build already selected by `sources.json`. Do not run
  `scripts/update.sh` or modify package metadata.
- Reset only Orion's preference domain for the clean survey baseline. Never
  clear browsing data, content blockers, policy caches, or other application
  data, and never run Orion's Factory Reset.
- Do not modify the Git index or create commits. Leave survey changes unstaged
  for review.

## 1. Prepare the survey

1. Read every Nix file in `modules/home-manager/settings/catalog` and
   `modules/home-manager/settings/README.md` as the comparison
   baselines.

2. Create a clean temporary working directory. Use it for plist exports,
   extracted binaries, Ghidra projects, screenshots, and other analysis output:

   ```sh
   rm -rf /tmp/nix-orion-survey
   mkdir -p /tmp/nix-orion-survey
   ```

3. Build the package and retain its output path:

   ```sh
   nix build .#orion-browser --no-link --print-out-paths
   ```

4. Verify that the built app's `CFBundleVersion` matches the aarch64-darwin
   version in `sources.json`.

5. Quit Orion, run `defaults delete com.kagi.kagimacOS`, and launch the
   package-built app retained above. Confirm that previous setting overrides
   are absent before changing any controls.

## 2. Perform static analysis

Use the package-built app retained above for all static analysis.

Run each Rizin and Ghidra command through the repository's locked survey
environment:

```sh
nix develop .#survey --command rz-bin -zz <binary>
nix develop .#survey --command rizin <binary>
nix develop .#survey --command ghidra
```

- Extract strings with `rz-bin -zz` and search for candidate setting keys,
  Settings labels, raw enum values, and `NSUserDefaults` accessors.
- Use Rizin to locate candidate strings, methods, and xrefs. Use Ghidra to
  decompile relevant initializers and handlers when establishing defaults or
  setting behavior.
- Search the current app's resources, localized strings, and compiled interface
  files for controls absent from or renamed since the existing reference.

Evaluate findings conservatively:

- Record an enum value only when the surrounding setting implementation or
  a controlled runtime diff ties it to the key.
- Record a factory default only when initializer analysis or the clean runtime
  baseline establishes it unambiguously.
- Treat menu labels, identifiers, and isolated strings as discovery leads, not
  proof.
- Keep cache, migration, telemetry, sync, window-state, and dynamic profile
  identifiers out of the declarative registry.

## 3. Survey the Settings UI

This phase requires an unlocked desktop session. If Computer Use cannot access
Orion's UI, leave both artifacts unchanged and report the static findings and
skipped GUI checks in the final summary.

Use the package-built app retained above for runtime checks.

For every Settings tab:

1. Map each visible setting control to its persisted key. Report controls
   that do not produce durable plist state or whose key cannot be established.

2. For a control whose persisted key is unknown, export a baseline:

   ```sh
   defaults export com.kagi.kagimacOS /tmp/nix-orion-survey/orion-before.plist
   ```

3. Change exactly one control, export
   `/tmp/nix-orion-survey/orion-after.plist`, and compare parsed plist output.
   Account for Orion materializing previously absent keys.

4. Restore the visible value immediately and verify it in both the UI and a
   fresh plist export.

For controls shown conditionally in a sheet or behind Orion+, preview state is
not persistence evidence. Select the parent mode, click Done, and require a
durable plist delta before recording the dependent values. Do not purchase,
restore, or sign in to Orion+ automatically. Report the blocked checks when an
active subscription is unavailable.

Probe sliders for clamping and snap points rather than assuming they accept
every value in their displayed range. When a slider persists a finite set of
numeric values, catalog it as an `enum` with those values instead of as an
`int`.

Use `defaults export com.kagi.kagimacOS - | plutil -p -` for inspection. Do not
force the plist through JSON because persisted values may contain non-JSON
plist objects.

## 4. Survey the toolbar editor

Survey toolbar customization separately because it is not part of the Settings
UI. Orion has three tab styles but stores only two toolbar layouts. Inspect each
tab style: Standard and Vertical share one set of keys, while Compact uses
another:

- Standard/Vertical uses `ToolbarConfiguration`. AppKit mirrors the layout in
  `NSToolbar Configuration BrowserToolbar`, while `overflowMenuItems` stores
  the overflow order.
- Compact uses `ToolbarConfigurationForCompactTabs`. AppKit mirrors the layout
  in `NSToolbar Configuration BrowserCompactTabToolbar`, while
  `overflowMenuItemsForCompactTabs` stores the overflow order.

`TB Item Identifiers` records the toolbar's current item order. Treat
`TB Default Item Identifiers` as Orion-managed state and exclude it from the
catalog.
For each tab style, record the starting item order and restore it after every
test:

1. Inventory every visible palette item and its label in each tab style with
   Computer Use accessibility output and screenshots. Add items with either
   available secondary action:

   - `Insert at beginning of toolbar`
   - `Insert at end of toolbar`

   Drag items only when the editor does not expose a usable accessibility
   action.

2. Map each palette label to its persisted identifier. Export the
   `com.kagi.kagimacOS` preference domain, add one item, click Done, and export
   the domain again. Diff the two exports, restore the recorded item order, and
   repeat with the next item.

3. Record each item's default placement, whether Orion allows duplicates, and
   when the item is available. Change toolbar controls such as display mode,
   mini-toolbar mode (`CurrentToolbarSize`), and overflow menu order one at a
   time, and map any durable values they write.

4. Test one extension toolbar button in an isolated Orion application support
   directory. Install a known extension, add its button, and record the
   identifier pattern. Quit Orion and restore the original application support
   directory immediately after the test, including if the test fails.

5. Verify each layout through `programs.orion.settings`. Start with only the
   field being tested, relaunch Orion, and check both the visible order and the
   persisted value. If Orion does not apply or preserve the layout, add other
   observed fields one at a time to determine which are required.

## 5. Update the artifacts

Update the appropriate Nix files in
`modules/home-manager/settings/catalog` with only supported findings. Keep
settings in the file matching their Settings tab, toolbar settings and schemas
in `toolbar.nix`, and settings without a matching tab in `other.nix`:

- Keep entries in each tab file in the same top-to-bottom order as Orion's UI.
  Use each visible group label as a comment above its catalog entries, even
  when the group contains only one key. Keep `other.nix` in the same order as
  the reference's Other table.

- Set `type` to `attrs`, `bool`, `color`, `enum`, `float`, `int`, `list`, or
  `string`. Use `color` for a value configured in `#RRGGBB` format. Add
  `encoding = "nsColor"` when Orion persists the color as archived `NSColor`
  data, and omit it otherwise. Use `enum` with a non-empty `values` list when
  the setting accepts a finite set of raw values. Add
  `range = { min = <value>; max = <value>; }` to an `int` when the persisted
  value has inclusive bounds.

- Use `default = <value>` for an established persisted factory default.

- Use `default = null` when the clean baseline establishes that the key has no
  persisted value. This does not make the configured value nullable.

- Use an empty attribute set only for a known durable key whose default or
  allowed values are not established.

- Use `values` only for the accepted members of an `enum`. For a list nested in
  a setting attribute set, map its field name to a `ListField` under `fields`.
  Put fixed toolbar identifiers in `static` and regexes that match identifiers
  derived from runtime data in `patterns`.

Update `modules/home-manager/settings/README.md` in place with:

- A brief definition of the static and runtime sources
- A UI-to-key table for every Settings tab
- A `Default` column using Nix literals for fixed defaults and `Unset` when the
  clean baseline has no persisted value, optionally followed by its effective
  fallback in parentheses, such as `Unset (System language)`
- A `Source` column that classifies each setting as `Static`, `Runtime`, or
  `Static + Runtime`
- A compact table for cataloged settings without a visible Settings control
- A toolbar table mapping each visible palette label to its persisted identifier
  or identifier pattern, default position, repeatability, and any conditional
  availability
- A compact description of the user-configurable toolbar attribute set fields

Keep the reference concise and focused on the current catalog:

- List each user-configurable catalog key exactly once.
- Document AppKit-generated toolbar keys such as
  `NSToolbar Configuration BrowserToolbar` only in catalog comments, not in the
  public reference, because users should not configure them.
- Split grouped settings into separate rows when their defaults differ.
- Do not add separate source lists, a chronological work log, or screenshots.
- Keep only notes needed to interpret a control, raw value, grouped write, or
  intentional omission.
- Report unresolved findings and skipped checks in the final run summary rather
  than expanding the reference.

## 6. Validate and review

Run focused validation:

```sh
nix fmt -- \
  modules/home-manager/settings/catalog/*.nix \
  modules/home-manager/settings/README.md
nix eval --impure --expr '
  let
    flake = builtins.getFlake (toString ./.);
    catalog = import ./modules/home-manager/settings/catalog {
      lib = flake.inputs.nixpkgs.lib;
    };
  in
  builtins.deepSeq catalog true
'
git diff --check
```

Review the complete diff for accidental plist data, personal paths, tokens,
browsing data, and unrelated changes.

## 7. Clean up and report

Always perform this section, including when the survey stops early. Quit Orion
and wait for it to exit. Then reset its preference domain and remove the
temporary working directory:

```sh
defaults delete com.kagi.kagimacOS
rm -rf /tmp/nix-orion-survey
```

Before reporting, confirm that the preference plist is absent or empty and that
the temporary working directory no longer exists.

Report:

- The previously surveyed and currently selected build numbers
- Keys added, removed, or changed
- Unresolved findings and skipped GUI checks
- Validation results
- Confirmation that temporary files and analysis projects were removed
- Confirmation that Orion's preference domain was reset to the factory baseline
- The changed file list
