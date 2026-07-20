{
  # Remove trackers from URLs
  RemoveURLTrackersOption = {
    type = "enum";
    default = "forPrivateBrowsingOnly";
    values = [
      "forPrivateBrowsingOnly"
      "forAllBrowsing"
    ];
  };

  # Remove history items
  RemoveHistoryItemsAfter = {
    type = "enum";
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

  # Automatically delete cookies
  AutomaticallyDeleteCookiesAfter = {
    type = "enum";
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

  # Cookies and website data
  DisableHistory = {
    type = "bool";
    default = false;
  };

  # Share crash reports
  SendCrashReports = {
    type = "enum";
    default = "askBeforeSend";
    values = [
      "askBeforeSend"
      "autoSend"
      "never"
    ];
  };

  # “Custom” user agent
  CustomUserAgent = {
    type = "string";
    default = null;
  };

  # Content blocker
  ContentBlockerAutoUpdate = {
    type = "bool";
    default = false;
  };
}
