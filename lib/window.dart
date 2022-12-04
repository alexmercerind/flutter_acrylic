import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/macos/macos_blur_view_state.dart';
import 'package:flutter_acrylic/macos/macos_toolbar_style.dart';
import 'package:flutter_acrylic/macos/visual_effect_view_properties.dart';
import 'package:flutter_acrylic/window_effect.dart';

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

/// Gets the height of the titlebar.
const _kGetTitlebarHeight = "GetTitlebarHeight";

/// Overrides the brightness setting of the window (macOS only).
const _kOverrideMacOSBrightness = "OverrideMacOSBrightness";

/// (macOS only).
const _kSetDocumentEdited = "SetDocumentEdited";

/// (macOS only).
const _kSetDocumentUnedited = "SetDocumentUnedited";

/// (macOS only).
const _kSetRepresentedFile = "SetRepresentedFile";

/// (macOS only).
const _kSetRepresentedURL = "SetRepresentedURL";

/// (macOS only).
const _kHideTitle = "HideTitle";

/// (macOS only).
const _kShowTitle = "ShowTitle";

/// (macOS only).
const _kMakeTitlebarTransparent = "MakeTitlebarTransparent";

/// (macOS only).
const _kMakeTitlebarOpaque = "MakeTitlebarOpaque";

/// (macOS only).
const _kEnableFullSizeContentView = "EnableFullSizeContentView";

/// (macOS only).
const _kDisableFullSizeContentView = "DisableFullSizeContentView";

/// (macOS only).
const _kZoomWindow = "ZoomWindow";

/// (macOS only).
const _kUnzoomWindow = "UnzoomWindow";

/// (macOS only).
const _kIsWindowZoomed = "IsWindowZoomed";

/// (macOS only).
const _kIsWindowFullscreened = "IsWindowFullscreened";

/// (macOS only).
const _kHideZoomButton = "HideZoomButton";

/// (macOS only).
const _kShowZoomButton = "ShowZoomButton";

/// (macOS only).
const _kHideMiniaturizeButton = "HideMiniaturizeButton";

/// (macOS only).
const _kShowMiniaturizeButton = "ShowMiniaturizeButton";

/// (macOS only).
const _kHideCloseButton = "HideCloseButton";

/// (macOS only).
const _kShowCloseButton = "ShowCloseButton";

/// (macOS only).
const _kEnableZoomButton = "EnableZoomButton";

/// (macOS only).
const _kDisableZoomButton = "DisableZoomButton";

/// (macOS only).
const _kEnableMiniaturizeButton = "EnableMiniaturizeButton";

/// (macOS only).
const _kDisableMiniaturizeButton = "DisableMiniaturizeButton";

/// (macOS only).
const _kEnableCloseButton = "EnableCloseButton";

/// (macOS only).
const _kDisableCloseButton = "DisableCloseButton";

/// (macOS only).
const _kIsWindowInLiveResize = "IsWindowInLiveResize";

/// (macOS only).
const _kSetWindowAlphaValue = "SetWindowAlphaValue";

/// (macOS only).
const _kIsWindowVisible = "IsWindowVisible";

/// (macOS only).
const _kSetWindowBackgroundColorToDefaultColor =
    "SetWindowBackgroundColorToDefaultColor";

/// (macOS only).
const _kSetWindowBackgroundColorToClear = "SetWindowBackgroundColorToClear";

/// (macOS only).
const _kSetBlurViewState = "SetBlurViewState";

/// (macOS only).
const _kAddVisualEffectSubview = "AddVisualEffectSubview";

/// (macOS only).
const _kUpdateVisualEffectSubviewProperties =
    "UpdateVisualEffectSubviewProperties";

/// (macOS only).
const _kRemoveVisualEffectSubview = "RemoveVisualEffectSubview";

/// (macOS only).
const _kAddToolbar = "AddToolbar";

/// (macOS only).
const _kRemoveToolbar = "RemoveToolbar";

/// (macOS only).
const _kSetToolbarStyle = "SetToolbarStyle";

/// (macOS only)
const _kEnableShadow = "EnableShadow";

/// (macOS only)
const _kDisableShadow = "DisableShadow";

/// (macOS only)
const _kInvalidateShadows = "InvalidateShadows";

/// (macOS only)
const _kAddEmptyMaskImage = "AddEmptyMaskImage";

/// (macOS only)
const _kRemoveMaskImage = "RemoveMaskImage";

/// (macOS only)
const _kIgnoreMouseEvents = "IgnoreMouseEvents";

/// (macOS only)
const _kAcknowledgeMouseEvents = "AcknowledgeMouseEvents";

final MethodChannel _kChannel = const MethodChannel(_kChannelName);
final Completer<void> _kCompleter = new Completer<void>();

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
    await _kChannel.invokeMethod(_kInitialize);
    _kCompleter.complete();
  }

  /// Sets specified effect for the window.
  ///
  /// When using [WindowEffect.mica], [dark] argument can be used to switch between light or dark mode of Mica.
  ///
  /// When using [WindowEffect.acrylic], [WindowEffect.aero], [WindowEffect.disabled], [WindowEffect.solid] or [WindowEffect.transparent],
  /// [color] argument can be used to change the resulting tint (or color) of the window background.
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
    Color color: Colors.transparent,
    bool dark: true,
  }) async {
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
    await _kChannel.invokeMethod(_kHideWindowControls);
  }

  /// Shows window controls.
  static Future<void> showWindowControls() async {
    await _kChannel.invokeMethod(_kShowWindowControls);
  }

  /// Makes the Flutter window fullscreen.
  static Future<void> enterFullscreen() async {
    await _kChannel.invokeMethod(_kEnterFullscreen);
  }

  /// Restores the Flutter window back to normal from fullscreen mode.
  static Future<void> exitFullscreen() async {
    await _kChannel.invokeMethod(_kExitFullscreen);
  }

  /// Gets the height of the titlebar.
  ///
  /// This value is used to determine the [[TitlebarSafeArea]] widget.
  /// If the full-size content view is enabled, this value will be the height of the titlebar.
  /// If the full-size content view is disabled, this value will be 0.
  /// This value is only available on macOS.
  static Future<double> getTitlebarHeight() async {
    if (!Platform.isMacOS) {
      throw new UnsupportedError(
          'getTitlebarHeight() is only available on macOS.');
    }

    await _kCompleter.future;
    return await _kChannel.invokeMethod(_kGetTitlebarHeight);
  }

  /// Sets the document to be edited.
  ///
  /// This will change the appearance of the close button on the titlebar.
  /// This method is only available on macOS.
  static Future<void> setDocumentEdited() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kSetDocumentEdited);
  }

  /// Sets the document to be unedited.
  ///
  /// This method is only available on macOS.
  static Future<void> setDocumentUnedited() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kSetDocumentUnedited);
  }

  /// Sets the represented file of the window.
  ///
  /// This method is only available on macOS.
  static Future<void> setRepresentedFilename(String filename) async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kSetRepresentedFile, {
      'filename': filename,
    });
  }

  /// Sets the represented URL of the window.
  ///
  /// This method is only available on macOS.
  static Future<void> setRepresentedUrl(String url) async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kSetRepresentedURL, {
      'url': url,
    });
  }

  /// Hides the titlebar of the window.
  ///
  /// This method is only available on macOS.
  static Future<void> hideTitle() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kHideTitle);
  }

  /// Shows the titlebar of the window.
  ///
  /// This method is only available on macOS.
  static Future<void> showTitle() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kShowTitle);
  }

  /// Makes the window's titlebar transparent.
  ///
  /// This method is only available on macOS.
  static Future<void> makeTitlebarTransparent() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kMakeTitlebarTransparent);
  }

  /// Makes the window's titlebar opaque.
  ///
  /// This method is only available on macOS.
  static Future<void> makeTitlebarOpaque() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kMakeTitlebarOpaque);
  }

  /// Enables the window's full-size content view.
  ///
  /// This expands the area that Flutter can draw to to fill the entire window.
  /// It is recommended to enable the full-size content view when making
  /// the titlebar transparent.
  /// This method is only available on macOS.
  static Future<void> enableFullSizeContentView() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kEnableFullSizeContentView);
  }

  /// Disables the window's full-size content view.
  ///
  /// This method is only available on macOS.
  static Future<void> disableFullSizeContentView() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kDisableFullSizeContentView);
  }

  /// Zooms the window.
  ///
  /// This method is only available on macOS.
  static Future<void> zoomWindow() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kZoomWindow);
  }

  /// Unzooms the window.
  ///
  /// This method is only available on macOS.
  static Future<void> unzoomWindow() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kUnzoomWindow);
  }

  /// Returns if the window is zoomed.
  ///
  /// This method is only available on macOS.
  static Future<bool> isWindowZoomed() async {
    if (!Platform.isMacOS) {
      throw new UnsupportedError(
          'isWindowZoomed() is only available on macOS.');
    }

    await _kCompleter.future;
    return await _kChannel.invokeMethod(_kIsWindowZoomed);
  }

  /// Returns if the window is fullscreened.
  ///
  /// This method is only available on macOS.
  static Future<bool> isWindowFullscreened() async {
    if (!Platform.isMacOS) {
      throw new UnsupportedError(
          'isWindowFullscreened() is only available on macOS.');
    }

    await _kCompleter.future;
    return await _kChannel.invokeMethod(_kIsWindowFullscreened);
  }

  /// Hides the window's zoom button.
  ///
  /// This method is only available on macOS.
  static Future<void> hideZoomButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kHideZoomButton);
  }

  /// Shows the window's zoom button.
  ///
  /// The zoom button is visible by default.
  /// This method is only available on macOS.
  static Future<void> showZoomButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kShowZoomButton);
  }

  /// Hides the window's miniaturize button.
  ///
  /// This method is only available on macOS.
  static Future<void> hideMiniaturizeButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kHideMiniaturizeButton);
  }

  /// Shows the window's miniaturize button.
  ///
  /// The miniaturize button is visible by default.
  /// This method is only available on macOS.
  static Future<void> showMiniaturizeButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kShowMiniaturizeButton);
  }

  /// Hides the window's close button.
  ///
  /// This method is only available on macOS.
  static Future<void> hideCloseButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kHideCloseButton);
  }

  /// Shows the window's close button.
  ///
  /// The close button is visible by default.
  /// This method is only available on macOS.
  static Future<void> showCloseButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kShowCloseButton);
  }

  /// Enables the window's zoom button.
  ///
  /// The zoom button is enabled by default.
  /// This method is only available on macOS.
  static Future<void> enableZoomButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kEnableZoomButton);
  }

  /// Disables the window's zoom button.
  ///
  /// This method is only available on macOS.
  static Future<void> disableZoomButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kDisableZoomButton);
  }

  /// Enables the window's miniaturize button.
  ///
  /// The miniaturize button is enabled by default.
  /// This method is only available on macOS.
  static Future<void> enableMiniaturizeButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kEnableMiniaturizeButton);
  }

  /// Disables the window's miniaturize button.
  ///
  /// This method is only available on macOS.
  static Future<void> disableMiniaturizeButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kDisableMiniaturizeButton);
  }

  /// Enables the window's close button.
  ///
  /// The close button is enabled by default.
  /// This method is only available on macOS.
  static Future<void> enableCloseButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kEnableCloseButton);
  }

  /// Disables the window's close button.
  ///
  /// This method is only available on macOS.
  static Future<void> disableCloseButton() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kDisableCloseButton);
  }

  /// Gets whether the window is currently being resized by the user.
  ///
  /// This method is only available on macOS.
  static Future<bool> isWindowInLiveResize() async {
    if (!Platform.isMacOS) {
      throw UnsupportedError(
          'isWindowInLiveResize() is only available on macOS.');
    }

    await _kCompleter.future;
    return await _kChannel.invokeMethod(_kIsWindowInLiveResize);
  }

  /// Sets the window's alpha value.
  ///
  /// This method is only available on macOS.
  static Future<void> setWindowAlphaValue(double value) async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kSetWindowAlphaValue, <String, dynamic>{
      'value': value,
    });
  }

  /// Gets if the window is visible.
  ///
  /// This method is only available on macOS.
  static Future<bool> isWindowVisible() async {
    if (!Platform.isMacOS) {
      throw UnsupportedError('isWindowVisible() is only available on macOS.');
    }

    await _kCompleter.future;
    return await _kChannel.invokeMethod(_kIsWindowVisible);
  }

  /// Sets the window background color to the default (opaque) window color.
  ///
  /// This method mainly affects the window's titlebar.
  /// This method is only available on macOS.
  static Future<void> setWindowBackgroundColorToDefaultColor() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kSetWindowBackgroundColorToDefaultColor);
  }

  /// Sets the window background color to clear.
  ///
  /// This method mainly affects the window's titlebar.
  /// This method is only available on macOS.
  static Future<void> setWindowBackgroundColorToClear() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kSetWindowBackgroundColorToClear);
  }

  /// Sets the blur view state.
  ///
  /// This method is only available on macOS.
  static Future<void> setBlurViewState(MacOSBlurViewState state) async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kSetBlurViewState, <String, dynamic>{
      'state': state.toString().split('.').last,
    });
  }

  /// Adds a visual effect subview to the application's window and returns its ID.
  ///
  /// This method is only available on macOS.
  static Future<int> addVisualEffectSubview(
      VisualEffectSubviewProperties properties) async {
    await _kCompleter.future;
    return await _kChannel.invokeMethod(
        _kAddVisualEffectSubview, properties.toMap());
  }

  /// Updates the properties of a visual effect subview.
  ///
  /// This method is only available on macOS.
  static Future<void> updateVisualEffectSubviewProperties(
      int visualEffectSubviewId,
      VisualEffectSubviewProperties properties) async {
    await _kCompleter.future;
    await _kChannel
        .invokeMethod(_kUpdateVisualEffectSubviewProperties, <String, dynamic>{
      'visualEffectSubviewId': visualEffectSubviewId,
      ...properties.toMap(),
    });
  }

  /// Removes a visual effect subview from the application's window.
  ///
  /// This method is only available on macOS.
  static Future<void> removeVisualEffectSubview(
      int visualEffectSubviewId) async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kRemoveVisualEffectSubview, <String, dynamic>{
      'visualEffectSubviewId': visualEffectSubviewId,
    });
  }

  /// Overrides the brightness setting of the window (macOS only).
  static Future<void> overrideMacOSBrightness({
    required bool dark,
  }) async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(
      _kOverrideMacOSBrightness,
      {
        'dark': dark,
      },
    );
  }

  /// Adds a toolbar to the window (macOS only).
  static Future<void> addToolbar() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kAddToolbar, {});
  }

  /// Removes the window's toolbar (macOS only).
  static Future<void> removeToolbar() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kRemoveToolbar, {});
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
  static Future<void> setToolbarStyle(
      {required MacOSToolbarStyle toolbarStyle}) async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kSetToolbarStyle, {
      'toolbarStyle': toolbarStyle.name,
    });
  }

  /// Enables the window's shadow (macOS only).
  static Future<void> enableShadow() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kEnableShadow, {});
  }

  /// Disables the window's shadow (macOS only).
  static Future<void> disableShadow() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kDisableShadow, {});
  }

  /// Invalidates the window's shadow (macOS only).
  static Future<void> invalidateShadows() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kInvalidateShadows, {});
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
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kAddEmptyMaskImage, {});
  }

  /// Removes the window's mask image (macOS only).
  static Future<void> removeMaskImage() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kRemoveMaskImage, {});
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
  static Future<void> ignoreMouseEvents() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kIgnoreMouseEvents, {});
  }

  /// Makes the window acknowledge mouse events (macOS only).
  static Future<void> acknowledgeMouseEvents() async {
    await _kCompleter.future;
    await _kChannel.invokeMethod(_kAcknowledgeMouseEvents, {});
  }
}
