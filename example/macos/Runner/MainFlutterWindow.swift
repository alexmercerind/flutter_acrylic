import Cocoa
import FlutterMacOS
import flutter_acrylic

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let windowFrame = self.frame
    let blurryContainerViewController = BlurryContainerViewController() // new
    self.contentViewController = blurryContainerViewController // new
    self.setFrame(windowFrame, display: true)
    
    /* Initialize the flutter_acrylic plugin */
    MainFlutterWindowManipulator.start(mainFlutterWindow: self) // new
    
    RegisterGeneratedPlugins(registry: blurryContainerViewController.flutterViewController) // new

    super.awakeFromNib()
  }
}
