{
  # Remove trackers from URLs
  RemoveURLTrackersOption = {
    default = "forPrivateBrowsingOnly";
    values = [
      "forPrivateBrowsingOnly"
      "forAllBrowsing"
    ];
  };

  # Remove history items
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

  # Automatically delete cookies
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

  # Cookies and website data
  DisableHistory.default = false;

  # Share crash reports
  SendCrashReports = {
    default = "askBeforeSend";
    values = [
      "askBeforeSend"
      "autoSend"
      "never"
    ];
  };

  # “Custom” user agent
  CustomUserAgent.default = null;

  # Content blocker
  ContentBlockerAutoUpdate.default = false;
}
