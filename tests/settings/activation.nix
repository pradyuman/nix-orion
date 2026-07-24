{
  evalHome,
  lib,
  orionDomain,
}:

let
  resetActivation = (evalHome { }).home.activation.unsetOrionDefaults.data;

  colorConfig = evalHome {
    omittedSettings = "preserve";
    settings.WindowBorderColorData = "#c7b299";
  };
in
{
  # Reset mode should delete settings whose catalog default is null.
  testResetUnsetActivation = {
    expr = lib.all (fragment: lib.hasInfix fragment resetActivation) [
      "/usr/bin/defaults delete"
      orionDomain

      # WindowBorderColorData is one of the settings that has a null catalog default.
      "WindowBorderColorData"
    ];
    expected = true;
  };

  # Preserve mode should leave omitted settings alone.
  testPreserveUnsetActivation = {
    expr = (evalHome { omittedSettings = "preserve"; }).home.activation ? unsetOrionDefaults;
    expected = false;
  };

  # NSColor settings should be written with the configured domain, name, and value.
  testNSColorActivation = {
    expr =
      lib.all (fragment: lib.hasInfix fragment colorConfig.home.activation.writeOrionNSColors.data)
        [
          orionDomain
          "WindowBorderColorData"
          "#c7b299"
        ];
    expected = true;
  };

  # NSColor settings should not also be written as plain Darwin defaults.
  testNSColorDarwinDefaults = {
    expr = lib.hasAttrByPath [
      orionDomain
      "WindowBorderColorData"
    ] colorConfig.targets.darwin.defaults;
    expected = false;
  };
}
