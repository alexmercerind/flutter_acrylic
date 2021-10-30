library flutter_acrylic;

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

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

/// Overrides the brightness setting of the window (macOS only).
const _kOverrideMacOSBrightness = "OverrideMacOSBrightness";

final MethodChannel _kChannel = const MethodChannel(_kChannelName);
final Completer<void> _kCompleter = new Completer<void>();

/// Available effects for the Flutter window.
enum WindowEffect {
  /// Default window background.
  /// Works on Windows & Linux.
  disabled,

  /// Solid colored window background.
  /// Works on Windows & Linux.
  solid,

  /// Transparent window background.
  /// Works on Windows & Linux.
  transparent,

  /// Aero glass effect.
  /// Windows Vista & Windows 7 like glossy blur effect.
  /// Works only on Windows.
  aero,

  /// Acrylic is a type of brush that creates a translucent texture. You can apply acrylic to app surfaces to add depth and help establish a visual hierarchy.
  /// Works only on Windows 10 version 1803 or higher.
  acrylic,

  /// Mica is an opaque, dynamic material that incorporates theme and desktop wallpaper to paint the background of long-lived windows.
  /// Works only on Windows 11 or greater.
  mica,
  
  /// The material for a window’s titlebar.
  /// Works only on macOS.
  titlebar,
  
  /// The material used to indicate a selection.
  /// Works only on macOS.
  selection,
  
  /// The material for menus.
  /// Works only on macOS.
  menu,
  
  /// The material for the background of popover windows.
  /// Works only on macOS.
  popover,
  
  /// The material for the background of window sidebars.
  /// Works only on macOS.
  sidebar,
  
  /// The material for in-line header or footer views.
  /// Works only on macOS.
  headerView,
  
  /// The material for the background of sheet windows.
  /// Works only on macOS.
  sheet,
  
  /// The material for the background of opaque windows.
  /// Works only on macOS.
  windowBackground,
  
  /// The material for the background of heads-up display (HUD) windows.
  /// Works only on macOS.
  hudWindow,
  
  /// The material for the background of a full-screen modal interface.
  /// Works only on macOS.
  fullScreenUI,
  
  /// The material for the background of a tool tip.
  /// Works only on macOS.
  toolTip,
  
  /// The material for the background of opaque content.
  /// Works only on macOS.
  contentBackground,
  
  /// The material to show under a window's background.
  /// Works only on macOS.
  underWindowBackground,
  
  /// The material for the area behind the pages of a document.
  /// Works only on macOS.
  underPageBackground,
}

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

  /// Hides window controls. (Currently not supported on macOS)
  static Future<void> hideWindowControls() async {
    await _kChannel.invokeMethod(_kHideWindowControls);
  }

  /// Shows window controls. (Currently not supported on macOS)
  static Future<void> showWindowControls() async {
    await _kChannel.invokeMethod(_kShowWindowControls);
  }

  /// Makes the Flutter window fullscreen. (Currently not supported on macOS)
  static Future<void> enterFullscreen() async {
    await _kChannel.invokeMethod(_kEnterFullscreen);
  }

  /// Restores the Flutter window back to normal from fullscreen mode. (Currently not supported on macOS)
  static Future<void> exitFullscreen() async {
    await _kChannel.invokeMethod(_kExitFullscreen);
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
}
