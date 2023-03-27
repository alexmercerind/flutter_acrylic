import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:macos_window_utils/macos/ns_visual_effect_view_material.dart';

class WindowEffectToMaterialConverter {
  WindowEffectToMaterialConverter._();

  static NSVisualEffectViewMaterial convertWindowEffectToMaterial(
    WindowEffect windowEffect,
  ) {
    switch (windowEffect.index) {
      case 0: // disabled
        return NSVisualEffectViewMaterial.windowBackground;

      case 1: // solid
        return NSVisualEffectViewMaterial.windowBackground;

      case 2: // transparent
        return NSVisualEffectViewMaterial.underWindowBackground;

      case 3: // aero
        return NSVisualEffectViewMaterial.hudWindow;

      case 4: // acrylic
        return NSVisualEffectViewMaterial.fullScreenUI;

      case 5: // mica
        return NSVisualEffectViewMaterial.headerView;

      case 6: // tabbed
        return NSVisualEffectViewMaterial.headerView;

      /* The following effects are macOS-only: */
      case 7: // titlebar
        return NSVisualEffectViewMaterial.titlebar;

      case 8: // selection
        return NSVisualEffectViewMaterial.selection;

      case 9: // menu
        return NSVisualEffectViewMaterial.menu;

      case 10: // popover
        return NSVisualEffectViewMaterial.popover;

      case 11: // sidebar
        return NSVisualEffectViewMaterial.sidebar;

      case 12: // headerView
        return NSVisualEffectViewMaterial.headerView;

      case 13: // sheet
        return NSVisualEffectViewMaterial.sheet;

      case 14: // windowBackground
        return NSVisualEffectViewMaterial.windowBackground;

      case 15: // hudWindow
        return NSVisualEffectViewMaterial.hudWindow;

      case 16: // fullScreenUI
        return NSVisualEffectViewMaterial.fullScreenUI;

      case 17: // toolTip
        return NSVisualEffectViewMaterial.toolTip;

      case 18: // contentBackground
        return NSVisualEffectViewMaterial.contentBackground;

      case 19: // underWindowBackground
        return NSVisualEffectViewMaterial.underWindowBackground;

      case 20: // underPageBackground
        return NSVisualEffectViewMaterial.underPageBackground;

      default:
        return NSVisualEffectViewMaterial.windowBackground;
    }
  }
}
