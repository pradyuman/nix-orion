#!/usr/bin/env nix
#!nix shell --inputs-from .. nixpkgs#bash -c bash

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "Orion release verification requires macOS" >&2
  exit 1
fi

repo_root="$(dirname "${BASH_SOURCE[0]}")/.."
sources_json="$repo_root/sources.json"
flake="path:$repo_root"

# Orion's CFBundleIdentifier from its Info.plist.
expected_bundle_id="com.kagi.kagimacOS"

# Kagi's Apple Developer TeamIdentifier from Orion's code signature.
expected_team_id="TFVG979488"

out="$(nix build "$flake#orion-browser" --no-link --print-out-paths)"
app="$out/Applications/Orion.app"

# Confirm the built app matches the version pinned in sources.json.
version="$(plutil -extract CFBundleVersion raw -o - "$app/Contents/Info.plist")"
source_version="$(plutil -extract darwin.aarch64.version raw -o - "$sources_json")"
if [[ "$version" != "$source_version" ]]; then
  echo "Expected build $source_version, got $version" >&2
  exit 1
fi

# Confirm the downloaded artifact identifies itself as Orion.
bundle_id="$(plutil -extract CFBundleIdentifier raw -o - "$app/Contents/Info.plist")"
if [[ "$bundle_id" != "$expected_bundle_id" ]]; then
  echo "Unexpected bundle identifier: $bundle_id" >&2
  exit 1
fi

# Confirm the app was signed by Kagi's expected Apple developer team.
team_id="$(codesign --display --verbose=4 "$app" 2>&1 | sed -n 's/^TeamIdentifier=//p')"
if [[ "$team_id" != "$expected_team_id" ]]; then
  echo "Unexpected signing team: $team_id" >&2
  exit 1
fi

# Verify the app and its nested code still match their signatures.
codesign --verify --deep --strict "$app"

# Confirm Gatekeeper accepts the app for execution.
spctl --assess --type execute --verbose=4 "$app"

# Confirm the app carries a valid Apple notarization ticket.
xcrun stapler validate "$app"

echo "Orion $version"
echo "Bundle identifier: $bundle_id"
echo "Signing team: $team_id"
echo "Code signature, Gatekeeper assessment, and notarization passed"
