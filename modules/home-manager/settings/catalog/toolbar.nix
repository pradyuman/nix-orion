let
  toolbarItemSchema = {
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
    default = null;
    values."TB Item Identifiers" = toolbarItemSchema;
  };
  ToolbarConfigurationForCompactTabs = {
    default = {
      "TB Display Mode" = 2;
      "TB Icon Size Mode" = 1;
      "TB Is Shown" = true;
      "TB Size Mode" = 1;
    };
    values."TB Item Identifiers" = toolbarItemSchema;
  };
  overflowMenuItems.default = null;
  overflowMenuItemsForCompactTabs.default = null;

  # Orion/AppKit may recreate these runtime mirrors. Users should not configure
  # them; null lets the default reset behavior remove stale mirrors.
  "NSToolbar Configuration BrowserToolbar".default = null;
  "NSToolbar Configuration BrowserCompactTabToolbar".default = null;
}
