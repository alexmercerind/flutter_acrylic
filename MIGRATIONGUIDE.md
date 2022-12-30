# Migration Guide
## ^1.0.0 → 1.1.0
If you have followed the **“Additional setup for macOS”** instructions for flutter_acrylic 1.0.0, your `MainFlutterWindow.swift` file should like like this:

```swift
import Cocoa
import FlutterMacOS
import flutter_acrylic

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let windowFrame = self.frame
    let blurryContainerViewController = BlurryContainerViewController()
    self.contentViewController = blurryContainerViewController
    self.setFrame(windowFrame, display: true)

    /* Initialize the flutter_acrylic plugin */
    MainFlutterWindowManipulator.start(mainFlutterWindow: self) 
    RegisterGeneratedPlugins(registry: blurryContainerViewController.flutterViewController)

    super.awakeFromNib()
  }
}
```

In 1.1.0, flutter_acrylic has been made a dependent of [macos_window_utils](https://pub.dev/packages/macos_window_utils), which needs to be initialized instead of flutter_acrylic. To do so, the following changes need to be made:

+ Replace `import flutter_acrylic` with `import macos_window_utils`.
+ Replace `BlurryContainerViewController` with `MacOSWindowUtilsViewController`.

Once you are done, your finished code should like something like this:

```diff
import Cocoa
import FlutterMacOS
-import flutter_acrylic
+import macos_window_utils

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let windowFrame = self.frame
-   let blurryContainerViewController = BlurryContainerViewController()
-   self.contentViewController = blurryContainerViewController
+   let macOSWindowUtilsViewController = MacOSWindowUtilsViewController()
+   self.contentViewController = macOSWindowUtilsViewController
    self.setFrame(windowFrame, display: true)

-   /* Initialize the flutter_acrylic plugin */
+   /* Initialize the macos_window_utils plugin */
    MainFlutterWindowManipulator.start(mainFlutterWindow: self) 
-   RegisterGeneratedPlugins(registry: blurryContainerViewController.flutterViewController)
+   RegisterGeneratedPlugins(registry: macOSWindowUtilsViewController.flutterViewController)

    super.awakeFromNib()
  }
}
```

Additionally, you may need to open the `Podfile` in your Xcode project and make sure the deployment target in the first line is set to `10.14.6` or above:

```podspec
platform :osx, '10.14.6'
```

If your app does not support the macOS platform, no migration is necessary.