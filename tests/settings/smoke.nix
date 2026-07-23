{ lib }:

let
  settings =
    (lib.evalModules {
      modules = [
        ../../modules/home-manager/settings/options.nix
        {
          programs.orion.settings.ShowTitlesInTabs = false;
        }
      ];
    }).config.programs.orion.settings;
in
{
  testBoolean = {
    expr = settings.ShowTitlesInTabs;
    expected = false;
  };
}
