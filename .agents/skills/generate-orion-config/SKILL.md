---
name: generate-orion-config
description: Generate and review a Home Manager orion.nix file from current macOS Orion preferences using nix-orion's catalog. Use when migrating an existing Orion setup to programs.orion.settings, comparing live preferences with nix-orion, or refreshing a generated Orion configuration.
---

# Generate Orion Config

Export only cataloged preferences. Keep profiles, tab groups, pinned tabs,
history, sessions, and other browser data in Orion's native import/export flow.

## Guardrails

- Work from the nix-orion repository root.
- Preserve unrelated changes.
- Never run `defaults write`, `defaults delete`, or Orion reset commands.
- Never print or save the complete Orion preference domain.
- Generate to a temporary file first. Do not activate Home Manager.
- Treat profile, extension, and browsing data as private.

## Generate

1. Confirm macOS and the Orion variant. The default domain is
   `com.kagi.kagimacOS`; pass `--domain` for another variant.

2. Create a temporary output path.

3. Run:

   ```sh
   nix run .#generate-config -- --output <temporary-path>
   ```

4. Read stderr. Report skipped settings without exposing their values.

5. Review the file for URLs, personal paths, tokens, and unexpected values.

6. Validate:

   ```sh
   nix-instantiate --parse <temporary-path>
   nix fmt -- <temporary-path>
   ```

7. Show the result or diff. Write the requested `orion.nix` only after the user
   approves its contents and destination.

Use `--include-defaults` only when the user wants a fully explicit snapshot.
Use `--force` only after confirming replacement of the exact output file.

## Limits

- Do not add uncataloged keys. Direct catalog gaps to `survey-orion-settings`.
- Do not claim that profiles, tab groups, or pinned tabs are backed up unless a
  native Orion export/import round trip has been verified.
- Do not export extensions until nix-orion supports reliable declarative
  installation. Toolbar identifiers are preferences, not extension backups.
- If a value cannot be decoded or validated, omit it and report the key.
