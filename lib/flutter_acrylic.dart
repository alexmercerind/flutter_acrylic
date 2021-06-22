import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

final MethodChannel _channel = const MethodChannel('flutter_acrylic');
final Completer<void> _create = new Completer<void>();

/// Acrylic effects.
enum AcrylicEffect {
  /// Default window background. No blur effect.
  disabled,

  /// Solid window background.
  solid,

  /// Transparent window background.
  transparent,

  /// Aero blur effect. Windows Vista & Windows 7 like.
  aero,

  /// Acrylic blur effect. Requires Windows 10 version 1803 or higher.
  acrylic
}

/// **Acrylic**
///
/// _Example_
/// ```dart
/// void main() {
///   WidgetsFlutterBinding.ensureInitialized();
///   Acrylic.initialize();
///   runApp(MyApp());
/// }
///
/// ...
/// await Acrylic.setEffect(
///   effect: AcrylicEffect.aero,
///   gradientColor: Colors.white.withOpacity(0.2)
/// );
/// ```
///
class Acrylic {
  /// Initializes [Acrylic] class.
  ///
  /// Must be called before calling [Acrylic.setEffect].
  ///
  /// _Example_
  /// ```dart
  /// await Acrylic.initialize();
  /// ```
  ///
  static Future<void> initialize({bool drawCustomFrame: false}) async {
    await _channel.invokeMethod(
        'Acrylic.initialize', {'drawCustomFrame': drawCustomFrame});
    _create.complete();
  }

  /// Sets [BlurEffect] for the window.
  ///
  /// Uses undocumented `SetWindowCompositionAttribute` API from `user32.dll` on Windows.
  ///
  /// Enables aero, acrylic or other transparency on the Flutter instance window.
  ///
  /// _Example_
  /// ```dart
  /// await FlutterAcrylic.setEffect(
  ///   effect: AcrylicEffect.acrylic,
  ///   gradientColor: Colors.black.withOpacity(0.2)
  /// );
  /// ```
  ///
  static Future<void> setEffect(
      {required AcrylicEffect effect,
      Color gradientColor: Colors.white}) async {
    await _create.future;
    await _channel.invokeMethod('Acrylic.setEffect', {
      'effect': effect.index,
      'gradientColor': {
        'R': gradientColor.red,
        'G': gradientColor.green,
        'B': gradientColor.blue,
        'A': gradientColor.alpha
      }
    });
  }
}

/// **Window**
///
/// General utilities to control Flutter instance window.
///
class Window {
  /// Makes the Flutter window fullscreen.
  static Future<void> enterFullscreen() async {
    await _channel.invokeMethod('Window.enterFullscreen');
  }

  /// Restores the Flutter window back to normal from fullscreen mode.
  static Future<void> exitFullscreen() async {
    await _channel.invokeMethod('Window.exitFullscreen');
  }
}
