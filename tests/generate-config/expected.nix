{
  programs.orion = {
    enable = true;
    omittedSettings = "reset";
    settings = {
      "HomePageURL" = "https://example.com/\${profile}";
      "ShowTitlesInTabs" = false;
      "TabStyle" = "treeStyle";
      "ToolbarConfiguration" = {
        "TB Display Mode" = 2;
        "TB Item Identifiers" = [
          "toggleSidebar"
          "locationBar"
        ];
      };
    };
  };
}
