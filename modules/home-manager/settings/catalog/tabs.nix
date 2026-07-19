{
  # Tab layout
  TabStyle = {
    default = "compact";
    values = [
      "horizontal"
      "compact"
      "treeStyle"
    ];
  };
  CurrentToolbarSize = {
    default = "large";
    values = [
      "small"
      "large"
    ];
  };
  ShowTabPreviewOnHover.default = true;
  CloseWindowWithLastTab.default = true;
  ClosingLastUnpinnedTabWithPinnedTabsAvailableClosesWindow.default = false;
  ShowTitlesInTabs.default = true;
  TabsShowFavicons.default = true;

  # Navigation
  NewTabPosition = {
    default = "atEnd";
    values = [
      "atEnd"
      "afterCurrent"
    ];
  };
  OpenNewTabsInForeground.default = false;
  OpenNewTabsInCurrentContainer.default = true;
  AutoActivatePinnedTabsOnLaunch.default = true;
  ReturnToLastActiveTabWhenClosingTab.default = true;
  PreventClosingPinnedTabs.default = false;
  UndoTabClose.default = true;
  BookmarksShortcutEnabled.default = false;

  # Vertical tabs
  ShowNestedTabs.default = true;
  TabCloseBehavior = {
    default = "shiftAllChildren";
    values = [
      "shiftAllChildren"
      "convertFirstChild"
      "preserveTabTree"
    ];
  };

  # Tab switcher
  UseTabSwitcherUI.default = false;
  TabSwitchingOrder = {
    default = "byIndex";
    values = [
      "byIndex"
      "byRecentlyUsed"
    ];
  };
}
