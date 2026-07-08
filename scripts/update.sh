#!/usr/bin/env nix
#!nix shell --inputs-from . nixpkgs#bash nixpkgs#curl nixpkgs#jq nixpkgs#libplist nixpkgs#_7zz nixpkgs#moreutils -c bash

set -euo pipefail

macos_version="26_0"
sources_json="$(dirname "${BASH_SOURCE[0]}")/../sources.json"

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

dmg="$tmpdir/Orion.dmg"
curl -fsSL -o "$dmg" "https://cdn.kagi.com/downloads/$macos_version/Orion.dmg"
version="$(
  7zz e -so "$dmg" "Orion/Orion.app/Contents/Info.plist" |
  plistutil -i - -f json -o - |
  jq -r '.CFBundleVersion'
)"

if [[ -z "$version" ]]; then
  echo "[update] Failed to read Orion version from Info.plist" >&2
  exit 1
fi

zip="$tmpdir/Orion.zip"
url="https://cdn.kagi.com/updates/$macos_version/$version.zip"
curl -fsSL -o "$zip" "$url"
hash="$(nix hash file --type sha256 --sri "$zip")"

jq \
  --arg version "$version" \
  --arg url "$url" \
  --arg hash "$hash" \
  '.darwin.aarch64 = { version: $version, url: $url, hash: $hash }' \
  "$sources_json" | sponge "$sources_json"

echo "[update] Orion $version"
echo "[update] $url"
echo "[update] $hash"
