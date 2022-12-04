//
//  MainFlutterWindowManipulator.swift
//  flutter_acrylic
//
//  Created by Adrian Samoticha on 21.10.22.
//

import Foundation

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
        
        /*if #available(macOS 11.0, *) {
            self.mainFlutterWindow!.subtitle = "subtitle"
        } else {
            // Fallback on earlier versions
        }
        //self.mainFlutterWindow!.ignoresMouseEvents = true
        if #available(macOS 11.0, *) {
            self.mainFlutterWindow!.titlebarSeparatorStyle = NSTitlebarSeparatorStyle.none
        } else {
            // Fallback on earlier versions
        }
        
        self.mainFlutterWindow!.*/
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
        
        self.mainFlutterWindow!.contentView?.superview?.appearance = NSAppearance(named: dark ? .darkAqua : .aqua)
        
        self.mainFlutterWindow!.invalidateShadow()
    }
    
    @available(macOS 10.14, *)
    public static func setMaterial(material: NSVisualEffectView.Material) {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        let blurryContainerViewController = self.mainFlutterWindow!.contentViewController as! BlurryContainerViewController;
        (blurryContainerViewController.view as! NSVisualEffectView).material = material
        
        self.mainFlutterWindow!.invalidateShadow()
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
    
    public static func addVisualEffectSubview(_ visualEffectSubview: VisualEffectSubview) -> UInt {
        let blurryContainerViewController = self.mainFlutterWindow?.contentViewController as! BlurryContainerViewController;
        return blurryContainerViewController.addVisualEffectSubview(visualEffectSubview)
    }
    
    public static func getVisualEffectSubview(_ subviewId: UInt) -> VisualEffectSubview? {
        let blurryContainerViewController = self.mainFlutterWindow?.contentViewController as! BlurryContainerViewController;
        return blurryContainerViewController.getVisualEffectSubview(subviewId)
    }
    
    public static func removeVisualEffectSubview(_ subviewId: UInt) {
        let blurryContainerViewController = self.mainFlutterWindow?.contentViewController as! BlurryContainerViewController;
        blurryContainerViewController.removeVisualEffectSubview(subviewId)
    }
    
    public static func addToolbar() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        if #available(macOS 10.13, *) {
            let newToolbar = NSToolbar()

            self.mainFlutterWindow!.toolbar = newToolbar
        }
    }
    
    public static func removeToolbar() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.toolbar = nil
    }
    
    @available(macOS 11.0, *)
    public static func setToolbarStyle(toolbarStyle: NSWindow.ToolbarStyle) {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.toolbarStyle = toolbarStyle
    }
    
    public static func enableShadow() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.hasShadow = true
    }
    
    public static func disableShadow() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.hasShadow = false
    }
    
    public static func invalidateShadows() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.invalidateShadow()
    }
    
    public static func addEmptyMaskImage() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        let blurryContainerViewController = self.mainFlutterWindow!.contentViewController as! BlurryContainerViewController;
        (blurryContainerViewController.view as! NSVisualEffectView).maskImage = NSImage()
    }
    
    public static func removeMaskImage() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        let blurryContainerViewController = self.mainFlutterWindow!.contentViewController as! BlurryContainerViewController;
        (blurryContainerViewController.view as! NSVisualEffectView).maskImage = nil
    }
    
    public static func ignoreMouseEvents() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.ignoresMouseEvents = true
    }
    
    public static func acknowledgeMouseEvents() {
        if (self.mainFlutterWindow == nil) {
            printNotStartedWarning()
            return
        }
        
        self.mainFlutterWindow!.ignoresMouseEvents = false
    }
}
