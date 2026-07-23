{ lib }:

let
  optionsModule = ../../modules/home-manager/settings/options.nix;

  evalModules =
    modules:
    (lib.evalModules {
      modules = [ optionsModule ] ++ modules;
    }).config.programs.orion.settings;

  eval =
    settings:
    evalModules [
      {
        programs.orion.settings = settings;
      }
    ];

  settings = eval {
    CustomAccentColor = "#c7b299";
    ShowTitlesInTabs = false;
    WindowBorderOpacity = 0;
    UnknownSetting = {
      accepted = true;
    };
  };
in
{
  # False is a real setting value, so it should not be filtered out as omitted.
  testBoolean = {
    expr = settings.ShowTitlesInTabs;
    expected = false;
  };

  # Color settings should preserve their hexadecimal string value.
  testColor = {
    expr = settings.CustomAccentColor;
    expected = "#c7b299";
  };

  # The minimum is inclusive, so 0 should be preserved.
  testRangeMinimum = {
    expr = settings.WindowBorderOpacity;
    expected = 0;
  };

  # The maximum is inclusive, so 100 should be accepted.
  testRangeMaximum = {
    expr =
      (eval {
        WindowBorderOpacity = 100;
      }).WindowBorderOpacity;

    expected = 100;
  };

  # Orion can add settings before the catalog catches up, so uncataloged settings still need to pass through.
  testUncatalogedSetting = {
    expr = settings.UnknownSetting;
    expected = {
      accepted = true;
    };
  };

  # Catalog defaults use an internal omitted marker. It should never leak into the final settings.
  testOmittedSettings = {
    expr = eval { };
    expected = { };
  };

  # The wrapper for omitted values should preserve the underlying list merge behavior.
  testNestedListMerging = {
    expr =
      (evalModules [
        {
          programs.orion.settings.ToolbarConfiguration."TB Item Identifiers" = [ "toggleSidebar" ];
        }
        {
          programs.orion.settings.ToolbarConfiguration."TB Item Identifiers" = [ "locationBar" ];
        }
      ]).ToolbarConfiguration."TB Item Identifiers";

    expected = [
      "locationBar"
      "toggleSidebar"
    ];
  };

  # Configuring one toolbar field should not make an omitted catalog field appear in the final settings.
  testNestedOmittedFieldFiltering = {
    expr =
      (eval {
        ToolbarConfiguration."TB Display Mode" = 2;
      }).ToolbarConfiguration;

    expected = {
      "TB Display Mode" = 2;
    };
  };
}
