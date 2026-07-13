---
name: survey-orion-settings
description: Survey the macOS Orion release selected by sources.json and update nix-orion's settings catalog.
---

# Survey Orion Settings

Survey the macOS Orion release selected by sources.json and update nix-orion's
settings catalog.

## Guardrails

- Work from the repository root and preserve unrelated user changes.
- Use `sources.json` to identify the target build,
  `modules/home-manager/settings/catalog/settings.nix` as the previous catalog, static
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

1. Read `modules/home-manager/settings/catalog/settings.nix` and
   `modules/home-manager/settings/catalog/survey.md` as the comparison baselines.

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
   package-built app retained above. Confirm that previous preference overrides
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

- Extract strings with `rz-bin -zz` and search for preference-looking keys,
  Settings labels, raw enum values, and `NSUserDefaults` accessors.
- Use Rizin to locate candidate strings, methods, and xrefs. Use Ghidra to
  decompile relevant initializers and handlers when establishing defaults or
  preference behavior.
- Search the current app's resources, localized strings, and compiled interface
  files for controls absent from or renamed since the existing survey.

Evaluate findings conservatively:

- Record an enum value only when the surrounding preference implementation or
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

1. Map each visible preference control to its persisted key. Report controls
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

Use `defaults export ... | plutil -p -` for inspection. Do not force the plist
through JSON because persisted values may contain non-JSON plist objects.

## 4. Update the artifacts

Update `modules/home-manager/settings/catalog/settings.nix` with only supported
findings. Update the top comment with the date this skill was last run:

- Use `default = <value>` for an established persisted factory default.
- Use `default = null` when the clean baseline establishes that the key has no
  persisted value.
- Use `values` only for established finite raw values.
- Use an empty attribute set only for a known durable key whose default or
  allowed values are not established.

Update `modules/home-manager/settings/catalog/survey.md` in place with:

- A brief definition of the static and runtime sources
- A UI-to-key table for every Settings tab
- A `Default` column using Nix literals for fixed defaults and `Unset` when the
  clean baseline has no persisted value, optionally followed by its effective
  fallback in parentheses, such as `Unset (System language)`
- A `Source` column that classifies each setting as `Static`, `Runtime`, or
  `Static + Runtime`
- A compact table for cataloged settings without a visible Settings control

Keep the survey concise and focused on the current catalog. List each catalog
key exactly once. Split grouped settings into separate rows when their defaults
differ. Do not add separate source lists, a chronological work log,
or screenshots. Keep only notes needed to interpret a control, raw value,
grouped write, or intentional omission. Report unresolved findings and skipped
checks in the final run summary instead of expanding the survey.

## 5. Validate and review

Run focused validation:

```sh
nix fmt -- \
  modules/home-manager/settings/catalog/settings.nix \
  modules/home-manager/settings/catalog/survey.md
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

## 6. Clean up and report

Always perform this section, including when the survey stops early. Quit Orion,
reset its preference domain, and remove the temporary working directory:

```sh
defaults delete com.kagi.kagimacOS
rm -rf /tmp/nix-orion-survey
```

Report:

- The previously surveyed and currently selected build numbers
- Keys added, removed, or changed
- Unresolved findings and skipped GUI checks
- Validation results
- Confirmation that temporary files and analysis projects were removed
- Confirmation that Orion's preference domain was reset to the factory baseline
- The changed file list
