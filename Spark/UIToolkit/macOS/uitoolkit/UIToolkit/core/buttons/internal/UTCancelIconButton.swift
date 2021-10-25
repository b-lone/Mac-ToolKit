//
//  UTCancelIconButton.swift
//  UIToolkit
//
//  Created by James Nestor on 26/05/2021.
//

import Cocoa

public class UTCancelIconButton: UTIconButton {
    
    override func initialise(){
        super.icon = .cancel
        super.fontIconSize = 12
        super.buttonType = .round
        super.buttonHeight = .extrasmall        
        super.initialise()
    }
   
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        return fontIconSize
    }
}

