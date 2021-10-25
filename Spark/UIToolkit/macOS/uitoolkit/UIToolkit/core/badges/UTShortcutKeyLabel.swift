//
//  UTShortcutKeyLabel.swift
//  UIToolkit
//
//  Created by James Nestor on 25/05/2021.
//

import Cocoa

public class UTShortcutKeyLabel: UTTextWithBackground {
    
    //MARK: - Public
    public init(shortcutString:String){
        super.init(frame: NSZeroRect)
        self.shortcutString = shortcutString
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }    
    
    ///Shortcut string is the string that is displayed in
    ///the centre of the control
    @IBInspectable public var shortcutString:String = " "{
        didSet{
            self.needsDisplay = true
        }
    }
    
    //MARK: - Internal
    
    override internal var horizontalPadding:CGFloat{
        return 12
    }
    
    override internal var stringValue:String{
        return shortcutString
    }
    
    override internal var minimumHeight: CGFloat{
        return 20
    }
    
    override internal var minimumWidth: CGFloat{
        return 16
    }

    override internal var fontColor:CCColor {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: "text-primary").normal
    }
    
    override internal var backgroundColor:CCColor {
        return  UIToolkit.shared.getThemeManager().getColors(tokenName: "button-secondary").normal
    }
    
}
