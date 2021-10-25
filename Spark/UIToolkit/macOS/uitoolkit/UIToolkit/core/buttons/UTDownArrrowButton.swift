//
//  UTDownArrrowButton.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 20/05/2021.
//

import Cocoa

open class UTDownArrowButton: UTButton {

    override func initialise(){
        super.style = .join
        super.buttonType = .pill
        addUIElement(element: .ArrowIcon)
        super.initialise()
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        switch height {
        case .extralarge:
            assert(false)
            return 10
        case .large:
            assert(false)
            return 10
        case .medium: return 32
        case .small: return 28
        case .extrasmall:
            assert(false)
            return 10
        default:
            assert(false)
            return 10
        }
    }
}
