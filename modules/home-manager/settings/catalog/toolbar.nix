let
  toolbarItemField = {
    static = [
      "toggleSidebar"
      "NSToolbarSidebarTrackingSeparatorItemIdentifier"
      "windowSwitcher"
      "navigationGroup"
      "NSToolbarFlexibleSpaceItem"
      "privacyButton"
      "elementPicker"
      "websiteSettingsButton"
      "locationBar"
      "bookmarkButton"
      "addTabButton"
      "downloadsButton"
      "shareButton"
      "tabOverview"
      "overflow"
      "homeButton"
      "startPageButton"
      "notesButton"
      "addWindowButton"
      "addPrivateWindowButton"
      "historyButton"
      "zoomButton"
      "printButton"
      "webInspectorButton"
      "extensions"
      "readerMode"
      "focusMode"
      "summarizePage"
      "privacyPass"
    ];

    patterns = [
      # Programmable Button identifiers contain a generated UUID.
      "customAction-[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}"
      # Extension toolbar button identifiers contain the extension ID.
      "webExtButton-.+"
    ];
  };
in
{
  ToolbarConfiguration = {
    type = "attrs";
    default = null;
    fields."TB Item Identifiers" = toolbarItemField;
  };
  ToolbarConfigurationForCompactTabs = {
    type = "attrs";
    default = {
      "TB Display Mode" = 2;
      "TB Icon Size Mode" = 1;
      "TB Is Shown" = true;
      "TB Size Mode" = 1;
    };
    fields."TB Item Identifiers" = toolbarItemField;
  };
  overflowMenuItems = {
    type = "list";
    default = null;
  };
  overflowMenuItemsForCompactTabs = {
    type = "list";
    default = null;
  };

  # Orion/AppKit may recreate these runtime mirrors. Users should not configure
  # them; null lets the default reset behavior remove stale mirrors.
  "NSToolbar Configuration BrowserToolbar" = {
    type = "attrs";
    default = null;
  };
  "NSToolbar Configuration BrowserCompactTabToolbar" = {
    type = "attrs";
    default = null;
  };
}
