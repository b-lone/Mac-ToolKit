//
//  GlobalHeaderBackgroundView.swift
//  UIToolkit
//
//  Created by James Nestor on 13/09/2021.
//

import Cocoa

public class GlobalHeaderBackgroundView: UTView {
    public override func setThemeColors() {
        
        let colorToken = UIToolkit.shared.isUsingLegacyTokens ? "appHeader" : UTColorTokens.globalHeaderContainerBackground.rawValue
        self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: colorToken).normal.cgColor
        
        super.setThemeColors()
    }
}
