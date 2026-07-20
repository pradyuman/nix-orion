{
  # Check for SSL website
  PreferHTTPS = {
    type = "bool";
    default = true;
  };

  # URL display
  ShowFullWebsiteAddress = {
    type = "bool";
    default = true;
  };
  DisplayIDNDomains = {
    type = "bool";
    default = false;
  };

  # Bookmarks
  OpenBookmarksInNewTabs = {
    type = "bool";
    default = false;
  };

  # Navigation
  FavoritesShortcutEnabled = {
    type = "bool";
    default = true;
  };

  # Window switcher
  WSSwitchWindowsInPlace = {
    type = "bool";
    default = true;
  };

  # Link Preview
  OpenLinkPreview = {
    type = "bool";
    default = true;
  };

  # Focus Mode
  ShowFocusModeIndicator = {
    type = "bool";
    default = true;
  };

  # Picture in Picture
  confirmClosingTabsWhenInPiP = {
    type = "bool";
    default = true;
  };

  # Spelling and Grammar
  WebContinuousSpellCheckingEnabled = {
    type = "bool";
    default = false;
  };
  WebAutomaticSpellingCorrectionEnabled = {
    type = "bool";
    default = false;
  };

  # Accessibility
  UseMinimumFontSize = {
    type = "bool";
    default = false;
  };
  MinimumFontSize = {
    type = "int";
    default = 9;
  };
  TabFocusesLinks = {
    type = "bool";
    default = false;
  };
  PreventESCFromExitingFullScreen = {
    type = "bool";
    default = false;
  };
}
