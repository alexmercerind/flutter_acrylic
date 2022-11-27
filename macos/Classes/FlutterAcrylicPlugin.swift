import Cocoa
import FlutterMacOS

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
            
        case "AddVisualEffectSubview":
            let visualEffectSubview = VisualEffectSubview()
            let visualEffectSubviewId = MainFlutterWindowManipulator.addVisualEffectSubview(visualEffectSubview)
            
            if #available(macOS 10.14, *) {
                let properties = VisualEffectSubviewProperties.fromArgs(args)
                properties.applyToVisualEffectSubview(visualEffectSubview)
            } else {
                FlutterAcrylicPlugin.printUnsupportedMacOSVersionWarning()
            }
            
            result(visualEffectSubviewId)
            break
            
        case "UpdateVisualEffectSubviewProperties":
            let visualEffectSubviewId = args["visualEffectSubviewId"] as! UInt
            let visualEffectSubview = MainFlutterWindowManipulator.getVisualEffectSubview(visualEffectSubviewId)
            
            if (visualEffectSubview != nil) {
                if #available(macOS 10.14, *) {
                    let properties = VisualEffectSubviewProperties.fromArgs(args)
                    properties.applyToVisualEffectSubview(visualEffectSubview!)
                } else {
                    FlutterAcrylicPlugin.printUnsupportedMacOSVersionWarning()
                }
            }
            
            result(visualEffectSubview != nil)
            break
            
        case "RemoveVisualEffectSubview":
            let visualEffectSubviewId = args["visualEffectSubviewId"] as! UInt
            MainFlutterWindowManipulator.removeVisualEffectSubview(visualEffectSubviewId)
            
            result(true)
            break
            
        case "AddToolbar":
            MainFlutterWindowManipulator.addToolbar()
            
            result(true)
            break
            
        case "RemoveToolbar":
            MainFlutterWindowManipulator.removeToolbar()
            
            result(true)
            break
            
        case "SetToolbarStyle":
            let toolbarStyleName = args["toolbarStyle"] as! String
            
            if #available(macOS 11.0, *) {
                let toolbarStyle = ToolbarStyleNameToEnumConverter.getToolbarStyleFromName(name: toolbarStyleName)
                
                if toolbarStyle != nil {
                    MainFlutterWindowManipulator.setToolbarStyle(toolbarStyle: toolbarStyle!)
                }
            } else {
                FlutterAcrylicPlugin.printUnsupportedMacOSVersionWarning()
            }
            
            result(true)
            break
            
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
