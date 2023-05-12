import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/macos/converters/blur_view_state_to_visual_effect_view_state_converter.dart';
import 'package:flutter_acrylic/macos/converters/mac_toolbar_style_to_window_toolbar_style_converter.dart';
import 'package:flutter_acrylic/macos/macos_blur_view_state.dart';
import 'package:flutter_acrylic/macos/macos_toolbar_style.dart';
import 'package:flutter_acrylic/macos/visual_effect_view_properties.dart';
import 'package:flutter_acrylic/macos/converters/window_effect_to_material_converter.dart';
import 'package:flutter_acrylic/window_effect.dart';
import 'package:macos_window_utils/window_manipulator.dart';

/// Platform channel name.
const _kChannelName = "com.alexmercerind/flutter_acrylic";

/// Initializes the plugin.
const _kInitialize = "Initialize";

/// Sets window effect.
const _kSetEffect = "SetEffect";

/// Hides window controls
const _kHideWindowControls = "HideWindowControls";

/// Shows window controls
const _kShowWindowControls = "ShowWindowControls";

/// Enters fullscreen.
const _kEnterFullscreen = "EnterFullscreen";

/// Exits fullscreen.
const _kExitFullscreen = "ExitFullscreen";

const MethodChannel _kChannel = MethodChannel(_kChannelName);
final Completer<void> _kCompleter = Completer<void>();

/// **Window**
///
/// Primary class to control Flutter instance window.
///
class Window {
  /// Initializes the [Window] class.
  ///
  /// _Example_
  /// ```dart
  /// Future<void> main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///   await Window.initialize();
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> initialize() async {
    if (Platform.isMacOS) {
      await WindowManipulator.initialize();
      setEffect(effect: WindowEffect.values[0]);

      return;
    }

    await _kChannel.invokeMethod(_kInitialize);
    _kCompleter.complete();
  }

  /// Sets specified effect for the window.
  ///
  /// When using [WindowEffect.mica], [dark] argument can be used to switch
  /// between light or dark mode of Mica.
  ///
  /// When using [WindowEffect.acrylic], [WindowEffect.aero],
  /// [WindowEffect.disabled], [WindowEffect.solid] or
  /// [WindowEffect.transparent],
  /// [color] argument can be used to change the resulting tint (or color) of
  /// the window background.
  ///
  /// _Examples_
  ///
  /// ```dart
  /// await Window.setEffect(
  ///   effect: WindowEffect.acrylic,
  ///   color: Color(0xCC222222),
  /// );
  /// ```
  ///
  /// ```dart
  /// await Window.setEffect(
  ///   effect: WindowEffect.mica,
  ///   dark: true,
  /// );
  /// ```
  ///
  static Future<void> setEffect({
    required WindowEffect effect,
    Color color = Colors.transparent,
    bool dark = true,
  }) async {
    if (Platform.isMacOS) {
      final material =
          WindowEffectToMaterialConverter.convertWindowEffectToMaterial(effect);
      WindowManipulator.setMaterial(material);

      return;
    }

    await _kCompleter.future;
    await _kChannel.invokeMethod(
      _kSetEffect,
      {
        'effect': effect.index,
        'color': {
          'R': color.red,
          'G': color.green,
          'B': color.blue,
          'A': color.alpha,
        },
        'dark': dark,
      },
    );
  }

  /// Hides window controls.
  static Future<void> hideWindowControls() async {
    if (Platform.isMacOS) {
      WindowManipulator.hideCloseButton();
      WindowManipulator.hideMiniaturizeButton();
      WindowManipulator.hideZoomButton();

      return;
    }

    await _kChannel.invokeMethod(_kHideWindowControls);
  }

  /// Shows window controls.
  static Future<void> showWindowControls() async {
    if (Platform.isMacOS) {
      WindowManipulator.showCloseButton();
      WindowManipulator.showMiniaturizeButton();
      WindowManipulator.showZoomButton();

      return;
    }

    await _kChannel.invokeMethod(_kShowWindowControls);
  }

  /// Makes the Flutter window fullscreen.
  static Future<void> enterFullscreen() async {
    if (Platform.isMacOS) {
      WindowManipulator.enterFullscreen();

      return;
    }

    await _kChannel.invokeMethod(_kEnterFullscreen);
  }

  /// Restores the Flutter window back to normal from fullscreen mode.
  static Future<void> exitFullscreen() async {
    if (Platform.isMacOS) {
      WindowManipulator.exitFullscreen();

      return;
    }

    await _kChannel.invokeMethod(_kExitFullscreen);
  }

  /// Gets the height of the titlebar.
  ///
  /// This value is used to determine the [[TitlebarSafeArea]] widget.
  /// If the full-size content view is enabled, this value will be the height
  /// of the titlebar.
  /// If the full-size content view is disabled, this value will be 0.
  /// This value is only available on macOS.
  static Future<double> getTitlebarHeight() async {
    if (Platform.isMacOS) {
      return WindowManipulator.getTitlebarHeight();
    }

    throw UnsupportedError('getTitlebarHeight() is only available on macOS.');
  }

  /// Sets the document to be edited.
  ///
  /// This will change the appearance of the close button on the titlebar:
  ///
  /// <img width="78" alt="image" src="https://user-images.githubusercontent.com/86920182/209436903-0a6c1f5a-4ab6-454f-a37d-78a5d699f3df.png">
  ///
  /// This method is only available on macOS.
  static Future<void> setDocumentEdited() async {
    WindowManipulator.setDocumentEdited();
  }

  /// Sets the document to be unedited.
  ///
  /// This method is only available on macOS.
  static Future<void> setDocumentUnedited() async {
    WindowManipulator.setDocumentUnedited();
  }

  /// Sets the represented file of the window.
  ///
  /// This method is only available on macOS.
  static Future<void> setRepresentedFilename(String filename) async {
    WindowManipulator.setRepresentedFilename(filename);
  }

  /// Sets the represented URL of the window.
  ///
  /// This method is only available on macOS.
  static Future<void> setRepresentedUrl(String url) async {
    WindowManipulator.setRepresentedUrl(url);
  }

  /// Hides the titlebar of the window.
  ///
  /// This method is only available on macOS.
  static Future<void> hideTitle() async {
    WindowManipulator.hideTitle();
  }

  /// Shows the titlebar of the window.
  ///
  /// This method is only available on macOS.
  static Future<void> showTitle() async {
    WindowManipulator.showTitle();
  }

  /// Makes the window's titlebar transparent.
  ///
  /// This method is only available on macOS.
  static Future<void> makeTitlebarTransparent() async {
    WindowManipulator.makeTitlebarTransparent();
  }

  /// Makes the window's titlebar opaque.
  ///
  /// This method is only available on macOS.
  static Future<void> makeTitlebarOpaque() async {
    WindowManipulator.makeTitlebarOpaque();
  }

  /// Enables the window's full-size content view.
  ///
  /// This expands the area that Flutter can draw to to fill the entire window.
  /// It is recommended to enable the full-size content view when making
  /// the titlebar transparent.
  /// This method is only available on macOS.
  static Future<void> enableFullSizeContentView() async {
    WindowManipulator.enableFullSizeContentView();
  }

  /// Disables the window's full-size content view.
  ///
  /// This method is only available on macOS.
  static Future<void> disableFullSizeContentView() async {
    WindowManipulator.disableFullSizeContentView();
  }

  /// Zooms the window.
  ///
  /// This method is only available on macOS.
  static Future<void> zoomWindow() async {
    WindowManipulator.zoomWindow();
  }

  /// Unzooms the window.
  ///
  /// This method is only available on macOS.
  static Future<void> unzoomWindow() async {
    WindowManipulator.unzoomWindow();
  }

  /// Returns if the window is zoomed.
  ///
  /// This method is only available on macOS.
  static Future<bool> isWindowZoomed() async {
    if (Platform.isMacOS) {
      return WindowManipulator.isWindowZoomed();
    }

    if (!Platform.isMacOS) {
      throw UnsupportedError('isWindowZoomed() is only available on macOS.');
    }

    return false;
  }

  /// Returns if the window is fullscreened.
  ///
  /// This method is only available on macOS.
  static Future<bool> isWindowFullscreened() async {
    if (Platform.isMacOS) {
      return WindowManipulator.isWindowFullscreened();
    }

    if (!Platform.isMacOS) {
      throw UnsupportedError(
        'isWindowFullscreened() is only available on macOS.',
      );
    }

    return false;
  }

  /// Hides the window's zoom button.
  ///
  /// This method is only available on macOS.
  static Future<void> hideZoomButton() async {
    WindowManipulator.hideZoomButton();
  }

  /// Shows the window's zoom button.
  ///
  /// The zoom button is visible by default.
  /// This method is only available on macOS.
  static Future<void> showZoomButton() async {
    WindowManipulator.showZoomButton();
  }

  /// Hides the window's miniaturize button.
  ///
  /// This method is only available on macOS.
  static Future<void> hideMiniaturizeButton() async {
    WindowManipulator.hideMiniaturizeButton();
  }

  /// Shows the window's miniaturize button.
  ///
  /// The miniaturize button is visible by default.
  /// This method is only available on macOS.
  static Future<void> showMiniaturizeButton() async {
    WindowManipulator.showMiniaturizeButton();
  }

  /// Hides the window's close button.
  ///
  /// This method is only available on macOS.
  static Future<void> hideCloseButton() async {
    WindowManipulator.hideCloseButton();
  }

  /// Shows the window's close button.
  ///
  /// The close button is visible by default.
  /// This method is only available on macOS.
  static Future<void> showCloseButton() async {
    WindowManipulator.showCloseButton();
  }

  /// Enables the window's zoom button.
  ///
  /// The zoom button is enabled by default.
  /// This method is only available on macOS.
  static Future<void> enableZoomButton() async {
    WindowManipulator.enableZoomButton();
  }

  /// Disables the window's zoom button.
  ///
  /// This method is only available on macOS.
  static Future<void> disableZoomButton() async {
    WindowManipulator.disableZoomButton();
  }

  /// Enables the window's miniaturize button.
  ///
  /// The miniaturize button is enabled by default.
  /// This method is only available on macOS.
  static Future<void> enableMiniaturizeButton() async {
    WindowManipulator.enableMiniaturizeButton();
  }

  /// Disables the window's miniaturize button.
  ///
  /// This method is only available on macOS.
  static Future<void> disableMiniaturizeButton() async {
    WindowManipulator.disableMiniaturizeButton();
  }

  /// Enables the window's close button.
  ///
  /// The close button is enabled by default.
  /// This method is only available on macOS.
  static Future<void> enableCloseButton() async {
    WindowManipulator.enableCloseButton();
  }

  /// Disables the window's close button.
  ///
  /// This method is only available on macOS.
  static Future<void> disableCloseButton() async {
    WindowManipulator.disableCloseButton();
  }

  /// Gets whether the window is currently being resized by the user.
  ///
  /// This method is only available on macOS.
  static Future<bool> isWindowInLiveResize() async {
    if (Platform.isMacOS) {
      return WindowManipulator.isWindowInLiveResize();
    }

    throw UnsupportedError(
      'isWindowInLiveResize() is only available on macOS.',
    );
  }

  /// Sets the window's alpha value.
  ///
  /// This method is only available on macOS.
  static Future<void> setWindowAlphaValue(double value) async {
    WindowManipulator.setWindowAlphaValue(value);

    return;
  }

  /// Gets if the window is visible.
  ///
  /// This method is only available on macOS.
  static Future<bool> isWindowVisible() async {
    return WindowManipulator.isWindowVisible();
  }

  /// Sets the window background color to the default (opaque) window color.
  ///
  /// This method mainly affects the window's titlebar.
  /// This method is only available on macOS.
  static Future<void> setWindowBackgroundColorToDefaultColor() async {
    WindowManipulator.setWindowBackgroundColorToDefaultColor();
  }

  /// Sets the window background color to clear.
  ///
  /// This method mainly affects the window's titlebar.
  /// This method is only available on macOS.
  static Future<void> setWindowBackgroundColorToClear() async {
    WindowManipulator.setWindowBackgroundColorToClear();
  }

  /// Sets the blur view state.
  ///
  /// This method is only available on macOS.
  static Future<void> setBlurViewState(MacOSBlurViewState state) async {
    final visualEffectViewState = BlurViewStateToVisualEffectViewStateConverter
        .convertBlurViewStateToVisualEffectViewState(state);
    WindowManipulator.setNSVisualEffectViewState(visualEffectViewState);
  }

  /// Adds a visual effect subview to the application's window and returns its
  /// ID.
  ///
  /// This method is only available on macOS.
  static Future<int> addVisualEffectSubview(
    VisualEffectSubviewProperties properties,
  ) async {
    if (Platform.isMacOS) {
      final newProperties =
          properties.toMacOSWindowUtilsVisualEffectSubviewProperties();

      return WindowManipulator.addVisualEffectSubview(newProperties);
    }

    return -1;
  }

  /// Updates the properties of a visual effect subview.
  ///
  /// This method is only available on macOS.
  static Future<void> updateVisualEffectSubviewProperties(
    int visualEffectSubviewId,
    VisualEffectSubviewProperties properties,
  ) async {
    final newProperties =
        properties.toMacOSWindowUtilsVisualEffectSubviewProperties();
    WindowManipulator.updateVisualEffectSubviewProperties(
      visualEffectSubviewId,
      newProperties,
    );
  }

  /// Removes a visual effect subview from the application's window.
  ///
  /// This method is only available on macOS.
  static Future<void> removeVisualEffectSubview(
    int visualEffectSubviewId,
  ) async {
    WindowManipulator.removeVisualEffectSubview(visualEffectSubviewId);
  }

  /// Overrides the brightness setting of the window (macOS only).
  static Future<void> overrideMacOSBrightness({
    required bool dark,
  }) async {
    WindowManipulator.overrideMacOSBrightness(dark: dark);
  }

  /// Adds a toolbar to the window (macOS only).
  static Future<void> addToolbar() async {
    WindowManipulator.addToolbar();
  }

  /// Removes the window's toolbar (macOS only).
  static Future<void> removeToolbar() async {
    WindowManipulator.removeToolbar();
  }

  /// Sets the window's toolbar style (macOS only).
  ///
  /// For this method to have an effect, the window needs to have had a toolbar
  /// added with the `addToolbar` method beforehand.
  ///
  /// Usage example:
  /// ```dart
  /// Window.addToolbar();
  /// Window.setToolbarStyle(MacOSToolbarStyle.unified);
  /// ```
  static Future<void> setToolbarStyle({
    required MacOSToolbarStyle toolbarStyle,
  }) async {
    final newToolbarStyle = MacOSToolbarStyleToWindowToolbarStyleConverter
        .convertMacOSToolbarStyleToWindowToolbarStyle(toolbarStyle);
    WindowManipulator.setToolbarStyle(toolbarStyle: newToolbarStyle);
  }

  /// Enables the window's shadow (macOS only).
  static Future<void> enableShadow() async {
    WindowManipulator.enableShadow();
  }

  /// Disables the window's shadow (macOS only).
  static Future<void> disableShadow() async {
    WindowManipulator.disableShadow();
  }

  /// Invalidates the window's shadow (macOS only).
  ///
  /// This is a fairly technical method and is included here for
  /// completeness' sake. Normally, it should not be necessary to use it.
  static Future<void> invalidateShadows() async {
    WindowManipulator.invalidateShadows();
  }

  /// Adds an empty mask image to the window's view (macOS only).
  ///
  /// This will effectively disable the `NSVisualEffectView`'s effect.
  ///
  /// **Warning:** It is recommended to disable the window's shadow using
  /// `Window.disableShadow()` when using this method. Keeping the shadow
  /// enabled when using an empty mask image can cause visual artifacts
  /// and performance issues.
  static Future<void> addEmptyMaskImage() async {
    WindowManipulator.addEmptyMaskImage();
  }

  /// Removes the window's mask image (macOS only).
  static Future<void> removeMaskImage() async {
    WindowManipulator.removeMaskImage();
  }

  /// Makes a window fully transparent (with no blur effect) (macOS only).
  ///
  /// This is a convenience method which executes:
  /// ```dart
  /// setWindowBackgroundColorToClear();
  /// makeTitlebarTransparent();
  /// addEmptyMaskImage();
  /// disableShadow();
  /// ```
  ///
  /// **Warning:** When the window is fully transparent, its highlight effect
  /// (the thin white line at the top of the window) is still visible. This is
  /// considered a bug and may change in a future version.
  static void makeWindowFullyTransparent() {
    setWindowBackgroundColorToClear();
    makeTitlebarTransparent();
    addEmptyMaskImage();
    disableShadow();
  }

  /// Makes the window ignore mouse events (macOS only).
  ///
  /// This method can be used to make parts of the window click-through, which
  /// may be desirable when used in conjunction with
  /// `Window.makeWindowFullyTransparent()`.
  static Future<void> ignoreMouseEvents() async {
    WindowManipulator.ignoreMouseEvents();
  }

  /// Makes the window acknowledge mouse events (macOS only).
  ///
  /// This method can be used to make parts of the window click-through, which
  /// may be desirable when used in conjunction with
  /// `Window.makeWindowFullyTransparent()`.
  static Future<void> acknowledgeMouseEvents() async {
    WindowManipulator.acknowledgeMouseEvents();
  }

  /// Sets the subtitle of the window (macOS only).
  ///
  /// To remove the subtitle, pass an empty string to this method.
  static Future<void> setSubtitle(String subtitle) async {
    WindowManipulator.setSubtitle(subtitle);
  }
}
