import 'package:flutter_acrylic/flutter_acrylic.dart';

/// Visual effect subview properties (macOS only).
///
/// All values may be set to null if they should not be overwritten.
class VisualEffectSubviewProperties {
  /// The width of the subview's frame.
  final double? frameWidth;

  /// The height of the subview's frame.
  final double? frameHeight;

  /// The x position of the subview's frame.
  final double? frameX;

  /// The y position of the subview's frame, starting at the bottom of the window.
  final double? frameY;

  /// The alpha value of the subview.
  final double? alphaValue;

  /// The corner Radius of the subview.
  final double? cornerRadius;

  /// A bitmask indicating which corners should follow the `cornerRadius` property.
  final int? cornerMask;

  /// The effect/material of the subview.
  final WindowEffect? effect;

  /// The state of the subview.
  final MacOSBlurViewState? state;

  VisualEffectSubviewProperties(
      {this.frameWidth,
      this.frameHeight,
      this.frameX,
      this.frameY,
      this.alphaValue,
      this.cornerRadius,
      this.cornerMask,
      this.effect,
      this.state});

  static const topLeftCorner = 1 << 0;
  static const topRightCorner = 1 << 1;
  static const bottomRightCorner = 1 << 2;
  static const bottomLeftCorner = 1 << 3;

  bool get isEmpty =>
      frameHeight == null &&
      frameHeight == null &&
      frameX == null &&
      frameY == null &&
      alphaValue == null &&
      cornerRadius == null &&
      cornerMask == null &&
      effect == null &&
      state == null;

  /// Creates a map in which the properties of this instance are contained.
  ///
  /// Only non-null properties will be present in that map.
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (frameWidth != null) {
      result['frameWidth'] = frameWidth;
    }

    if (frameHeight != null) {
      result['frameHeight'] = frameHeight;
    }

    if (frameX != null) {
      result['frameX'] = frameX;
    }

    if (frameY != null) {
      result['frameY'] = frameY;
    }

    if (alphaValue != null) {
      result['alphaValue'] = alphaValue;
    }

    if (cornerRadius != null) {
      result['cornerRadius'] = cornerRadius;
    }

    if (cornerMask != null) {
      result['cornerMask'] = cornerMask;
    }

    if (effect != null) {
      result['effect'] = effect!.index;
    }

    if (state != null) {
      result['state'] = state!.name;
    }

    return result;
  }

  @override
  operator ==(Object other) {
    return other is VisualEffectSubviewProperties &&
        frameWidth == other.frameWidth &&
        frameHeight == other.frameHeight &&
        frameX == other.frameX &&
        frameY == other.frameY &&
        alphaValue == other.alphaValue &&
        cornerRadius == other.cornerRadius &&
        cornerMask == other.cornerMask &&
        effect == other.effect &&
        state == other.state;
  }

  @override
  int get hashCode {
    return frameWidth.hashCode ^
        frameHeight.hashCode ^
        frameX.hashCode ^
        frameY.hashCode ^
        alphaValue.hashCode ^
        cornerRadius.hashCode ^
        cornerMask.hashCode ^
        effect.hashCode ^
        state.hashCode;
  }

  @override
  String toString() {
    return '$frameWidth $frameHeight $frameX $frameY $alphaValue $cornerRadius $cornerMask $effect $state';
  }
}
