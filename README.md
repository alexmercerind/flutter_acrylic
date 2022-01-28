<h1 align="center"><a href="https://github.com/alexmercerind/flutter_acrylic">flutter_acrylic</a></h1>
<h4 align="center">Window acrylic, mica & transparency effects for Flutter on Windows, macOS & Linux</h4>

## Installation

Mention in your `pubspec.yaml`.

```yaml
dependencies:
  ...
  flutter_acrylic: ^1.0.0
```

_Windows 10 versions higher than 1803 & all Windows 11 versions are supported by the plugin, although not all effects might be available to a particular Windows version. See [pinned issues](https://github.com/alexmercerind/flutter_acrylic/issues) if you encounter some problem or feel free to file one yourself._

## Example

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/mug8J4efWu.gif?raw=true)

_Example app running on Microsoft Windows 11 (pre-compiled release mode x64 executable available to test in the "Releases" tab)._

## Documentation

Initialize the plugin inside the main method.

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  runApp(MyApp());
}
```

Apply the effect to Flutter window.

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

Following effects are available for Microsoft Windows.

- `WindowEffect.acrylic`.
- `WindowEffect.mica`.
- `WindowEffect.aero`.
- `WindowEffect.disabled`.
- `WindowEffect.solid`.
- `WindowEffect.transparent`.

Following effects are available for macOS.

- `WindowEffect.titlebar`.
- `WindowEffect.selection`.
- `WindowEffect.menu`.
- `WindowEffect.popover`.
- `WindowEffect.sidebar`.
- `WindowEffect.headerView`.
- `WindowEffect.sheet`.
- `WindowEffect.windowBackground`.
- `WindowEffect.hudWindow`.
- `WindowEffect.fullScreenUI`.
- `WindowEffect.toolTip`.
- `WindowEffect.contentBackground`.
- `WindowEffect.underWindowBackground`.
- `WindowEffect.underPageBackground`.

**Other utility features offered by the plugin:**

Enter fullscreen.

```dart
Window.enterFullscreen();
```

Exit fullscreen.

```dart
Window.exitFullscreen();
```

Hide controls.

```dart
Window.hideWindowControls();
```

Show controls.

```dart
Window.showWindowControls();
```

**macOS only utility features:**

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

Open the `macos/Runner.xcworkspace` folder of your project using Xcode, press ⇧ + ⌘ + O and search for `MainFlutterWindow.swift`.

Insert `import flutter_acrylic` at the top of the file.
Then, replace the code above the `super.awakeFromNib()`-line with the following code:

```swift
let windowFrame = self.frame
let blurryContainerViewController = BlurryContainerViewController()
self.contentViewController = blurryContainerViewController
self.setFrame(windowFrame, display: true)

/* Initialize the flutter_acrylic plugin */
MainFlutterWindowManipulator.start(mainFlutterWindow: self)

RegisterGeneratedPlugins(registry: blurryContainerViewController.flutterViewController)
```

Assuming you're starting with the default configuration, the finished code should look something like this:

```diff
import Cocoa
import FlutterMacOS
+import flutter_acrylic

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
-   let flutterViewController = FlutterViewController.init()
-   let windowFrame = self.frame
-   self.contentViewController = flutterViewController
-   self.setFrame(windowFrame, display: true)

-   RegisterGeneratedPlugins(registry: flutterViewController)
    
+   let windowFrame = self.frame
+   let blurryContainerViewController = BlurryContainerViewController()
+   self.contentViewController = blurryContainerViewController
+   self.setFrame(windowFrame, display: true)

+   /* Initialize the flutter_acrylic plugin */
+   MainFlutterWindowManipulator.start(mainFlutterWindow: self)

+   RegisterGeneratedPlugins(registry: blurryContainerViewController.flutterViewController)

    super.awakeFromNib()
  }
}
```

Now press ⇧ + ⌘ + O once more and search for `Runner.xcodeproj`. Go to `info` > `Deployment Target` and set the `macOS Deployment Target` to `10.11` or above.

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

## Platforms

|Platform|Status|Maintainer                                      |
|--------|------|------------------------------------------------|
|Windows |✅    |[Hitesh Kumar Saini](https://github.com/alexmercerind)  |
|macOS   |✅    |[Adrian Samoticha](https://github.com/Adrian-Samoticha) |
|Linux   |✅    |[Hitesh Kumar Saini](https://github.com/alexmercerind)  |

## License

MIT License. Contributions welcomed.

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/aero.jpg?raw=true)

Aero blur effect.

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/linux_blur.png?raw=true)

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/transparent.jpg?raw=true)

Transparent Flutter window.

![image](https://user-images.githubusercontent.com/86920182/139502224-a1a25c9d-a945-4685-be3b-715d83ce52ae.png)

Transparent Flutter window on macOS Monterey with dark mode enabled.
