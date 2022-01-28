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
