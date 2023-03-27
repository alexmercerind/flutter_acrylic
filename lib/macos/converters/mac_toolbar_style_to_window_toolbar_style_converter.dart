import 'package:flutter_acrylic/macos/macos_toolbar_style.dart';
import 'package:macos_window_utils/macos/ns_window_toolbar_style.dart';

class MacOSToolbarStyleToWindowToolbarStyleConverter {
  MacOSToolbarStyleToWindowToolbarStyleConverter._();

  static NSWindowToolbarStyle convertMacOSToolbarStyleToWindowToolbarStyle(
    MacOSToolbarStyle toolbarStyle,
  ) {
    switch (toolbarStyle) {
      case MacOSToolbarStyle.automatic:
        return NSWindowToolbarStyle.automatic;
      case MacOSToolbarStyle.expanded:
        return NSWindowToolbarStyle.expanded;
      case MacOSToolbarStyle.preference:
        return NSWindowToolbarStyle.preference;
      case MacOSToolbarStyle.unified:
        return NSWindowToolbarStyle.unified;
      case MacOSToolbarStyle.unifiedCompact:
        return NSWindowToolbarStyle.unifiedCompact;
    }
  }
}
