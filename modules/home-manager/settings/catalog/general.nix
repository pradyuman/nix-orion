{
  # Orion opens with
  KagiOpensWith = {
    default = "restoreLastSessionNonPrivate";
    values = [
      "newWindow"
      "newPrivateWindow"
      "restoreLastSession"
      "restoreLastSessionNonPrivate"
    ];
  };

  # New windows open with
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

  # New tabs open with
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

  # Homepage
  HomePageURL.default = "https://kagi.com/";

  # File download location
  DownloadLocation.default = null;
  AskForEachDownload.default = false;

  # Remove download items
  RemoveDownloadItemsAfter = {
    default = "manually";
    values = [
      "afterOneDay"
      "afterOrionExits"
      "uponSuccessfulDownload"
      "manually"
    ];
  };
  OpenSafeFileAfterDownload.default = false;

  # Language
  AppleLanguages.default = null;

  # Open external links in
  OpenExternalLinksInSetting = {
    default = "lastActiveProfile";
    values = [
      "lastActiveProfile"
      "defaultProfile"
    ];
  };

  # Orion updates
  SUEnableAutomaticChecks.default = true;
  QuitWithConfirmation.default = true;
}
