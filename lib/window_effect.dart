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

  /// Acrylic is a type of brush that creates a translucent texture. You can
  /// apply acrylic to app surfaces to add depth and help establish a visual
  /// hierarchy.
  /// Works only on Windows 10 version 1803 or higher.
  acrylic,

  /// Mica is an opaque, dynamic material that incorporates theme and desktop
  /// wallpaper to paint the background of long-lived windows.
  /// Works only on Windows 11 or greater.
  mica,

  /// Tabbed is a Mica like material that incorporates theme and desktop
  /// wallpaper, but having more transparency.
  /// Works only on later Windows 11 versions (builds higher than 22523).
  tabbed,

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
