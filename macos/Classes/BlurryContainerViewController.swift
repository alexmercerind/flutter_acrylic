//
//  BlurryContainerViewController.swift
//  flutter_acrylic
//
//  Created by Adrian Samoticha on 21.10.22.
//

import Foundation
import FlutterMacOS

public class BlurryContainerViewController: NSViewController {
    public let flutterViewController = FlutterViewController()
    private var visualEffectSubviewRegistry = VisualEffectSubviewRegistry()

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
    
    public func addVisualEffectSubview(_ visualEffectSubview: VisualEffectSubview) -> UInt {
        self.view.addSubview(visualEffectSubview, positioned: .below, relativeTo: flutterViewController.view)
        return visualEffectSubviewRegistry.registerSubview(visualEffectSubview)
    }
    
    public func getVisualEffectSubview(_ subviewId: UInt) -> VisualEffectSubview? {
        return visualEffectSubviewRegistry.getSubviewFromId(subviewId)
    }
    
    public func removeVisualEffectSubview(_ subviewId: UInt) {
        let visualEffectSubview = visualEffectSubviewRegistry.getSubviewFromId(subviewId)
        visualEffectSubview?.removeFromSuperview()
        visualEffectSubviewRegistry.deregisterSubview(subviewId)
    }
}
