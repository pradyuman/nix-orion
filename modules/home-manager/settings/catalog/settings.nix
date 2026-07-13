# PreferenceValue :: null | Bool | Int | String | [ PreferenceValue ] | { String = PreferenceValue; }
# Setting :: { default :: PreferenceValue; values? :: [ PreferenceValue ]; }
{
  # General
  AppleLanguages.default = null;
  AskForEachDownload.default = false;
  DownloadLocation.default = null;
  HomePageURL.default = "https://kagi.com/";
  KagiOpensWith = {
    default = "restoreLastSessionNonPrivate";
    values = [
      "newWindow"
      "newPrivateWindow"
      "restoreLastSession"
      "restoreLastSessionNonPrivate"
    ];
  };
  NewTabOpensTo = {
    default = "frequentlyVisitedSites";
    values = [
      "frequentlyVisitedSites"
      "emptyPage"
      "samePage"
      "homePage"
      "notes"
    ];
  };
  NewWindowOpensTo = {
    default = "frequentlyVisitedSites";
    values = [
      "frequentlyVisitedSites"
      "emptyPage"
      "samePage"
      "homePage"
      "notes"
    ];
  };
  NotificationsEnabled.default = true;
  OpenExternalLinksInSetting = {
    default = "lastActiveProfile";
    values = [
      "lastActiveProfile"
      "defaultProfile"
    ];
  };
  OpenSafeFileAfterDownload.default = false;
  QuitWithConfirmation.default = true;
  RemoveDownloadItemsAfter = {
    default = "manually";
    values = [
      "afterOneDay"
      "afterOrionExits"
      "uponSuccessfulDownload"
      "manually"
    ];
  };
  SUEnableAutomaticChecks.default = true;

  # Appearance
  AllowWebsiteThemeColor.default = true;
  AlwaysShowToolbarInFullScreen.default = true;
  AppearanceStyle = {
    default = "system";
    values = [
      "system"
      "light"
      "dark"
    ];
  };
  AutoShowSidebarInFullScreen.default = true;
  BookmarksBarStyle = {
    default = "iconAndText";
    values = [
      "iconAndText"
      "iconOnly"
      "textOnly"
    ];
  };
  BookmarksBarVisible.default = false;
  CustomAccentColor.default = "#946FFF";
  CustomAppIcon = {
    default = "";
    values = [
      ""
      "appicon2"
      "appicon3"
    ];
  };
  DefaultFontFamily.default = "Times New Roman";
  DefaultFontSize.default = 16;
  DefaultMonospaceFontSize.default = 13;
  DefaultMonospacedFont.default = "Courier";
  DisableTransparencyForFullScreen.default = true;
  DisplayWebAppIndicatorInLocationBar.default = true;
  GroupStatusIndicatorsForCompactTabs.default = true;
  GroupStatusIndicatorsForStandardTabs.default = true;
  GroupStatusIndicatorsForVerticalTabs.default = true;
  ShowProfileIndicatorInTabGroupSwitcher.default = true;
  ShowRssFeedsButton.default = true;
  StatusBarVisible.default = true;
  UseCustomAccentColor.default = false;
  WindowBorderEnabled.default = false;
  WindowBorderAnimated.default = null;
  WindowBorderAnimationSpeed.default = null;
  WindowBorderColorData.default = null;
  WindowBorderGradientPreset.default = null;
  WindowBorderOpacity.default = null;
  WindowBorderStyle = {
    default = null;
    values = [
      "solid"
      "glass"
      "gradient"
    ];
  };
  WindowBorderThickness.default = 0;
  WindowBorderUseWebsiteThemeColor.default = null;

  # Start page
  ShowBackgroundImageOnStartPage.default = true;
  ShowFavoritesOnStartPage.default = true;
  ShowReadingListOnStartPage.default = true;
  ShowRecommendationsOnStartPage.default = true;
  ShowTopSitesOnStartPage.default = true;

  # Tabs
  AutoActivatePinnedTabsOnLaunch.default = true;
  BookmarksShortcutEnabled.default = false;
  CloseWindowWithLastTab.default = true;
  ClosingLastUnpinnedTabWithPinnedTabsAvailableClosesWindow.default = false;
  CurrentToolbarSize = {
    default = "large";
    values = [
      "small"
      "large"
    ];
  };
  NewTabPosition = {
    default = "atEnd";
    values = [
      "atEnd"
      "afterCurrent"
    ];
  };
  OpenNewTabsInCurrentContainer.default = true;
  OpenNewTabsInForeground.default = false;
  PreventClosingPinnedTabs.default = false;
  ReturnToLastActiveTabWhenClosingTab.default = true;
  ShowNestedTabs.default = true;
  ShowTabPreviewOnHover.default = true;
  ShowTitlesInTabs.default = true;
  TabCloseBehavior = {
    default = "shiftAllChildren";
    values = [
      "shiftAllChildren"
      "convertFirstChild"
      "preserveTabTree"
    ];
  };
  TabStyle = {
    default = "compact";
    values = [
      "horizontal"
      "compact"
      "treeStyle"
    ];
  };
  TabSwitchingOrder = {
    default = "byIndex";
    values = [
      "byIndex"
      "byRecentlyUsed"
    ];
  };
  TabsShowFavicons.default = true;
  UndoTabClose.default = true;
  UseTabSwitcherUI.default = false;

  # Browsing
  DisplayIDNDomains.default = false;
  FavoritesShortcutEnabled.default = true;
  OpenBookmarksInNewTabs.default = false;
  OpenLinkPreview.default = true;
  MinimumFontSize.default = 9;
  PreferHTTPS.default = true;
  PreventESCFromExitingFullScreen.default = false;
  ShowFocusModeIndicator.default = true;
  ShowFullWebsiteAddress.default = true;
  TabFocusesLinks.default = false;
  UseMinimumFontSize.default = false;
  WSSwitchWindowsInPlace.default = true;
  WebAutomaticSpellingCorrectionEnabled.default = false;
  WebContinuousSpellCheckingEnabled.default = false;
  confirmClosingTabsWhenInPiP.default = true;

  # Passwords
  AutoFillSubmitFormAutomatically.default = true;
  AutofillEnabled.default = true;
  OfferSavePassword.default = true;
  PasswordProvider = {
    default = "orionKeychain";
    values = [
      "orionKeychain"
      "thirdParty"
      "none"
    ];
  };
  PasswordSavingEnabled.default = true;
  UseTouchIDForAutoFill.default = true;

  # Privacy
  AutomaticallyDeleteCookiesAfter = {
    default = "manually";
    values = [
      "afterOneDay"
      "afterOneWeek"
      "afterTwoWeeks"
      "afterOneMonth"
      "afterThreeMonths"
      "afterSixMonths"
      "afterOneYear"
      "afterOrionExits"
      "manually"
    ];
  };
  ContentBlockerAutoUpdate.default = false;
  CookieNonPersist.default = false;
  CustomUserAgent.default = null;
  DisableHistory.default = false;
  RemoveHistoryItemsAfter = {
    default = "afterThreeMonths";
    values = [
      "afterOneDay"
      "afterOneWeek"
      "afterTwoWeeks"
      "afterOneMonth"
      "afterThreeMonths"
      "afterSixMonths"
      "afterOneYear"
      "afterOrionExits"
      "manually"
    ];
  };
  RemoveURLTrackersOption = {
    default = "forPrivateBrowsingOnly";
    values = [
      "forPrivateBrowsingOnly"
      "forAllBrowsing"
    ];
  };
  SendCrashReports = {
    default = "askBeforeSend";
    values = [
      "askBeforeSend"
      "autoSend"
      "never"
    ];
  };

  # Search
  AskKagiEnabled.default = true;
  DefaultSearchEngine.default = "Kagi";
  PrivateSearchEngine.default = "None";
  BookmarksSuggestionsEnabled.default = true;
  HistorySuggestionsEnabled.default = true;
  OpenTabsSuggestionsEnabled.default = true;
  SearchSuggestEnabled.default = true;
  ShowKagiPrivacyPass.default = false;
  TopHitsEnabled.default = true;
  UseDefaultSearchEngineInPrivateMode.default = false;

  # Advanced
  JSONRenderer.default = true;

  # Extensions
  AllowChromeWebExtensions.default = true;
  AllowFirefoxWebExtensions.default = true;
  WebExtAutomaticUpdates.default = false;

  # Raw dictionaries
  ExperimentalFeatures.default = {
    "Prefer Page Rendering Updates near 120fps" = false;
    "Prefer Page Rendering Updates near 60fps" = true;
  };
  NSUserKeyEquivalents.default = null;
}
