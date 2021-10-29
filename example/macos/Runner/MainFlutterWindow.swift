import Cocoa
import FlutterMacOS
import flutter_acrylic

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController.init()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    
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

    super.awakeFromNib()
  }
}
