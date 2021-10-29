import Cocoa
import FlutterMacOS

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
            
        case 6: // titlebar
            return NSVisualEffectView.Material.titlebar
                    
        case 7: // selection
            return NSVisualEffectView.Material.selection
            
        case 8: // menu
            return NSVisualEffectView.Material.menu
            
        case 9: // popover
            return NSVisualEffectView.Material.popover
            
        case 10: // sidebar
            return NSVisualEffectView.Material.sidebar
            
        case 11: // headerView
            return NSVisualEffectView.Material.headerView
            
        case 12: // sheet
            return NSVisualEffectView.Material.sheet
            
        case 13: // windowBackground
            return NSVisualEffectView.Material.windowBackground
            
        case 14: // hudWindow
            return NSVisualEffectView.Material.hudWindow
            
        case 15: // fullScreenUI
            return NSVisualEffectView.Material.fullScreenUI
            
        case 16: // toolTip
            return NSVisualEffectView.Material.toolTip
            
        case 17: // contentBackground
            return NSVisualEffectView.Material.contentBackground
            
        case 18: // underWindowBackground
            return NSVisualEffectView.Material.underWindowBackground
            
        case 19: // underPageBackground
            return NSVisualEffectView.Material.underPageBackground
            
        default:
            return NSVisualEffectView.Material.windowBackground
        }
    }
}

public class MainFlutterWindowManipulator {
    private static var contentView: NSView?
    private static var invalidateShadow: () -> Void = {}
    
    private static func printMissingContentViewWarning() {
        print("Warning: The MainFlutterWindowManipulator's contentView has not been set. Please make sure the flutter_acrylic plugin is initialized correctly in your MainFlutterWindow.swift file.")
    }
    
    public static func setContentView(contentView: NSView) {
        self.contentView = contentView
    }
    
    public static func setInvalidateShadowFunction(invalidateShadow: @escaping () -> Void) {
        self.invalidateShadow = invalidateShadow
    }
    
    @available(macOS 10.14, *)
    public static func setAppearance(dark: Bool) {
        let superView = contentView!.superview!
        superView.appearance = NSAppearance(named: dark ? .darkAqua : .aqua)
        
        self.invalidateShadow()
    }
    
    @available(macOS 10.14, *)
    public static func setMaterial(material: NSVisualEffectView.Material) {
        if (self.contentView == nil) {
            printMissingContentViewWarning()
            return
        }
        
        let superView = contentView!.superview!
        
        let blurView = NSVisualEffectView()
        blurView.frame = superView.bounds
        blurView.autoresizingMask = [.width, .height]
        blurView.blendingMode = NSVisualEffectView.BlendingMode.behindWindow

        /* Pick the correct material for the task */
        blurView.material = material

        /* Replace the contentView and the background view */
        superView.replaceSubview(contentView!, with: blurView)
        blurView.addSubview(contentView!)
        
        self.invalidateShadow()
    }
    
    @available(macOS 10.14, *)
    public static func setEffect(material: NSVisualEffectView.Material) {
        setMaterial(material: material)
    }
}

public class FlutterAcrylicPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.alexmercerind/flutter_acrylic", binaryMessenger: registrar.messenger)
        let instance = FlutterAcrylicPlugin(registrar, channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    private var registrar: FlutterPluginRegistrar!;
    private var channel: FlutterMethodChannel!
    
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
            result(true)
            break
            
        case "SetEffect":
            if #available(macOS 10.14, *) {
                let effectID = args["effect"] as! NSNumber
                let material = EffectIDToMaterialConverter.getMaterialFromEffectID(effectID: effectID)
                
                MainFlutterWindowManipulator.setEffect(material: material)
            } else {
                print("Warning: Transparency effects are not supported for your macOS Deployment Target.")
            }
            result(true)
            break
            
        case "HideWindowControls":
            result(true)
            break
            
        case "ShowWindowControls":
            result(true)
            break
            
        case "EnterFullscreen":
            result(true)
            break
            
        case "ExitFullscreen":
            result(true)
            break
            
        case "OverrideMacOSBrightness":
            if #available(macOS 10.14, *) {
                let dark = args["dark"] as! Bool
                
                MainFlutterWindowManipulator.setAppearance(dark: dark)
            } else {
                print("Warning: Transparency effects are not supported for your macOS Deployment Target.")
            }
            result(true)
            break
            
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
