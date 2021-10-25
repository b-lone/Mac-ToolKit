//
//  UTClearButton.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 21/05/2021.
//

import Cocoa

public class UTClearIconButton: UTIconButton {
    
    override func initialise(){
        super.icon = .clear
        super.fontIconSize = 14        
        super.buttonHeight = .extrasmall
        super.preventFirstResponder = true
        super.initialise()
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        return 14
    }
}

