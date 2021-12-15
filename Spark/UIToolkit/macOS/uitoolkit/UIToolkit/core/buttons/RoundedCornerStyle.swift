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
    case leading
    case trailing
    case top
    case bottom
    
    internal var shouldRoundMaxXMaxYCorner: Bool {
        switch self {
        case .trailing:
            return isLayoutDirectionLeftToRight() ? true : false
        case .pill, .bottom:
            return true
        case .leading:
            return isLayoutDirectionLeftToRight() ? false : true
        case .none, .top:
            return false
            
        }
    }
    internal var shouldRoundMaxXMinYCorner: Bool {
        switch self {
        case .trailing:
            return isLayoutDirectionLeftToRight() ? true : false
        case .pill, .top:
            return true
        case .leading:
            return isLayoutDirectionLeftToRight() ? false : true
        case .none, .bottom:
            return false
            
        }
    }
    
    internal var shouldRounMinXMaxYCorner: Bool {
        switch self {
        case .leading:
            return isLayoutDirectionLeftToRight() ? true : false
        case .pill, .bottom:
            return true
        case .trailing:
            return isLayoutDirectionLeftToRight() ? false : true
        case .none, .top:
            return false
            
        }
    }
    
    internal var shouldRoundMinXMinYCorner: Bool {
        switch self {
        case .leading:
            return isLayoutDirectionLeftToRight() ? true : false
        case .pill, .top:
            return true
        case .trailing:
            return isLayoutDirectionLeftToRight() ? false : true
        case .none, .bottom:
            return false
            
        }
    }
    
    private func isLayoutDirectionLeftToRight() -> Bool {
        return NSApp.userInterfaceLayoutDirection == .leftToRight
    }
}
