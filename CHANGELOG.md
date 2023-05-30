## 1.1.3

- Upgraded [macos_window_utils](https://pub.dev/packages/macos_window_utils) to version 1.1.3 to fix an issue that prevented apps from closing properly on Flutter 3.10.
- Fixed a race condition that may cause the window effect to be set before the window manipulator has been initialized on macOS.

## 1.1.2

- Upgraded [macos_window_utils](https://pub.dev/packages/macos_window_utils) to version 1.1.2 to make flutter_acrylic work without modifications to `MainFlutterWindow.swift`.
- Removed dependencies on deprecated Flutter code.
- Refactored code based on newly introduced linter rules.
- Improved the [macos_window_utils](https://pub.dev/packages/macos_window_utils) import to prevent potential breakage in the future.

## 1.1.1

- Upgraded [macos_window_utils](https://pub.dev/packages/macos_window_utils) to version 1.0.2 to ensure compatibility with Flutter 3.7 on macOS.

## 1.1.0+1

- Added [macos_window_utils](https://pub.dev/packages/macos_window_utils) as endorsed implementation.

## 1.1.0

- Added methods to add a toolbar to the window on macOS and change its style.
- Added methods to enable/disable the window's shadow on macOS.
- Added method to make the window fully transparent on macOS.
- Added methods to ignore mouse events on macOS.
- Added method to set the window's subtitle on macOS.
- Added methods and widgets to create visual effect subviews on macOS.
- Improved documentation of various widgets and classes.

**Breaking change:**
Migrated to [macos_window_utils](https://pub.dev/packages/macos_window_utils). See the [migration guide](https://github.com/alexmercerind/flutter_acrylic/blob/master/MIGRATIONGUIDE.md) for more information.

## 1.0.0+2

- Hotfix: Fixes a problem with too many rebuilds in TitlebarSafeArea.
- Using the latest version of [bitsdojo_window](https://github.com/bitsdojo/bitsdojo_window) to fix Flutter 3 compatibility issues.

## 1.0.0+1

- Hotfix: Update Linux method call handler to match new channel & method names.

## 1.0.0

- Fixed `WindowEffect.mica` not working on Windows 11 builds higher or equal to 22523 (@alexmercerind).
- Fixed compatibility with [bitsdojo_window](https://github.com/bitsdojo/bitsdojo_window) (@alexmercerind).
- Added macOS support (@Adrian-Samoticha).
- Added new `WindowEffect.tabbed` entry for newer Windows 11 builds (@alexmercerind).
- Address issues #10, #11, and #12 and add extra utility features for macOS (@Adrian-Samoticha).

## 0.1.0

- Implement `WindowEffect.mica` for Windows 11 or greater.
- BREAKING: Rename `AcrylicEffect` `enum` to `WindowEffect`.
- BREAKING: Rename `gradientColor` argument to color.
- Add `Window.showWindowControls` & `Window.hideWindowControls`.

## 0.0.3

- Update image links & example.

## 0.0.2

- Linux support.

## 0.0.1

- Added `Acrylic` class to use aero or acrylic blur effects on Flutter Windows.
- Added following effects to the plugin:
  - `AcrylicEffect.disabled`.
  - `AcrylicEffect.solid`.
  - `AcrylicEffect.transparent`.
  - `AcrylicEffect.aero`.
  - `AcrylicEffect.acrylic`.
- Other features.
  - Added `Window.enterFullscreen` & `Window.exitFullscreen` methods to make Flutter Window fullscreen.
