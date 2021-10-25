//
//  NSAppearance+Extensions.swift
//  UIToolkit
//
//  Created by James Nestor on 15/05/2021.
//

import Cocoa

extension NSAppearance{

    static func getThemedAppearance() -> NSAppearance?{
        if UIToolkit.shared.getThemeManager().isDarkTheme() {
            if #available(OSX 10.14, *){
                return NSAppearance(named: NSAppearance.Name.darkAqua)
            }
            else{
                return NSAppearance(named: NSAppearance.Name.vibrantDark)
            }
        }
        
        return NSAppearance(named: NSAppearance.Name.aqua)
    }
    
    static func getVibrantThemedAppearance() -> NSAppearance?{
        if UIToolkit.shared.getThemeManager().isDarkTheme(){
            return NSAppearance(named: NSAppearance.Name.vibrantDark)
        }
        
        return NSAppearance(named: NSAppearance.Name.vibrantLight)
    }
    
    func isLightAppearance() -> Bool{
        if self == NSAppearance(named: .aqua) ||
            self == NSAppearance(named: .vibrantLight){
            return true
        }
        
        if #available(OSX 10.14, *){
            if self == NSAppearance(named: .accessibilityHighContrastAqua) ||
              self == NSAppearance(named: .accessibilityHighContrastVibrantLight){
            
                return true
            }
        }
        
        return false
    }
    
    func isDarkAppearance() -> Bool{
        
        if self == NSAppearance(named: .vibrantDark){
            return true
        }
        
        if #available(OSX 10.14, *){
            if self == NSAppearance(named: .darkAqua) ||
               self == NSAppearance(named: .accessibilityHighContrastDarkAqua) ||
               self == NSAppearance(named: .accessibilityHighContrastVibrantDark){
            
                return true
            }
        }
        
        return false
    }

}

