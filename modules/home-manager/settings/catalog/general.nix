{
  # Orion opens with
  KagiOpensWith = {
    type = "enum";
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
    type = "enum";
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
    type = "enum";
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
  HomePageURL = {
    type = "string";
    default = "https://kagi.com/";
  };

  # File download location
  DownloadLocation = {
    type = "string";
    default = null;
  };
  AskForEachDownload = {
    type = "bool";
    default = false;
  };

  # Remove download items
  RemoveDownloadItemsAfter = {
    type = "enum";
    default = "manually";
    values = [
      "afterOneDay"
      "afterOrionExits"
      "uponSuccessfulDownload"
      "manually"
    ];
  };
  OpenSafeFileAfterDownload = {
    type = "bool";
    default = false;
  };

  # Language
  AppleLanguages = {
    type = "list";
    default = null;
  };

  # Open external links in
  OpenExternalLinksInSetting = {
    type = "enum";
    default = "lastActiveProfile";
    values = [
      "lastActiveProfile"
      "defaultProfile"
    ];
  };

  # Orion updates
  SUEnableAutomaticChecks = {
    type = "bool";
    default = true;
  };
  QuitWithConfirmation = {
    type = "bool";
    default = true;
  };
}
