//
//  RoundedCornerStyle.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 25/07/2021.
//

import Cocoa

public enum RoundedCornerStyle {
    case none
    case pill
    case lhs
    case rhs
    case top
    case bottom
    
    internal var shouldRoundMaxXMaxYCorner: Bool {
        switch self {
        case .pill, .rhs, .bottom:
            return true
        case .none, .lhs, .top:
            return false
            
        }
    }
    internal var shouldRoundMaxXMinYCorner: Bool {
        switch self {
        case .pill, .rhs, .top:
            return true
        case .none, .lhs, .bottom:
            return false
            
        }
    }
    
    internal var shouldRounMinXMaxYCorner: Bool {
        switch self {
        case .pill, .lhs, .bottom:
            return true
        case .none, .rhs, .top:
            return false
            
        }
    }
    
    internal var shouldRoundMinXMinYCorner: Bool {
        switch self {
        case .pill, .lhs, .top:
            return true
        case .none, .rhs, .bottom:
            return false
            
        }
    }
}
