//
//  UTTabButton.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 28/05/2021.
//

import Cocoa
import Foundation

public protocol UTTabButtonDelegate : AnyObject{
    func onRightMouseClick(_ button: UTTabButton)
}

public class UTTabButton : UTButton {
    
    //Universal pattern we have defined: see sortIndex for 
    //badge+favicon+label+icon(arrow) / favicon+label+icon(arrow) / label+icon(arrow)  except for the ‘add app’ tab which is icon(plus)+label
    open weak var tabButtonDelegate: UTTabButtonDelegate?
    
    public var tabItem:UTTabItem!
    
    override func initialise(){
        super.style = .tabs
        super.buttonType = .pill
        super.initialise()
        buttonHeight = .small
        super.elementSize.elementPadding = 10
        preventFirstResponder = true
        layer?.masksToBounds = false
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        return 28
    }

    public override func rightMouseUp(with event: NSEvent) {
        super.rightMouseUp(with: event)
        tabButtonDelegate?.onRightMouseClick(self)
    }
}


