//
//  NSAttributedString+Extensions.swift
//  UIToolkit
//
//  Created by James Nestor on 14/06/2021.
//

import Cocoa

extension NSAttributedString {

    internal static func getAttributedString(iconType: MomentumIconsRebrandType, iconSize:CGFloat, color:CCColor) -> NSAttributedString{
        guard let fontelloFont = NSFont.getIconFont(size: iconSize) else { return NSAttributedString() }

        let attributes = [NSAttributedString.Key.foregroundColor : color,
                          NSAttributedString.Key.font : fontelloFont] as [NSAttributedString.Key : Any]
                
        return NSAttributedString(string: iconType.ligature, attributes: attributes)
    }
    
    internal static func getAttributedString(iconType: MomentumIconsRebrandType, iconSize:CGFloat) -> NSAttributedString{
        guard let fontelloFont = NSFont.getIconFont(size: iconSize) else { return NSAttributedString() }

        let attributes = [NSAttributedString.Key.font : fontelloFont] as [NSAttributedString.Key : Any]
                
        return NSAttributedString(string: iconType.ligature, attributes: attributes)
    }
    
    static func getAttributedString(stringProperties:UTStringProperties, fontSize:CGFloat) -> NSAttributedString {
        
        let mutableAttrString = NSMutableAttributedString(string: stringProperties.str)
        
        for hitPos in stringProperties.hitPositions {
            
            var tokenName = ""
            
            if hitPos.type == .searchMatch {
                tokenName = "text-primary"
                mutableAttrString.addAttribute(NSAttributedString.Key.font, value: NSFont.systemFont(ofSize: fontSize, weight: .bold), range: hitPos.range)
            }
            else if hitPos.type == .mentionAll ||
                        hitPos.type == .mentionMe {
                tokenName = "modal-decorativeTitle-mint"
            }
            else if hitPos.type == .mentionOther {
                tokenName = "wx-searchPlaceholder-text"
            }
            
            mutableAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIToolkit.shared.getThemeManager().getColors(tokenName: tokenName).normal, range: hitPos.range)
        }
        
        return mutableAttrString
    }
    
    static func getAttributedString(stringPropertiesList:[UTStringProperties], fontSize:CGFloat) -> NSAttributedString {
        
        let mutableAttrString = NSMutableAttributedString()
        
        for prop in stringPropertiesList {
                
            if prop.hitPositions.isEmpty {
                mutableAttrString.append(NSAttributedString(string: prop.str))
            }
            else{
                mutableAttrString.append(NSAttributedString.getAttributedString(stringProperties: prop, fontSize: fontSize))
            }
        }
        
        return mutableAttrString
    }
    
    func getCentredRect(in rect:NSRect) -> NSRect {
        let s = self.size()
        
        return NSRect(x: rect.width  / 2 - s.width / 2,
                      y: rect.height / 2 - s.height / 2,
                  width: s.width,
                 height: s.height)
        
    }
    
    func drawCentred(in rect: NSRect) {
        draw(in: getCentredRect(in: rect))
    }
    
    func getCentredRect(in rect:NSRect, xDelta:CGFloat, yDelta:CGFloat) -> NSRect {
        let s = self.size()
        
        let x:CGFloat = (rect.width  / 2 - s.width / 2)  + xDelta
        let y:CGFloat = (rect.height / 2 - s.height / 2) + yDelta
        
        return NSRect(x: x,
                      y: y,
                  width: s.width,
                 height: s.height)
    }
    
    func drawCentred(in rect: NSRect, xDelta:CGFloat = 0, yDelta:CGFloat = 0) {
        draw(in: getCentredRect(in: rect, xDelta: xDelta, yDelta: yDelta))
    }
    
}
