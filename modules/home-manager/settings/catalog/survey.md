# Orion settings survey

This survey covers settings for Orion 1.1.1 (149) on aarch64-darwin, identified
using Codex with GPT-5.6 Sol (High) and the
[Orion settings survey skill](../../../.agents/skills/survey-orion-settings/SKILL.md),
then sanity checked by me.

The static pass used Rizin and Ghidra to inspect the Orion binary for setting
keys, raw enum strings, and Boolean factory defaults. The catalog includes a
Boolean default only when the binary initializes the setting directly.
`Unset` means the clean baseline has no persisted value for the key; text in
parentheses describes Orion's effective fallback.

The Nix catalog files in this directory also include the accepted raw values
for settings with a fixed set of choices, including nested values such as
toolbar item identifiers.

For runtime checks, Codex reset Orion's local state and then changed one
Settings control at a time, diffed the `com.kagi.kagimacOS` plist, and restored
each control to its default value.

This is a best-effort survey and may miss hidden, conditional, or dynamically
created settings. If you notice anything missing, please
[file an issue](https://github.com/pradyuman/nix-orion/issues/new) or feel free
to submit a pull request.

## General

| UI control                          | Setting                      | Default                          | Source           | Notes                             |
| ----------------------------------- | ---------------------------- | -------------------------------- | ---------------- | --------------------------------- |
| Orion opens with                    | `KagiOpensWith`              | `"restoreLastSessionNonPrivate"` | Static + Runtime |                                   |
| New windows open with               | `NewWindowOpensTo`           | `"frequentlyVisitedSites"`       | Static + Runtime |                                   |
| New tabs open with                  | `NewTabOpensTo`              | `"frequentlyVisitedSites"`       | Static + Runtime |                                   |
| Homepage                            | `HomePageURL`                | `"https://kagi.com/"`            | Runtime          |                                   |
| File download location              | `DownloadLocation`           | Unset (System Downloads folder)  | Static + Runtime |                                   |
| Ask for each download               | `AskForEachDownload`         | `false`                          | Static + Runtime | An option in the location menu.   |
| Remove download items               | `RemoveDownloadItemsAfter`   | `"manually"`                     | Static + Runtime |                                   |
| Open safe files after downloading   | `OpenSafeFileAfterDownload`  | `false`                          | Static + Runtime |                                   |
| Language                            | `AppleLanguages`             | Unset (System language)          | Runtime          | Stored as an array.               |
| Default profile                     | —                            | —                                | Runtime          | Dynamic profile state is omitted. |
| Open external links in              | `OpenExternalLinksInSetting` | `"lastActiveProfile"`            | Static + Runtime |                                   |
| Automatically keep Orion up to date | `SUEnableAutomaticChecks`    | `true`                           | Runtime          | Sparkle setting.                  |
| Show warning before quitting        | `QuitWithConfirmation`       | `true`                           | Static + Runtime |                                   |

## Appearance

| UI control                                   | Setting                                                                                                               | Default                                                                                                       | Source           | Notes                                                                                                          |
| -------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ---------------- | -------------------------------------------------------------------------------------------------------------- |
| System, Light, Dark                          | `AppearanceStyle`                                                                                                     | `"system"`                                                                                                    | Static + Runtime |                                                                                                                |
| Theme color swatches                         | `CustomAccentColor`                                                                                                   | `"#946FFF"`                                                                                                   | Static + Runtime | Materialized when custom accent color is enabled.                                                              |
| Allow website theme color                    | `AllowWebsiteThemeColor`                                                                                              | `true`                                                                                                        | Static + Runtime |                                                                                                                |
| Use custom accent color                      | `UseCustomAccentColor`                                                                                                | `false`                                                                                                       | Static + Runtime |                                                                                                                |
| Window Border: Customize                     | `WindowBorderEnabled`                                                                                                 | `false`                                                                                                       | Static + Runtime | Orion+ setting.                                                                                                |
| Window Border: Customize                     | `WindowBorderStyle`                                                                                                   | Unset                                                                                                         | Static + Runtime | Orion+ setting.                                                                                                |
| Window Border: Customize                     | `WindowBorderThickness`                                                                                               | `0`                                                                                                           | Static + Runtime | Orion+ setting.                                                                                                |
| Window Border: Customize                     | `WindowBorderColorData`                                                                                               | Unset                                                                                                         | Static + Runtime | Orion+ setting.                                                                                                |
| Window Border: Customize                     | `WindowBorderGradientPreset`                                                                                          | Unset                                                                                                         | Static + Runtime | Orion+ setting.                                                                                                |
| Window Border: Customize                     | `WindowBorderAnimated`                                                                                                | Unset                                                                                                         | Static + Runtime | Orion+ setting.                                                                                                |
| Window Border: Customize                     | `WindowBorderOpacity`                                                                                                 | Unset                                                                                                         | Static + Runtime | Orion+ setting.                                                                                                |
| Window Border: Customize                     | `WindowBorderAnimationSpeed`                                                                                          | Unset                                                                                                         | Static + Runtime | Orion+ setting.                                                                                                |
| Window Border: Customize                     | `WindowBorderUseWebsiteThemeColor`                                                                                    | Unset                                                                                                         | Static + Runtime | Orion+ setting.                                                                                                |
| Always show toolbar in full screen           | `AlwaysShowToolbarInFullScreen`                                                                                       | `true`                                                                                                        | Static + Runtime |                                                                                                                |
| Show profile indicator in tab group switcher | `ShowProfileIndicatorInTabGroupSwitcher`                                                                              | `true`                                                                                                        | Static + Runtime |                                                                                                                |
| Group search bar status indicators           | `GroupStatusIndicatorsForCompactTabs`, `GroupStatusIndicatorsForStandardTabs`, `GroupStatusIndicatorsForVerticalTabs` | `true`                                                                                                        | Static + Runtime | Orion writes all three together.                                                                               |
| Display RSS Feeds indicator                  | `ShowRssFeedsButton`                                                                                                  | `true`                                                                                                        | Static + Runtime |                                                                                                                |
| Display Web Application indicator            | `DisplayWebAppIndicatorInLocationBar`                                                                                 | `true`                                                                                                        | Static + Runtime |                                                                                                                |
| Bookmarks bar style                          | `BookmarksBarStyle`                                                                                                   | `"iconAndText"`                                                                                               | Static + Runtime |                                                                                                                |
| Show bookmarks bar                           | `BookmarksBarVisible`                                                                                                 | `false`                                                                                                       | Static + Runtime |                                                                                                                |
| Auto-show sidebar in full screen             | `AutoShowSidebarInFullScreen`                                                                                         | `true`                                                                                                        | Static + Runtime |                                                                                                                |
| Default font                                 | `DefaultFontFamily`                                                                                                   | `"Times New Roman"`                                                                                           | Static + Runtime |                                                                                                                |
| Font customization                           | `DefaultFontSize`                                                                                                     | `16`                                                                                                          | Static + Runtime |                                                                                                                |
| Font customization                           | `DefaultMonospacedFont`                                                                                               | `"Courier"`                                                                                                   | Static + Runtime |                                                                                                                |
| Font customization                           | `DefaultMonospaceFontSize`                                                                                            | `13`                                                                                                          | Static + Runtime |                                                                                                                |
| Prefer page rendering updates near 120fps    | `ExperimentalFeatures`                                                                                                | `{ "Prefer Page Rendering Updates near 120fps" = false; "Prefer Page Rendering Updates near 60fps" = true; }` | Static + Runtime | Orion writes both refresh-rate flags together.                                                                 |
| Disable transparency for full screen windows | `DisableTransparencyForFullScreen`                                                                                    | `true`                                                                                                        | Static + Runtime |                                                                                                                |
| App icon                                     | `CustomAppIcon`                                                                                                       | `""`                                                                                                          | Static + Runtime | The first icon writes an empty string. `orion-plus-01` through `orion-plus-33` are only available with Orion+. |

## Tabs

| UI control                                         | Setting                                                     | Default              | Source           | Notes                                                                          |
| -------------------------------------------------- | ----------------------------------------------------------- | -------------------- | ---------------- | ------------------------------------------------------------------------------ |
| Standard, Compact, Vertical                        | `TabStyle`                                                  | `"compact"`          | Static + Runtime | Standard is `"horizontal"`; Compact is `"compact"`; Vertical is `"treeStyle"`. |
| Use Mini Toolbar                                   | `CurrentToolbarSize`                                        | `"large"`            | Static + Runtime | Enabled is `"small"`; disabled is `"large"`.                                   |
| Show tab preview on hover                          | `ShowTabPreviewOnHover`                                     | `true`               | Static + Runtime |                                                                                |
| Close window with last tab                         | `CloseWindowWithLastTab`                                    | `true`               | Static + Runtime |                                                                                |
| When pinned tabs are present                       | `ClosingLastUnpinnedTabWithPinnedTabsAvailableClosesWindow` | `false`              | Static + Runtime |                                                                                |
| Always show website titles in tabs                 | `ShowTitlesInTabs`                                          | `true`               | Static + Runtime |                                                                                |
| Show favicons inside tabs                          | `TabsShowFavicons`                                          | `true`               | Static + Runtime |                                                                                |
| Open new tab next to current tab                   | `NewTabPosition`                                            | `"atEnd"`            | Static + Runtime | Checked is `"afterCurrent"`; unchecked is `"atEnd"`.                           |
| Make a newly opened link active                    | `OpenNewTabsInForeground`                                   | `false`              | Static + Runtime |                                                                                |
| Open new tabs in the current container             | `OpenNewTabsInCurrentContainer`                             | `true`               | Static + Runtime |                                                                                |
| Automatically activate pinned tabs on loading      | `AutoActivatePinnedTabsOnLaunch`                            | `true`               | Static + Runtime |                                                                                |
| Return to last active tab when closing current tab | `ReturnToLastActiveTabWhenClosingTab`                       | `true`               | Static + Runtime |                                                                                |
| Prevent closing pinned tabs                        | `PreventClosingPinnedTabs`                                  | `false`              | Static + Runtime |                                                                                |
| Use Command-Z to undo close tab                    | `UndoTabClose`                                              | `true`               | Static + Runtime |                                                                                |
| Use Command-1 through Command-9 to switch tabs     | `BookmarksShortcutEnabled`                                  | `false`              | Static + Runtime | Inverted: checked writes `false`.                                              |
| Show nested vertical tabs                          | `ShowNestedTabs`                                            | `true`               | Static + Runtime |                                                                                |
| Closing an expanded tab                            | `TabCloseBehavior`                                          | `"shiftAllChildren"` | Static + Runtime |                                                                                |
| Use tab switcher UI for Control-Tab                | `UseTabSwitcherUI`                                          | `false`              | Static + Runtime |                                                                                |
| Switch tabs using                                  | `TabSwitchingOrder`                                         | `"byIndex"`          | Static + Runtime |                                                                                |

## Toolbar customization

Orion chooses a toolbar layout based on `TabStyle`. Standard (`"horizontal"`)
and Vertical (`"treeStyle"`) share `ToolbarConfiguration`, while Compact
(`"compact"`) uses `ToolbarConfigurationForCompactTabs`.

Inside the appropriate attribute set, set `TB Item Identifiers` to the ordered
list of toolbar items. Use `NSToolbarFlexibleSpaceItem` for spacing. To control
how those items appear, set `TB Display Mode` to `1` for Icon and Text or `2`
for Icon Only. The Use Mini Toolbar option is configured separately with
`CurrentToolbarSize`.

Overflow Menu item order is configured separately with `overflowMenuItems` or
`overflowMenuItemsForCompactTabs`.

The related setting keys are:

| Setting                              | Default                                                                                         | Source           | Notes                                                        |
| ------------------------------------ | ----------------------------------------------------------------------------------------------- | ---------------- | ------------------------------------------------------------ |
| `ToolbarConfiguration`               | Unset                                                                                           | Static + Runtime | Orion writes it for Standard or Vertical tabs.               |
| `ToolbarConfigurationForCompactTabs` | `{ "TB Display Mode" = 2; "TB Icon Size Mode" = 1; "TB Is Shown" = true; "TB Size Mode" = 1; }` | Static + Runtime | Clean Compact-toolbar default before an item order is saved. |
| `overflowMenuItems`                  | Unset                                                                                           | Static + Runtime | Orion saves the Standard/Vertical overflow order here.       |
| `overflowMenuItemsForCompactTabs`    | Unset                                                                                           | Static + Runtime | Orion saves the Compact overflow order here.                 |

The values accepted by `TB Item Identifiers` are listed below. `Multiple` refers
to whether the toolbar editor allows more than one instance of an item.

| Toolbar item               | Identifier                                        | Default placement    | Multiple | Notes                                                        |
| -------------------------- | ------------------------------------------------- | -------------------- | -------- | ------------------------------------------------------------ |
| Sidebar                    | `toggleSidebar`                                   | Standard and Compact | No       |                                                              |
| Vertical sidebar separator | `NSToolbarSidebarTrackingSeparatorItemIdentifier` | Vertical only        | No       | Inserted automatically when the vertical sidebar is visible. |
| Tab Groups                 | `windowSwitcher`                                  | Standard and Compact | No       |                                                              |
| Back/Forward               | `navigationGroup`                                 | Standard and Compact | No       |                                                              |
| Flexible Space             | `NSToolbarFlexibleSpaceItem`                      | Standard and Compact | Yes      |                                                              |
| Privacy                    | `privacyButton`                                   | Standard             | No       |                                                              |
| Page Tweaks                | `elementPicker`                                   | Standard             | No       |                                                              |
| Website Settings           | `websiteSettingsButton`                           | Standard             | No       |                                                              |
| Address and Search         | `locationBar`                                     | Standard and Compact | No       |                                                              |
| Bookmark                   | `bookmarkButton`                                  | Standard             | No       |                                                              |
| New Tab                    | `addTabButton`                                    | Standard             | No       | Part of the tab control rather than the Compact item list.   |
| Downloads                  | `downloadsButton`                                 | Conditional          | No       | In the default identifier list but absent without downloads. |
| Share                      | `shareButton`                                     | Standard             | No       |                                                              |
| Tab Overview               | `tabOverview`                                     | Standard             | No       |                                                              |
| Overflow Menu              | `overflow`                                        | Standard and Compact | No       |                                                              |
| Home                       | `homeButton`                                      | Optional             | No       |                                                              |
| Start Page                 | `startPageButton`                                 | Optional             | No       |                                                              |
| Notes                      | `notesButton`                                     | Optional             | No       |                                                              |
| New Window                 | `addWindowButton`                                 | Optional             | No       |                                                              |
| New Private Window         | `addPrivateWindowButton`                          | Optional             | No       |                                                              |
| History                    | `historyButton`                                   | Optional             | No       |                                                              |
| Zoom                       | `zoomButton`                                      | Optional             | No       |                                                              |
| Print                      | `printButton`                                     | Optional             | No       |                                                              |
| Web Inspector              | `webInspectorButton`                              | Optional             | No       |                                                              |
| Extensions                 | `extensions`                                      | Optional             | No       | Opens Orion's extension manager.                             |
| Show Reader                | `readerMode`                                      | Optional             | No       |                                                              |
| Focus Mode                 | `focusMode`                                       | Optional             | No       |                                                              |
| Summarize Page             | `summarizePage`                                   | Overflow             | No       |                                                              |
| Kagi Privacy Pass          | `privacyPass`                                     | Optional             | No       | Adding it also enables `ShowKagiPrivacyPass`.                |
| Programmable Button        | `customAction-<UUID>`                             | Overflow             | Yes      | Generated per action; catalog the pattern, not an exact ID.  |
| Web extension button       | `webExtButton-<extension ID>`                     | Conditional          | No       | Derived from the installed extension's ID.                   |

## Browsing

| UI control                                                      | Setting                                 | Default | Source           |
| --------------------------------------------------------------- | --------------------------------------- | ------- | ---------------- |
| Automatic HTTPS upgrade                                         | `PreferHTTPS`                           | `true`  | Static + Runtime |
| Show full website address                                       | `ShowFullWebsiteAddress`                | `true`  | Static           |
| Show Unicode Domains                                            | `DisplayIDNDomains`                     | `false` | Static           |
| Open bookmarks in new tabs                                      | `OpenBookmarksInNewTabs`                | `false` | Static           |
| Use Option-Command-1 through Option-Command-9 to open favorites | `FavoritesShortcutEnabled`              | `true`  | Static           |
| Switch Tab Groups in place                                      | `WSSwitchWindowsInPlace`                | `true`  | Static           |
| Open links from other apps in Preview                           | `OpenLinkPreview`                       | `true`  | Static + Runtime |
| Show standard window buttons in Focus Mode                      | `ShowFocusModeIndicator`                | `true`  | Static + Runtime |
| Confirm closing tabs with Picture in Picture                    | `confirmClosingTabsWhenInPiP`           | `true`  | Static           |
| Check spelling while typing                                     | `WebContinuousSpellCheckingEnabled`     | `false` | Static + Runtime |
| Correct spelling automatically                                  | `WebAutomaticSpellingCorrectionEnabled` | `false` | Static + Runtime |
| Minimum font size                                               | `UseMinimumFontSize`                    | `false` | Static           |
| Minimum font size value                                         | `MinimumFontSize`                       | `9`     | Runtime          |
| Press Tab to highlight each item on a web page                  | `TabFocusesLinks`                       | `false` | Runtime          |
| Prevent ESC from exiting full screen                            | `PreventESCFromExitingFullScreen`       | `false` | Static           |

## Sync

| UI control                                                    | Setting | Default | Source  | Notes                                      |
| ------------------------------------------------------------- | ------- | ------- | ------- | ------------------------------------------ |
| Enable cross-device sync of tabs, bookmarks, and reading list | —       | —       | Runtime | Cloud sync state is intentionally omitted. |

## Passwords

| UI control                                        | Setting                           | Default           | Source           |
| ------------------------------------------------- | --------------------------------- | ----------------- | ---------------- |
| Password provider                                 | `PasswordProvider`                | `"orionKeychain"` | Static + Runtime |
| Offer to AutoFill passwords from Orion's Keychain | `AutofillEnabled`                 | `true`            | Static           |
| Offer to save passwords to Orion's Keychain       | `OfferSavePassword`               | `true`            | Static           |
| Submit form automatically                         | `AutoFillSubmitFormAutomatically` | `true`            | Static           |

## Privacy

| UI control                   | Setting                           | Default                           | Source           |
| ---------------------------- | --------------------------------- | --------------------------------- | ---------------- |
| Remove trackers from URLs    | `RemoveURLTrackersOption`         | `"forPrivateBrowsingOnly"`        | Static + Runtime |
| Remove history items         | `RemoveHistoryItemsAfter`         | `"afterThreeMonths"`              | Static + Runtime |
| Automatically delete cookies | `AutomaticallyDeleteCookiesAfter` | `"manually"`                      | Static + Runtime |
| Disable History              | `DisableHistory`                  | `false`                           | Runtime          |
| Share crash reports          | `SendCrashReports`                | `"askBeforeSend"`                 | Static + Runtime |
| Custom user agent            | `CustomUserAgent`                 | Unset (Current Safari user agent) | Runtime          |
| Auto-update content blockers | `ContentBlockerAutoUpdate`        | `false`                           | Static           |

## Search

| UI control                        | Setting                               | Default  | Source           |
| --------------------------------- | ------------------------------------- | -------- | ---------------- |
| Search engine                     | `DefaultSearchEngine`                 | `"Kagi"` | Static + Runtime |
| Also use in Private Browsing      | `UseDefaultSearchEngineInPrivateMode` | `false`  | Static           |
| Show Kagi Privacy Pass on Toolbar | `ShowKagiPrivacyPass`                 | `false`  | Static + Runtime |
| Private Browsing search engine    | `PrivateSearchEngine`                 | `"None"` | Static + Runtime |
| Top Hits                          | `TopHitsEnabled`                      | `true`   | Runtime          |
| Search engine suggestions         | `SearchSuggestEnabled`                | `true`   | Static           |
| Ask Kagi                          | `AskKagiEnabled`                      | `true`   | Runtime          |
| History suggestions               | `HistorySuggestionsEnabled`           | `true`   | Static           |
| Bookmark suggestions              | `BookmarksSuggestionsEnabled`         | `true`   | Static           |
| Open-tab suggestions              | `OpenTabsSuggestionsEnabled`          | `true`   | Static           |

## Websites

| UI control                                                                                                                                                                                                                                                                                     | Setting | Default | Source  | Notes                                                                    |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ------- | ------- | ------------------------------------------------------------------------ |
| Reader Mode, Auto-Play, Page Zoom, Pop-up Windows, Notifications, Downloads, Camera, Microphone, Screen Sharing, Location, Content Blockers, Tracking Prevention, Cookies, JavaScript, Web Fonts, SSL Certificate Check, User Agent, Compatibility Mode, External Apps, and Picture in Picture | —       | —       | Runtime | Defaults and overrides are dynamic per-site state and are not cataloged. |

## Advanced

| UI control                                           | Setting                     | Default | Source           |
| ---------------------------------------------------- | --------------------------- | ------- | ---------------- |
| Enable JSON formatting                               | `JSONRenderer`              | `true`  | Runtime          |
| Allow installation of third-party Chrome extensions  | `AllowChromeWebExtensions`  | `true`  | Static + Runtime |
| Allow installation of third-party Firefox extensions | `AllowFirefoxWebExtensions` | `true`  | Static           |

## Plus

| UI control                | Setting | Default | Source  | Notes                                       |
| ------------------------- | ------- | ------- | ------- | ------------------------------------------- |
| Plan and purchase actions | —       | —       | Runtime | This tab has no cataloged setting controls. |

## Other settings

These settings don't map to a visible control in the surveyed Settings tabs.

| Setting                          | Default | Source  |
| -------------------------------- | ------- | ------- |
| `NotificationsEnabled`           | `true`  | Static  |
| `StatusBarVisible`               | `true`  | Static  |
| `ShowBackgroundImageOnStartPage` | `true`  | Static  |
| `ShowFavoritesOnStartPage`       | `true`  | Static  |
| `ShowReadingListOnStartPage`     | `true`  | Static  |
| `ShowRecommendationsOnStartPage` | `true`  | Static  |
| `ShowTopSitesOnStartPage`        | `true`  | Static  |
| `PasswordSavingEnabled`          | `true`  | Static  |
| `CookieNonPersist`               | `false` | Static  |
| `UseTouchIDForAutoFill`          | `true`  | Static  |
| `WebExtAutomaticUpdates`         | `false` | Static  |
| `NSUserKeyEquivalents`           | Unset   | Runtime |
