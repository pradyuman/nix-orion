{
  # Appearance
  AppearanceStyle = {
    default = "system";
    values = [
      "system"
      "light"
      "dark"
    ];
  };

  # Theme
  CustomAccentColor.default = "#946FFF";
  AllowWebsiteThemeColor.default = true;
  UseCustomAccentColor.default = false;

  # Window Border (Orion+)
  WindowBorderEnabled.default = false;
  WindowBorderStyle = {
    default = null;
    values = [
      "solid"
      "glass"
      "gradient"
    ];
  };
  WindowBorderThickness.default = 0;
  WindowBorderColorData.default = null;
  WindowBorderGradientPreset.default = null;
  WindowBorderAnimated.default = null;
  WindowBorderOpacity.default = null;
  WindowBorderAnimationSpeed.default = null;
  WindowBorderUseWebsiteThemeColor.default = null;

  # Toolbar
  AlwaysShowToolbarInFullScreen.default = true;
  ShowProfileIndicatorInTabGroupSwitcher.default = true;

  # Search bar
  GroupStatusIndicatorsForCompactTabs.default = true;
  GroupStatusIndicatorsForStandardTabs.default = true;
  GroupStatusIndicatorsForVerticalTabs.default = true;
  ShowRssFeedsButton.default = true;
  DisplayWebAppIndicatorInLocationBar.default = true;

  # Bookmarks bar
  BookmarksBarStyle = {
    default = "iconAndText";
    values = [
      "iconAndText"
      "iconOnly"
      "textOnly"
    ];
  };
  BookmarksBarVisible.default = false;

  # Sidebar
  AutoShowSidebarInFullScreen.default = true;

  # Default font
  DefaultFontFamily.default = "Times New Roman";
  DefaultFontSize.default = 16;
  DefaultMonospacedFont.default = "Courier";
  DefaultMonospaceFontSize.default = 13;

  # Rendering
  ExperimentalFeatures.default = {
    "Prefer Page Rendering Updates near 120fps" = false;
    "Prefer Page Rendering Updates near 60fps" = true;
  };
  DisableTransparencyForFullScreen.default = true;

  # App icon
  CustomAppIcon = {
    default = "";
    values = [
      ""
      "appicon2"
      "appicon3"

      # Orion+
      "orion-plus-01"
      "orion-plus-02"
      "orion-plus-03"
      "orion-plus-04"
      "orion-plus-05"
      "orion-plus-06"
      "orion-plus-07"
      "orion-plus-08"
      "orion-plus-09"
      "orion-plus-10"
      "orion-plus-11"
      "orion-plus-12"
      "orion-plus-13"
      "orion-plus-14"
      "orion-plus-15"
      "orion-plus-16"
      "orion-plus-17"
      "orion-plus-18"
      "orion-plus-19"
      "orion-plus-20"
      "orion-plus-21"
      "orion-plus-22"
      "orion-plus-23"
      "orion-plus-24"
      "orion-plus-25"
      "orion-plus-26"
      "orion-plus-27"
      "orion-plus-28"
      "orion-plus-29"
      "orion-plus-30"
      "orion-plus-31"
      "orion-plus-32"
      "orion-plus-33"
    ];
  };
}
