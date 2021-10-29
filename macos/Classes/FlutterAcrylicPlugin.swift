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
            
        default:
            return NSVisualEffectView.Material.windowBackground
        }
    }
}

public class MainFlutterWindowManipulator {
    private static var contentView: NSView?
    private static var invalidateShadow: () -> Void = {}
    
    public static func setContentView(contentView: NSView) {
        self.contentView = contentView
    }
    
    public static func setInvalidateShadowFunction(invalidateShadow: @escaping () -> Void) {
        self.invalidateShadow = invalidateShadow
    }
    
    @available(macOS 10.14, *)
    public static func setMaterial(material: NSVisualEffectView.Material, dark: Bool) {
        if (self.contentView == nil) {
            print("Warning: The MainFlutterWindowManipulator's contentView has not been set. Please make sure the flutter_acrylic plugin is initialized correctly in your MainFlutterWindow.swift file.")
            return
        }
        
        let superView = contentView!.superview!
        superView.appearance = NSAppearance(named: dark ? .darkAqua : .aqua)
        
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
    public static func setEffect(material: NSVisualEffectView.Material, dark: Bool) {
        setMaterial(material: material, dark: dark)
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
                let dark = args["dark"] as! Bool
                let material = EffectIDToMaterialConverter.getMaterialFromEffectID(effectID: effectID)
                MainFlutterWindowManipulator.setEffect(material: material, dark: dark)
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
            
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
}
