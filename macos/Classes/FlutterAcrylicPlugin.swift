import Cocoa
import FlutterMacOS

public class BlurryContainerViewController: NSViewController {
    public let flutterViewController = FlutterViewController()

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError()
    }

    override public func loadView() {
        let blurView = NSVisualEffectView()
        blurView.autoresizingMask = [.width, .height]
        blurView.blendingMode = .behindWindow
        blurView.state = .followsWindowActiveState
        if #available(macOS 10.14, *) {
            blurView.material = .underWindowBackground
        }
        self.view = blurView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.addChild(flutterViewController)

        flutterViewController.view.frame = self.view.bounds
        flutterViewController.view.autoresizingMask = [.width, .height]
        self.view.addSubview(flutterViewController.view)
    }
}

private class EffectIDToMaterialConverter {
    @available(macOS 10.14, *)
    public static func getMaterialFromEffectID(effectID: NSNumber) -> NSVisualEffectView.Material {
        switch(effectID) {
        /* Try to mimic the behavior of the following effects as
           closely as possible: */
        case 0: // disabled
            return NSVisualEffectView.Material.windowBackground
            
        case 1: // solid
            return NSVisualEffectView.Material.windowBackground
            
        case 2: // transparent
            return NSVisualEffectView.Material.underWindowBackground
            
        case 3: // aero
            return NSVisualEffectView.Material.hudWindow
            
        case 4: // acrylic
            return NSVisualEffectView.Material.fullScreenUI
            
        case 5: // mica
            return NSVisualEffectView.Material.headerView

        case 6: // tabbed
            return NSVisualEffectView.Material.headerView
            
        case 7: // titlebar
            return NSVisualEffectView.Material.titlebar
                    
        case 8: // selection
            return NSVisualEffectView.Material.selection
            
        case 9: // menu
            return NSVisualEffectView.Material.menu
            
        case 10: // popover
            return NSVisualEffectView.Material.popover
            
        case 11: // sidebar
            return NSVisualEffectView.Material.sidebar
            
        case 12: // headerView
            return NSVisualEffectView.Material.headerView
            
        case 13: // sheet
            return NSVisualEffectView.Material.sheet
            
        case 14: // windowBackground
            return NSVisualEffectView.Material.windowBackground
            
        case 15: // hudWindow
            return NSVisualEffectView.Material.hudWindow
            
        case 16: // fullScreenUI
            return NSVisualEffectView.Material.fullScreenUI
            
        case 17: // toolTip
            return NSVisualEffectView.Material.toolTip
            
        case 18: // contentBackground
            return NSVisualEffectView.Material.contentBackground
            
        case 19: // underWindowBackground
            return NSVisualEffectView.Material.underWindowBackground
            
        case 20: // underPageBackground
            return NSVisualEffectView.Material.underPageBackground
            
        default:
            return NSVisualEffectView.Material.windowBackground
        }
    }
}

public class MainFlutterWindowManipulator {
    private static var mainFlutterWindow: NSWindow?
    
    private static func printNotStartedWarning() {
        print("Warning: The MainFlutterWindowManipulator has not been started. Please make sure the flutter_acrylic plugin is initialized correctly in your MainFlutterWindow.swift file.")
    }
    
    public static func start(mainFlutterWindow: NSWindow) {
        self.mainFlutterWindow = mainFlutterWindow
        
        showTitle()
        makeTitlebarOpaque()
        disableFullSizeContentView()
        setWindowBackgroundColorToDefaultColor()
    }
    
    public static func hideTitle() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.titleVisibility = NSWindow.TitleVisibility.hidden
    }
    
    public static func showTitle() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.titleVisibility = NSWindow.TitleVisibility.visible
    }
    
    public static func makeTitlebarTransparent() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.titlebarAppearsTransparent = true
    }
    
    public static func makeTitlebarOpaque() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.titlebarAppearsTransparent = false
    }
    
    public static func enableFullSizeContentView() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.styleMask.insert(.fullSizeContentView)
    }
    
    public static func disableFullSizeContentView() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.styleMask.remove(.fullSizeContentView)
    }
    
    public static func zoomWindow() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.setIsZoomed(true)
    }
    
    public static func unzoomWindow() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.setIsZoomed(false)
    }
    
    public static func isWindowZoomed() -> Bool {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return false
        }
        
        return self.mainFlutterWindow!.isZoomed
    }
    
    public static func enterFullscreen() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        if (!isWindowFullscreened()) {
            self.mainFlutterWindow!.toggleFullScreen(self)
        }
    }
    
    public static func exitFullscreen() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        if (isWindowFullscreened()) {
            self.mainFlutterWindow!.toggleFullScreen(self)
        }
    }
    
    public static func isWindowFullscreened() -> Bool {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return false
        }
        
        let isFullscreenEnabled = self.mainFlutterWindow!.styleMask.contains(NSWindow.StyleMask.fullScreen)
        return isFullscreenEnabled
    }
    
    public static func hideZoomButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.zoomButton)!.isHidden = true
    }
    
    public static func showZoomButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.zoomButton)!.isHidden = false
    }
    
    public static func hideMiniaturizeButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.miniaturizeButton)!.isHidden = true
    }
    
    public static func showMiniaturizeButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.miniaturizeButton)!.isHidden = false
    }
    
    public static func hideCloseButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.closeButton)!.isHidden = true
    }
    
    public static func showCloseButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.closeButton)!.isHidden = false
    }
    
    public static func enableZoomButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.zoomButton)!.isEnabled = true
    }

    public static func disableZoomButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.zoomButton)!.isEnabled = false
    }

    public static func enableMiniaturizeButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.miniaturizeButton)!.isEnabled = true
    }

    public static func disableMiniaturizeButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.miniaturizeButton)!.isEnabled = false
    }

    public static func enableCloseButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.closeButton)!.isEnabled = true
    }

    public static func disableCloseButton() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.standardWindowButton(.closeButton)!.isEnabled = false
    }
    
    public static func setDocumentEdited() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.isDocumentEdited = true
    }
    
    public static func setDocumentUnedited() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.isDocumentEdited = false
    }
    
    public static func setRepresentedFilename(filename: String) {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.representedFilename = filename
    }
    
    public static func setRepresentedURL(url: String) {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.representedURL = URL(string: url)
    }
    
    public static func isWindowInLiveResize() -> Bool {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return false
        }
        
        return self.mainFlutterWindow!.inLiveResize
    }
    
    public static func setWindowAlphaValue(alphaValue: CGFloat) {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.alphaValue = alphaValue
    }
    
    public static func isWindowVisible() -> Bool {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return false
        }
        
        return self.mainFlutterWindow!.isVisible
    }
    
    public static func setWindowBackgroundColorToDefaultColor() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.backgroundColor = .windowBackgroundColor
    }
    
    public static func setWindowBackgroundColorToClear() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.backgroundColor = .clear
    }
    
    public static func setBlurViewState(state: NSVisualEffectView.State) {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        let blurryContainerViewController = self.mainFlutterWindow?.contentViewController as! BlurryContainerViewController;
        (blurryContainerViewController.view as! NSVisualEffectView).state = state
    }
    
    @available(macOS 10.14, *)
    public static func setAppearance(dark: Bool) {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow?.contentView?.superview?.appearance = NSAppearance(named: dark ? .darkAqua : .aqua)
        
        self.mainFlutterWindow?.invalidateShadow()
    }
    
    @available(macOS 10.14, *)
    public static func setMaterial(material: NSVisualEffectView.Material) {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        let blurryContainerViewController = self.mainFlutterWindow?.contentViewController as! BlurryContainerViewController;
        (blurryContainerViewController.view as! NSVisualEffectView).material = material
        
        self.mainFlutterWindow?.invalidateShadow()
    }
    
    @available(macOS 10.14, *)
    public static func setEffect(material: NSVisualEffectView.Material) {
        setMaterial(material: material)
    }
    
    public static func getTitlebarHeight() -> CGFloat {
        let windowFrameHeight = (self.mainFlutterWindow!.contentView?.frame.height)!
        let contentLayoutRectHeight = self.mainFlutterWindow!.contentLayoutRect.height
        let fullSizeContentViewNoContentAreaHeight = windowFrameHeight - contentLayoutRectHeight
        return fullSizeContentViewNoContentAreaHeight
    }
}

public class FlutterAcrylicPlugin: NSObject, FlutterPlugin {
    private var registrar: FlutterPluginRegistrar!;
    private var channel: FlutterMethodChannel!
    
    private static func printUnsupportedMacOSVersionWarning() {
        print("Warning: Transparency effects are not supported for your macOS Deployment Target.")
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.alexmercerind/flutter_acrylic", binaryMessenger: registrar.messenger)
        let instance = FlutterAcrylicPlugin(registrar, channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public init(_ registrar: FlutterPluginRegistrar, _ channel: FlutterMethodChannel) {
        super.init()
        self.registrar = registrar
        self.channel = channel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let methodName: String = call.method
        let args: [String: Any] = call.arguments as? [String: Any] ?? [:]
        
        switch (methodName) {
        case "Initialize":
            if #available(macOS 10.14, *) {
                let material = EffectIDToMaterialConverter.getMaterialFromEffectID(effectID: 0)
                
                MainFlutterWindowManipulator.setEffect(material: material)
            } else {
                FlutterAcrylicPlugin.printUnsupportedMacOSVersionWarning()
            }
            result(true)
            break
            
        case "SetEffect":
            if #available(macOS 10.14, *) {
                let effectID = args["effect"] as! NSNumber
                let material = EffectIDToMaterialConverter.getMaterialFromEffectID(effectID: effectID)
                
                MainFlutterWindowManipulator.setEffect(material: material)
            } else {
                FlutterAcrylicPlugin.printUnsupportedMacOSVersionWarning()
            }
            result(true)
            break
            
        case "HideWindowControls":
            MainFlutterWindowManipulator.hideZoomButton()
            MainFlutterWindowManipulator.hideMiniaturizeButton()
            MainFlutterWindowManipulator.hideCloseButton()
            result(true)
            break
            
        case "ShowWindowControls":
            MainFlutterWindowManipulator.showZoomButton()
            MainFlutterWindowManipulator.showMiniaturizeButton()
            MainFlutterWindowManipulator.showCloseButton()
            result(true)
            break
            
        case "EnterFullscreen":
            MainFlutterWindowManipulator.enterFullscreen()
            result(true)
            break
            
        case "ExitFullscreen":
            MainFlutterWindowManipulator.exitFullscreen()
            result(true)
            break
            
        case "OverrideMacOSBrightness":
            if #available(macOS 10.14, *) {
                let dark = args["dark"] as! Bool
                
                MainFlutterWindowManipulator.setAppearance(dark: dark)
            } else {
                FlutterAcrylicPlugin.printUnsupportedMacOSVersionWarning()
            }
            result(true)
            break
            
        case "SetDocumentEdited":
            MainFlutterWindowManipulator.setDocumentEdited()
            result(true)
            break
            
        case "SetDocumentUnedited":
            MainFlutterWindowManipulator.setDocumentUnedited()
            result(true)
            break
            
        case "SetRepresentedFile":
            let filename = args["filename"] as! String
            
            MainFlutterWindowManipulator.setRepresentedFilename(filename: filename)
            result(true)
            break
            
        case "SetRepresentedURL":
            let url = args["url"] as! String
            
            MainFlutterWindowManipulator.setRepresentedFilename(filename: url)
            result(true)
            break
            
        case "GetTitlebarHeight":
            let titlebarHeight = MainFlutterWindowManipulator.getTitlebarHeight() as NSNumber
            result(titlebarHeight)
            break
            
        case "HideTitle":
            MainFlutterWindowManipulator.hideTitle()
            result(true)
            break

        case "ShowTitle":
            MainFlutterWindowManipulator.showTitle()
            result(true)
            break

        case "MakeTitlebarTransparent":
            MainFlutterWindowManipulator.makeTitlebarTransparent()
            result(true)
            break

        case "MakeTitlebarOpaque":
            MainFlutterWindowManipulator.makeTitlebarOpaque()
            result(true)
            break

        case "EnableFullSizeContentView":
            MainFlutterWindowManipulator.enableFullSizeContentView()
            result(true)
            break

        case "DisableFullSizeContentView":
            MainFlutterWindowManipulator.disableFullSizeContentView()
            result(true)
            break

        case "ZoomWindow":
            MainFlutterWindowManipulator.zoomWindow()
            result(true)
            break

        case "UnzoomWindow":
            MainFlutterWindowManipulator.unzoomWindow()
            result(true)
            break

        case "IsWindowZoomed":
            let isWindowZoomed = MainFlutterWindowManipulator.isWindowZoomed()
            result(isWindowZoomed)
            break

        case "IsWindowFullscreened":
            let isWindowFullscreened = MainFlutterWindowManipulator.isWindowFullscreened()
            result(isWindowFullscreened)
            break

        case "HideZoomButton":
            MainFlutterWindowManipulator.hideZoomButton()
            result(true)
            break

        case "ShowZoomButton":
            MainFlutterWindowManipulator.showZoomButton()
            result(true)
            break

        case "HideMiniaturizeButton":
            MainFlutterWindowManipulator.hideMiniaturizeButton()
            result(true)
            break

        case "ShowMiniaturizeButton":
            MainFlutterWindowManipulator.showMiniaturizeButton()
            result(true)
            break

        case "HideCloseButton":
            MainFlutterWindowManipulator.hideCloseButton()
            result(true)
            break

        case "ShowCloseButton":
            MainFlutterWindowManipulator.showCloseButton()
            result(true)
            break

        case "EnableZoomButton":
            MainFlutterWindowManipulator.enableZoomButton()
            result(true)
            break

        case "DisableZoomButton":
            MainFlutterWindowManipulator.disableZoomButton()
            result(true)
            break

        case "EnableMiniaturizeButton":
            MainFlutterWindowManipulator.enableMiniaturizeButton()
            result(true)
            break

        case "DisableMiniaturizeButton":
            MainFlutterWindowManipulator.disableMiniaturizeButton()
            result(true)
            break

        case "EnableCloseButton":
            MainFlutterWindowManipulator.enableCloseButton()
            result(true)
            break

        case "DisableCloseButton":
            MainFlutterWindowManipulator.disableCloseButton()
            result(true)
            break

        case "IsWindowInLiveResize":
            let isWindowInLiveResize = MainFlutterWindowManipulator.isWindowInLiveResize()
            result(isWindowInLiveResize)
            break

        case "SetWindowAlphaValue":
            let alphaValue = args["value"] as! NSNumber
            MainFlutterWindowManipulator.setWindowAlphaValue(alphaValue: alphaValue as! CGFloat)
            result(true)
            break

        case "IsWindowVisible":
            let isWindowVisible = MainFlutterWindowManipulator.isWindowVisible()
            result(isWindowVisible)
            break
            
        case "SetWindowBackgroundColorToDefaultColor":
            MainFlutterWindowManipulator.setWindowBackgroundColorToDefaultColor()
            result(true)
            break
            
        case "SetWindowBackgroundColorToClear":
            MainFlutterWindowManipulator.setWindowBackgroundColorToClear()
            result(true)
            break
            
        case "SetBlurViewState":
            let blurViewStateString = args["state"] as! String
            let state = blurViewStateString == "active"   ? NSVisualEffectView.State.active :
                        blurViewStateString == "inactive" ? NSVisualEffectView.State.inactive :
                                                            NSVisualEffectView.State.followsWindowActiveState
            MainFlutterWindowManipulator.setBlurViewState(state: state)
            result(true)
            break
            
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
