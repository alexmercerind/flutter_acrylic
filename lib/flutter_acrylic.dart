import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


final MethodChannel _channel = const MethodChannel('flutter_acrylic');
final Completer<void> _create = new Completer<void>();


/// Blur effects.
enum BlurEffect {
  /// Default window background. No blur effect.
  disabled,
  /// Gradient window background.
  gradient,
  /// Transparent window background.
  transparent,
  /// Aero blur effect like Windows 7.
  aero,
  /// Acrylic blur effect. Requires Windows 10 version 1803 or higher.
  acrylic
}


/// **FlutterAcrylic**
/// 
/// Flutter plugin to blur the window background.
/// 
/// Exposes undocumented `SetWindowCompositionAttribute` API from `user32.dll` on Windows.
/// 
/// Example
/// ```dart
/// void main() {
///   WidgetsFlutterBinding.ensureInitialized();
///   FlutterAcrylic.create();
///   runApp(MyApp());
/// }
/// 
/// ...
/// await FlutterAcrylic.set(
///   mode: AcrylicMode.aero,
///   gradientColor: Colors.white.withOpacity(0.2)
/// );
/// ```
/// 
class FlutterAcrylic {

  /// Initializes [FlutterAcrylic] plugin.
  /// 
  /// Must be called before calling any other method of the class.
  /// 
  /// ```dart
  /// await FlutterAcrylic.create();
  /// ```
  /// 
  static Future<void> create() async {
    await _channel.invokeMethod('FlutterAcrylic.create');
    _create.complete();
  }

  /// Sets [AcrylicMode] for the window.
  /// 
  /// ```dart
  /// await FlutterAcrylic.set(
  ///   mode: AcrylicMode.acrylic,
  ///   gradientColor: Colors.black.withOpacity(0.2)
  /// );
  /// ```
  /// 
  static Future<void> set({required BlurEffect effect, Color gradientColor: Colors.white}) async {
    await _create.future;
    await _channel.invokeMethod(
      'FlutterAcrylic.set',
      {
        'effect': effect.index,
        'gradientColor': {
          'R': gradientColor.red,
          'G': gradientColor.green,
          'B': gradientColor.blue,
          'A': gradientColor.alpha
        }
      }
    );
  }
}
