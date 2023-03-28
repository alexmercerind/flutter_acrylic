<h1 align="center"><a href="https://github.com/alexmercerind/flutter_acrylic">flutter_acrylic</a></h1>
<p align="center">Window acrylic, mica & transparency effects for Flutter on Windows, macOS & Linux</p>

## Install

Mention in your `pubspec.yaml`.

```yaml
dependencies:
  ...
  flutter_acrylic: ^1.1.0
```

## Example

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/mug8J4efWu.gif?raw=true)

_Example app running on Microsoft Windows 11 (pre-compiled release mode x64 executable available to test in the "Releases" tab)._

## Platforms

| Platform | Status | Maintainer                                              |
| -------- | ------ | ------------------------------------------------------- |
| Windows  | ✅      | [Hitesh Kumar Saini](https://github.com/alexmercerind)  |
| macOS    | ✅      | [Adrian Samoticha](https://github.com/Adrian-Samoticha) |
| Linux    | ✅      | [Hitesh Kumar Saini](https://github.com/alexmercerind)  |

## Docs

### Initialize Plugin

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  runApp(MyApp());
}
```

### Apply Effects

```dart
await Window.setEffect(
  effect: WindowEffect.acrylic,
  color: Color(0xCC222222),
);
```

```dart
await Window.setEffect(
  effect: WindowEffect.mica,
  dark: true,
);
```

## Available Effects

| Effect                               | Description                                                                                                                                                                                               | Windows | macOS | Linux |
| ------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- | ----- | ----- |
| `WindowEffect.transparent`           | Transparent window background.                                                                                                                                                                            | ✅       | ✅     | ✅     |
| `WindowEffect.disabled`              | Default window background.                                                                                                                                                                                | ✅       | ✅     | ✅     |
| `WindowEffect.solid`                 | Solid colored window background.                                                                                                                                                                          | ✅       | ✅     | ✅     |
| `WindowEffect.aero`                  | Aero glass effect. Windows Vista & Windows 7 like glossy blur effect.                                                                                                                                     | ✅       | ✅     |       |
| `WindowEffect.acrylic`               | Acrylic is a type of brush that creates a translucent texture. You can apply acrylic to app surfaces to add depth and help establish a visual hierarchy. Works only on Windows 10 version 1803 or higher. | ✅       | ✅     |       |
| `WindowEffect.mica`                  | Mica is an opaque, dynamic material that incorporates theme and desktop wallpaper to paint the background of long-lived windows. Works only on Windows 11 or greater.                                     | ✅       | ✅     |       |
| `WindowEffect.tabbed`                | Tabbed is a Mica like material that incorporates theme and desktop wallpaper, but is more sensitive to desktop wallpaper color. Works only on later Windows 11 versions (builds higher than 22523).       | ✅       | ✅     |       |
| `WindowEffect.titlebar`              | The material for a window’s titlebar.                                                                                                                                                                     |         | ✅     |       |
| `WindowEffect.menu`                  | The material for menus.                                                                                                                                                                                   |         | ✅     |       |
| `WindowEffect.popover`               | The material for the background of popover windows.                                                                                                                                                       |         | ✅     |       |
| `WindowEffect.sidebar`               | The material for the background of window sidebars.                                                                                                                                                       |         | ✅     |       |
| `WindowEffect.headerView`            | The material for in-line header or footer views.                                                                                                                                                          |         | ✅     |       |
| `WindowEffect.sheet`                 | The material for the background of sheet windows.                                                                                                                                                         |         | ✅     |       |
| `WindowEffect.windowBackground`      | The material for the background of opaque windows.                                                                                                                                                        |         | ✅     |       |
| `WindowEffect.hudWindow`             | The material for the background of heads-up display (HUD) windows.                                                                                                                                        |         | ✅     |       |
| `WindowEffect.fullScreenUI`          | The material for the background of a full-screen modal interface.                                                                                                                                         |         | ✅     |       |
| `WindowEffect.toolTip`               | The material for the background of a tool tip.                                                                                                                                                            |         | ✅     |       |
| `WindowEffect.contentBackground`     | The material for the background of opaque content.                                                                                                                                                        |         | ✅     |       |
| `WindowEffect.underWindowBackground` | The material to show under a window's background.                                                                                                                                                         |         | ✅     |       |
| `WindowEffect.underPageBackground`   | The material for the area behind the pages of a document.                                                                                                                                                 |         | ✅     |       |


_Windows 10 versions higher than 1803 & all Windows 11 versions are supported by the plugin, although not all effects might be available to a particular Windows version. See [pinned issues](https://github.com/alexmercerind/flutter_acrylic/issues) if you encounter some problem or feel free to file one yourself._


### Other Utilities

- Enter Fullscreen

```dart
Window.enterFullscreen();
```

- Exit Fullscreen

```dart
Window.exitFullscreen();
```

- Hide Controls

```dart
Window.hideWindowControls();
```

- Show Controls

```dart
Window.showWindowControls();
```

### macOS Specific

Get the height of the titlebar when the full-size content view is enabled.

```dart
final titlebarHeight = Window.getTitlebarHeight();
```

Set the document to be edited.

```dart
Window.setDocumentEdited();
```

Set the document to be unedited.

```dart
Window.setDocumentUnedited();
```

Set the represented file of the window.

```dart
Window.setRepresentedFilename('path/to/file.txt');
```

Set the represented URL of the window.

```dart
Window.setRepresentedUrl('https://flutter.dev');
```

Hide the titlebar of the window.

```dart
Window.hideTitle();
```

Show the titlebar of the window.

```dart
Window.showTitle();
```

Make the window's titlebar transparent.

```dart
Window.makeTitlebarTransparent();
```

Make the window's titlebar opaque.

```dart
Window.makeTitlebarOpaque();
```

Enable the window's full-size content view.
It is recommended to enable the full-size content view when making
the titlebar transparent.

```dart
Window.enableFullSizeContentView();
```

Disable the window's full-size content view.

```dart
Window.disableFullSizeContentView();
```

Zoom the window.

```dart
Window.zoomWindow();
```

Unzoom the window.

```dart
Window.unzoomWindow();
```

Get if the window is zoomed.

```dart
final isWindowZoomed = Window.isWindowZoomed();
```

Get if the window is fullscreened.

```dart
final isWindowFullscreened = Window.isWindowFullscreened();
```

Hide/Show the window's zoom button.

```dart
Window.hideZoomButton();
Window.showZoomButton();
```

Hide/Show the window's miniaturize button.

```dart
Window.hideMiniaturizeButton();
Window.showMiniaturizeButton();
```

Hides/Show the window's close button.

```dart
Window.hideCloseButton();
Window.showCloseButton();
```

Enable/Disable the window's zoom button.

```dart
Window.enableZoomButton();
Window.disableZoomButton();
```

Enable/Disable the window's miniaturize button.

```dart
Window.enableMiniaturizeButton();
Window.disableMiniaturizeButton();
```

Enable/Disable the window's close button.

```dart
Window.enableCloseButton();
Window.disableCloseButton();
```

Get whether the window is currently being resized by the user.

```dart
final isWindowInLiveResize = Window.isWindowInLiveResize();
```

Set the window's alpha value.

```dart
Window.setWindowAlphaValue(0.75);
```

Get if the window is visible.

```dart
final isWindowVisible = Window.isWindowVisible();
```

Set the window's titlebar to the default (opaque) color.

```dart
Window.setWindowBackgroundColorToDefaultColor()
```

Make the window's titlebar clear.

```dart
Window.setWindowBackgroundColorToClear()
```

Set the window's blur view state.

```dart
Window.setBlurViewState(MacOSBlurViewState.active);
Window.setBlurViewState(MacOSBlurViewState.inactive);
Window.setBlurViewState(MacOSBlurViewState.followsWindowActiveState);
```

Add a visual effect subview to the application's window.

```dart
final visualEffectSubviewId = Window.addVisualEffectSubview();
```

Update the properties of a visual effect subview.

```dart
Window.updateVisualEffectSubviewProperties(visualEffectSubviewId, VisualEffectSubviewProperties());
```

Remove a visual effect subview from the application's window.

```dart
Window.removeVisualEffectSubview(visualEffectSubviewId);
```

Override the brightness setting of the window.

```dart
Window.overrideMacOSBrightness(dark: true);
```

Add a toolbar and set its style.

```dart
Window.addToolbar();

Window.setToolbarStyle(MacOSToolbarStyle.automatic);
Window.setToolbarStyle(MacOSToolbarStyle.expanded);
Window.setToolbarStyle(MacOSToolbarStyle.preference);
Window.setToolbarStyle(MacOSToolbarStyle.unified);
Window.setToolbarStyle(MacOSToolbarStyle.unifiedCompact);
```

Enable and disable window shadow.

```dart
Window.enableShadow();
Window.disableShadow();
```

Make window fully transparent (with no blur effect):

```dart
Window.makeWindowFullyTransparent();
```

Acknowledge or ignore mouse events:

```dart
Window.acknowledgeMouseEvents();
Window.ignoreMouseEvents();
```

Set the window's subtitle:

```dart
Window.setSubtitle('subtitle');
```

More features coming soon.

## Notes

### Windows

**No additional setup is required.**

On Windows 11 versions higher than or equal to 22523, `DwmSetWindowAttribute` API is used for `WindowEffect.acrylic`, `WindowEffect.mica` & `WindowEffect.tabbed` effects.

This plugin uses the undocumented `SetWindowCompositionAttribute` API from `user32.dll` on Windows 10 & early Windows 11 versions to achieve the acrylic effect.
Learn more at [Rafael Rivera](https://github.com/riverar)'s amazing blog post about this [here](https://withinrafael.com/2015/07/08/adding-the-aero-glass-blur-to-your-windows-10-apps).


[ONLY on Windows 10] In most cases, you might wanna render custom window frame because the blur effect might leak outside the window boundary.
You can use [bitsdojo_window](https://github.com/bitsdojo/bitsdojo_window) to make a custom window for your Flutter application.

`WindowEffect.acrylic` causes lag on window drag in Windows 10, this issue is fixed by Microsoft in Windows 11. This issue can be prevented by a "hack", however nothing has been done within the plugin to circumvent this on Windows 10.

`WindowEffect.mica` & `WindowEffect.tabbed` only works on Windows 11.

You can see the [example](https://github.com/alexmercerind/flutter_acrylic/blob/master/example/lib/main.dart) application for further details.

### macOS

**Additional setup for macOS:**

flutter_acrylic depends on the [macos_window_utils](https://pub.dev/packages/macos_window_utils) plugin, which requires macOS 10.14.6 or above. Please update your macOS deployment target as follows:

Open the `macos/Runner.xcworkspace` folder of your project using Xcode, press ⇧ + ⌘ + O and search for `Runner.xcodeproj`. Go to `Info` > `Deployment Target` and set the `macOS Deployment Target` to `10.14.6` or above.

Additionally, you may need to open the `Podfile` in your Xcode project and make sure the deployment target in the first line is set to `10.14.6` or above as well:

```podspec
platform :osx, '10.14.6'
```

Depending on your use case, you may want to extend the area of the window that Flutter can draw to to the entire window, such that you are able to draw onto the window's title bar as well (for example when you're only trying to make the sidebar transparent while the rest of the window is meant to stay opaque).

To do so, enable the full-size content view with the following Dart code:

```dart
Window.makeTitlebarTransparent();
Window.enableFullSizeContentView();
```

When you decide to do this, it is recommended to wrap your application (or parts of it) in a `TitlebarSafeArea` widget as follows:

```dart
TitlebarSafeArea(
  child: YourApp(),
)
```

This ensures that your app is not covered by the window's title bar.

Additionally, it may be worth considering to split your sidebar and your main view into multiple `NSVisualEffectView`'s inside your
app. This is because macOS has a feature called “wallpaper tinting,” which is enabled by default. This feature allows windows to
blend in with the desktop wallpaper:

![macos_wallpaper_tint_70%](https://user-images.githubusercontent.com/86920182/199122746-ccbc61a6-b5cf-4f36-bd37-7b63b4426a28.jpg)


To achieve the same effect in your Flutter application, you can set the window's window effect to `WindowEffect.solid` and wrap
your sidebar widget with a `TransparentMacOSSidebar` widget like so:

```dart
TransparentMacOSSidebar(
  child: YourSidebarWidget(),
)
```

**Note:** The widget will automatically resize the `NSVisualEffectView` when a resize is detected in the widget's `build` method.
If you are animating your sidebar's size using a `TweenAnimationBuilder`, please make sure that the `TransparentMacOSSidebar` widget
is built *within* the `TweenAnimationBuilder`'s `build` method, in order to guarantee that a rebuild is triggered when the size
changes. For reference, there is a working example in the `sidebar_frame.dart` file of the `example` project.

### Linux

**Additional setup for Linux.**

Find `my_application.cc` inside the `linux` directory of your Flutter project & remove following lines from it.

```cpp
gtk_widget_show(GTK_WIDGET(window));
```

```cpp
gtk_widget_show(GTK_WIDGET(view));
```

**Adding blur to the Window.**

Since current Flutter embedder on Linux uses GTK 3.0, so there is no official API available for backdrop blur of the window.

However, some desktop environments like KDE Plasma (with KWin compositor) have some third party scripts like [kwin-forceblur](https://github.com/esjeon/kwin-forceblur) from [Eon S. Jeon](https://github.com/esjeon), which allow to add blur to GTK 3.0 windows aswell (when the window is transparent, which you can certainly achieve using the plugin). Thus, this setup can be used to obtain result as shown in the picture.

Blur on Linux is more dependent on the compositor, some compositors like compiz or wayfire also seem to support blur effects.

## License

MIT License. Contributions welcomed.

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/aero.jpg?raw=true)

Aero blur effect.

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/linux_blur.png?raw=true)

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/transparent.jpg?raw=true)

Transparent Flutter window.

![image](https://user-images.githubusercontent.com/86920182/139502224-a1a25c9d-a945-4685-be3b-715d83ce52ae.png)

Transparent Flutter window on macOS Monterey with dark mode enabled.
