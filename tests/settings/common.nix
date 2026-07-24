{ homeManagerLib, pkgs }:

{
  orionDomain = "com.kagi.kagimacOS";

  # Evaluate one Orion configuration inside a real Home Manager configuration.
  evalHome =
    orion:
    (homeManagerLib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ../../modules/home-manager
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
}
