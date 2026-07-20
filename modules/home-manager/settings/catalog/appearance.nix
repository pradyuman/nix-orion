{
  # Appearance
  AppearanceStyle = {
    type = "enum";
    default = "system";
    values = [
      "system"
      "light"
      "dark"
    ];
  };

  # Theme
  CustomAccentColor = {
    type = "color";
    default = "#946FFF";
  };
  AllowWebsiteThemeColor = {
    type = "bool";
    default = true;
  };
  UseCustomAccentColor = {
    type = "bool";
    default = false;
  };

  # Window Border (Orion+)
  WindowBorderEnabled = {
    type = "bool";
    default = false;
  };
  WindowBorderStyle = {
    type = "enum";
    default = null;
    values = [
      0 # Solid
      1 # Glass
      2 # Gradient
    ];
  };
  WindowBorderThickness = {
    type = "enum";
    default = 0;
    values = [
      0 # Thin
      1 # Medium
      2 # Thick
    ];
  };
  WindowBorderColorData = {
    type = "color";
    encoding = "nsColor";
    default = null;
  };
  WindowBorderGradientPreset = {
    type = "enum";
    default = null;
    values = [
      0 # Orion Glow
      1 # Orion Dark
      2 # Flare
      3 # Deep Space
      4 # Horizon
      5 # Mint
      6 # Cosmic
      7 # Ocean
      8 # Rainbow
      9 # Fire & Ice
      10 # Silver
      11 # Gold
    ];
  };
  WindowBorderAnimated = {
    type = "bool";
    default = null;
  };
  WindowBorderOpacity = {
    type = "int";
    default = null;
    range = {
      min = 0;
      max = 100;
    };
  };
  WindowBorderAnimationSpeed = {
    type = "enum";
    default = null;
    values = [
      0 # Off
      50 # Slow
      100 # Fast
    ];
  };
  WindowBorderUseWebsiteThemeColor = {
    type = "bool";
    default = null;
  };

  # Toolbar
  AlwaysShowToolbarInFullScreen = {
    type = "bool";
    default = true;
  };
  ShowProfileIndicatorInTabGroupSwitcher = {
    type = "bool";
    default = true;
  };

  # Search bar
  GroupStatusIndicatorsForCompactTabs = {
    type = "bool";
    default = true;
  };
  GroupStatusIndicatorsForStandardTabs = {
    type = "bool";
    default = true;
  };
  GroupStatusIndicatorsForVerticalTabs = {
    type = "bool";
    default = true;
  };
  ShowRssFeedsButton = {
    type = "bool";
    default = true;
  };
  DisplayWebAppIndicatorInLocationBar = {
    type = "bool";
    default = true;
  };

  # Bookmarks bar
  BookmarksBarStyle = {
    type = "enum";
    default = "iconAndText";
    values = [
      "iconAndText"
      "iconOnly"
      "textOnly"
    ];
  };
  BookmarksBarVisible = {
    type = "bool";
    default = false;
  };

  # Sidebar
  AutoShowSidebarInFullScreen = {
    type = "bool";
    default = true;
  };

  # Default font
  DefaultFontFamily = {
    type = "string";
    default = "Times New Roman";
  };
  DefaultFontSize = {
    type = "int";
    default = 16;
  };
  DefaultMonospacedFont = {
    type = "string";
    default = "Courier";
  };
  DefaultMonospaceFontSize = {
    type = "int";
    default = 13;
  };

  # Rendering
  ExperimentalFeatures = {
    type = "attrs";
    default = {
      "Prefer Page Rendering Updates near 120fps" = false;
      "Prefer Page Rendering Updates near 60fps" = true;
    };
  };
  DisableTransparencyForFullScreen = {
    type = "bool";
    default = true;
  };

  # App icon
  CustomAppIcon = {
    type = "enum";
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
