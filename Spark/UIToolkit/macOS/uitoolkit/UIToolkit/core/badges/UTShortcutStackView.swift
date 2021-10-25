//
//  UTShortcutStackView.swift
//  UIToolkit
//
//  Created by James Nestor on 26/05/2021.
//

import Cocoa

public class UTShortcutStackView: NSStackView, ThemeableProtocol {

    public func addShortcutKeys(shortcutStrings:[String]){
        
        for key in shortcutStrings{
            self.addView(UTShortcutKeyLabel(shortcutString: key), in: .leading)
            
            if key != shortcutStrings.last{
                self.addView(UTLabel(labelWithString: "+"), in: .leading)
            }
        }
    }
    
    public func setThemeColors() {
        for view in views{
            if let v = view as? ThemeableProtocol{
                v.setThemeColors()
            }
        }
    }
    
}
