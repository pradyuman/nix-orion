{
  # Tab layout
  TabStyle = {
    type = "enum";
    default = "compact";
    values = [
      "horizontal"
      "compact"
      "treeStyle"
    ];
  };
  CurrentToolbarSize = {
    type = "enum";
    default = "large";
    values = [
      "small"
      "large"
    ];
  };
  ShowTabPreviewOnHover = {
    type = "bool";
    default = true;
  };
  CloseWindowWithLastTab = {
    type = "bool";
    default = true;
  };
  ClosingLastUnpinnedTabWithPinnedTabsAvailableClosesWindow = {
    type = "bool";
    default = false;
  };
  ShowTitlesInTabs = {
    type = "bool";
    default = true;
  };
  TabsShowFavicons = {
    type = "bool";
    default = true;
  };

  # Navigation
  NewTabPosition = {
    type = "enum";
    default = "atEnd";
    values = [
      "atEnd"
      "afterCurrent"
    ];
  };
  OpenNewTabsInForeground = {
    type = "bool";
    default = false;
  };
  OpenNewTabsInCurrentContainer = {
    type = "bool";
    default = true;
  };
  AutoActivatePinnedTabsOnLaunch = {
    type = "bool";
    default = true;
  };
  ReturnToLastActiveTabWhenClosingTab = {
    type = "bool";
    default = true;
  };
  PreventClosingPinnedTabs = {
    type = "bool";
    default = false;
  };
  UndoTabClose = {
    type = "bool";
    default = true;
  };
  BookmarksShortcutEnabled = {
    type = "bool";
    default = false;
  };

  # Vertical tabs
  ShowNestedTabs = {
    type = "bool";
    default = true;
  };
  TabCloseBehavior = {
    type = "enum";
    default = "shiftAllChildren";
    values = [
      "shiftAllChildren"
      "convertFirstChild"
      "preserveTabTree"
    ];
  };

  # Tab switcher
  UseTabSwitcherUI = {
    type = "bool";
    default = false;
  };
  TabSwitchingOrder = {
    type = "enum";
    default = "byIndex";
    values = [
      "byIndex"
      "byRecentlyUsed"
    ];
  };
}
