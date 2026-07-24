{ homeManagerLib, pkgs }:

let
  orionModule = ../../modules/home-manager;
  orionDomain = "com.kagi.kagimacOS";

  # Evaluate nix-orion inside a real Home Manager configuration.
  eval =
    orion:
    (homeManagerLib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        orionModule
        {
          home = {
            username = "test";
            homeDirectory = "/Users/test";
            stateVersion = "26.05";
          };
          programs.orion = {
            enable = true;
          }
          // orion;
        }
      ];
    }).config;

  preserve =
    (eval {
      omittedSettings = "preserve";
      settings = {
        ShowTitlesInTabs = false;
        UnknownSetting.accepted = true;
      };
    }).targets.darwin.defaults.${orionDomain};

  reset =
    (eval {
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
