{ evalHome, orionDomain }:

let
  preserve =
    (evalHome {
      omittedSettings = "preserve";
      settings = {
        ShowTitlesInTabs = false;
        UnknownSetting.accepted = true;
      };
    }).targets.darwin.defaults.${orionDomain};

  reset =
    (evalHome {
      settings.ShowTitlesInTabs = false;
    }).targets.darwin.defaults.${orionDomain};
in
{
  # Preserve mode should write only explicitly configured settings.
  testPreserveSettings = {
    expr = preserve;
    expected = {
      ShowTitlesInTabs = false;
      UnknownSetting.accepted = true;
    };
  };

  # Reset mode should include non-null catalog defaults.
  testResetDefaults = {
    expr = reset.AppearanceStyle;
    expected = "system";
  };

  # Configured settings should override catalog defaults in reset mode.
  testResetOverride = {
    expr = reset.ShowTitlesInTabs;
    expected = false;
  };

  # Null catalog defaults should not be written through Darwin defaults.
  testNullDefault = {
    expr = reset ? WindowBorderColorData;
    expected = false;
  };
}
