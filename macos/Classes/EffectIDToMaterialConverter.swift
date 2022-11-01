//
//  EffectIDToMaterialConverter.swift
//  flutter_acrylic
//
//  Created by Adrian Samoticha on 21.10.22.
//

import Foundation

public class EffectIDToMaterialConverter {
    @available(macOS 10.14, *)
    public static func getMaterialFromEffectID(effectID: NSNumber) -> NSVisualEffectView.Material {
        switch (effectID) {
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
        
        /* The following effects are macOS-only: */
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
