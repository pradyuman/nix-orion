{
  cfg,
  lib,
}:

let
  sources = builtins.fromJSON (builtins.readFile ../../../sources.json);
  orionVersion = sources.darwin.aarch64.version;
in
lib.optional (cfg.omittedSettings == "reset" && (cfg.package.version or null) != orionVersion) ''
  programs.orion.omittedSettings = "reset" uses defaults for Orion version
  ${orionVersion}, but the configured package version is
  ${cfg.package.version or "unknown"}. Orion settings may differ between these versions.
''
