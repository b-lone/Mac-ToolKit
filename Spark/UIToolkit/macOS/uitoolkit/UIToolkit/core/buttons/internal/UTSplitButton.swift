//
//  UTSplitButton.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 23/07/2021.
//

import Cocoa
internal class UTRightSplitButton : UTSplitButton {

    override func initialise(){
    
        super.initialise()
        elementSize.minIntrinsicWidth = 28
        roundSetting = .rhs

    }
    
    override var trailingPadding:CGFloat {
        return 8
    
    }
    
    override var leadingPadding:CGFloat {
        return 6
    }
}

internal class UTLeftSplitButton : UTSplitButton {
    
    override func initialise(){
        super.initialise()
        roundSetting = .lhs
    }
    
    override var trailingPadding:CGFloat {
        return 6
    
    }
    
    override var leadingPadding:CGFloat {
        return 8
    }
}

internal class UTSplitButton : UTButton {
    
    override func initialise(){
        super.startAtLeadingPadding = true
        super.fontIconSize = 16
        super.buttonType = .pill
        super.initialise()
        elementSize.minIntrinsicWidth = 28
    }
    
    override var trailingPadding:CGFloat {
        return 6
    }
    
    override var leadingPadding:CGFloat {
        return 6
    }

    var roundSetting: RoundedCornerStyle = .rhs {
        didSet {
            switch roundSetting {
            case .lhs:
                super.roundLHSCorner()
            case .rhs:
                super.roundRHSCorner()
            case .top:
                super.roundTopCorner()
            case .bottom:
                super.roundBottomCorner()
            default:
                break
            }
        }
    }

    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        switch height {
        case .medium: return 32
        case .small: return 28
        default:
            assert(false, "height not supported for UTSplitButton")
            return 32
        }
    }
    
    open override func drawFocusRingMask() {
        if let cornerRadius = self.layer?.cornerRadius {
            let path = NSBezierPath.getBezierPathWithSomeRoundedCorners(roundedCorners: self.roundSetting, cornerRadius: cornerRadius, bounds: self.bounds)
            path.fill()
        } else {
            assert(false, "cannot get the radius for the button" )
        }
    }
}
