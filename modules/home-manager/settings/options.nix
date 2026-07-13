{ lib, ... }:

{
  options.programs.orion = {
    resetUnconfiguredSettings = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether settings omitted from `programs.orion.settings` are reset to
        their surveyed defaults. Set this to false to leave unconfigured
        settings unchanged.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = lib.literalExpression ''
        {
          ShowTitlesInTabs = true;
          TabStyle = "treeStyle";
          CustomAppIcon = "appicon3";
          NSUserKeyEquivalents = {
            "Show Sidebar" = "@s";
            "Hide Sidebar" = "@s";

            # Save Page holds cmd-s by default.
            # It must move for the sidebar binding to work.
            "Save Page…" = "@^s";
          };
        }
      '';
      description = "Orion preferences written to the com.kagi.kagimacOS defaults domain on Darwin.";
    };
  };
}
