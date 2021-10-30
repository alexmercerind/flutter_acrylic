<h1 align="center"><a href="https://github.com/alexmercerind/flutter_acrylic">flutter_acrylic</a></h1>
<h4 align="center">Window acrylic, mica & transparency effects for Flutter on Windows, macOS & Linux</h4>

## Installation

Mention in your `pubspec.yaml`.

```yaml
dependencies:
  ...
  flutter_acrylic: ^0.0.2
```

## Example

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/flutter_acrylic_0.png?raw=true)
![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/flutter_acrylic_1.png?raw=true)
![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/flutter_acrylic_2.png?raw=true)

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

Following effects are available.

- `WindowEffect.disabled`.
- `WindowEffect.solid`.
- `WindowEffect.transparent`.
- `WindowEffect.aero`.
- `WindowEffect.acrylic`.
- `WindowEffect.mica`.
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

**Other utility features offered by the plugin (currently not supported on macOS):**

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

More features coming soon.

<br>

## Notes

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

<br>

### Windows

This plugin exposes the undocumented `SetWindowCompositionAttribute` API from `user32.dll` on Windows 10.
Learn more at [Rafael Rivera](https://github.com/riverar)'s amazing blog post about this [here](https://withinrafael.com/2015/07/08/adding-the-aero-glass-blur-to-your-windows-10-apps).

In most cases, you might wanna render custom window frame because the blur effect might leak outside the window boundary (only on Windows 10).
You can use [bitsdojo_window](https://github.com/bitsdojo/bitsdojo_window) to make a custom window for your Flutter application.

`WindowEffect.acrylic` causes lag on window drag in Windows 10, this issue is fixed by Microsoft in Windows 11.
`WindowEffect.mica` only works on Windows 11.

You can see the [example](https://github.com/alexmercerind/flutter_acrylic/blob/master/example/lib/main.dart) application for further details.

<br>

### macOS
**Additional setup for macOS:**
<br>
Open the `macos/Runner.xcworkspace` folder of your project using Xcode, press ⇧ + ⌘ + O and search for `MainFlutterWindow.swift`.

Insert `import flutter_acrylic` at the top of the file.
Then, insert the following code above the `super.awakeFromNib()`-line:

```swift
/* Hide the window titlebar */
self.titleVisibility = NSWindow.TitleVisibility.hidden;
self.titlebarAppearsTransparent = true;
self.isMovableByWindowBackground = true;
self.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isEnabled = false;

/* Make the window transparent */
self.isOpaque = false
self.backgroundColor = .clear

/* Initialize the flutter_acrylic plugin */
let contentView = contentViewController!.view;
MainFlutterWindowManipulator.setContentView(contentView: contentView)
MainFlutterWindowManipulator.setInvalidateShadowFunction(invalidateShadow: self.invalidateShadow)
```

Assuming you're starting with the default configuration, the finished code should look something like this:

```diff
import Cocoa
import FlutterMacOS
+import flutter_acrylic

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    
+   /* Hide the window titlebar */
+   self.titleVisibility = NSWindow.TitleVisibility.hidden;
+   self.titlebarAppearsTransparent = true;
+   self.isMovableByWindowBackground = true;
+   self.standardWindowButton(NSWindow.ButtonType.miniaturizeButton)?.isEnabled = false;

+   /* Make the window transparent */
+   self.isOpaque = false
+   self.backgroundColor = .clear
    
+   /* Initialize the flutter_acrylic plugin */
+   let contentView = contentViewController!.view;
+   MainFlutterWindowManipulator.setContentView(contentView: contentView)
+   MainFlutterWindowManipulator.setInvalidateShadowFunction(invalidateShadow: self.invalidateShadow)

    super.awakeFromNib()
  }
}
```

Now press ⇧ + ⌘ + O once more and search for `Runner.xcodeproj`. Go to `info` > `Deployment Target` and set the `macOS Deployment Target` to `10.11` or above.

Depending on your use case, you may want to extend the area of the window that Flutter can draw to to the entire window, such that you are able to draw onto the window's title bar as well (for example when you're only trying to make the sidebar transparent while the rest of the window is meant to stay opaque).

To do so, press ⇧ + ⌘ + O and search for `MainMenu.xib`. Click on the `APP_NAME` in the left sidebar. Now, towards the top of the sidebar on the right hand side of the Xcode window, click on the `Show the attributes inspector` icon. Lastly, check the `Full Size Content View` checkbox.

<img width="1143" alt="Screen Shot 2021-10-29 at 22 51 50" src="https://user-images.githubusercontent.com/86920182/139500686-a9269344-7096-4e7a-a13d-c05d70bac2fb.png">



<br>

## License

MIT License. Contributions welcomed.

<br>

## More

#### Checkout other awesome projects for Flutter on Windows

(Irrespective of order)

- [bitsdojo_window](https://github.com/bitsdojo/bitsdojo_window)
  - A Flutter package that makes it easy to customize and work with your Flutter desktop app window.
- [fluent_ui](https://github.com/bdlukaa/fluent_ui)
  - Implements Microsoft's Fluent Design System in Flutter.

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/aero.jpg?raw=true)

Aero blur effect.

<br>

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/linux_blur.png?raw=true)

![](https://github.com/alexmercerind/flutter_acrylic/blob/assets/transparent.jpg?raw=true)

Transparent Flutter window.

<br>

![image](https://user-images.githubusercontent.com/86920182/139502224-a1a25c9d-a945-4685-be3b-715d83ce52ae.png)

Transparent Flutter window on macOS Monterey with dark mode enabled.
