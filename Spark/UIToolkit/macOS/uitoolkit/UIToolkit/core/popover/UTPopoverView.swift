//
//  UTPopoverView.swift
//  UIToolkit
//
//  Created by James Nestor on 24/05/2021.
//

import Cocoa
import Carbon.HIToolbox

class UTPopoverView: NSView, ThemeableProtocol {
    
    enum Style {
        case primary
        case toolTip
        case teaching
        
        var backgroundTokenName:String {
            switch self {
            case .primary:
                return UIToolkit.shared.isUsingLegacyTokens ? "background-primary" : "popover-primary-background"
            case .toolTip:
                //TODO
                return UIToolkit.shared.isUsingLegacyTokens ? "background-primary" : "popover-primary-background"
            case .teaching:
                return UIToolkit.shared.isUsingLegacyTokens ? "teaching-background" : UTColorTokens.coachmarkteachingBackground.rawValue
            }
        }
    }

    var style:Style = .primary {
        didSet {
            setThemeColors()
        }
    }
    
    weak var backgroundView:NSView?

    override func viewDidMoveToWindow() {
    
        guard let frameView = window?.contentView?.superview else {
            return
        }
        
        if let backgroundView = self.backgroundView{
            setThemeColors()
            frameView.addSubview(backgroundView, positioned: .below, relativeTo: frameView)
        }
        else{
            let bgView = NSView(frame: frameView.bounds)
            bgView.wantsLayer = true
            
            bgView.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]
            
            frameView.addSubview(bgView, positioned: .below, relativeTo: frameView)
            self.backgroundView = bgView
            setThemeColors()
        }
    }
    
    func setThemeColors() {
        if style == .toolTip { //TODO
            backgroundView?.layer?.backgroundColor = .black
        } else {
            backgroundView?.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: style.backgroundTokenName).normal.cgColor
        }
    }
    
}


