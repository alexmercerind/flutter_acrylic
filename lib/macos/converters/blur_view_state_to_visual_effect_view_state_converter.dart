import 'package:flutter_acrylic/macos/macos_blur_view_state.dart';
import 'package:macos_window_utils/macos/ns_visual_effect_view_state.dart';

class BlurViewStateToVisualEffectViewStateConverter {
  BlurViewStateToVisualEffectViewStateConverter._();

  static NSVisualEffectViewState convertBlurViewStateToVisualEffectViewState(
    MacOSBlurViewState blurViewState,
  ) {
    switch (blurViewState) {
      case MacOSBlurViewState.active:
        return NSVisualEffectViewState.active;
      case MacOSBlurViewState.inactive:
        return NSVisualEffectViewState.inactive;
      case MacOSBlurViewState.followsWindowActiveState:
        return NSVisualEffectViewState.followsWindowActiveState;
    }
  }
}
