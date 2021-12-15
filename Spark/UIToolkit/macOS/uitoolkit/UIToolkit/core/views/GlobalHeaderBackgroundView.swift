//
//  GlobalHeaderBackgroundView.swift
//  UIToolkit
//
//  Created by James Nestor on 13/09/2021.
//

import Cocoa

public class GlobalHeaderBackgroundView: UTView {
    public override func setThemeColors() {
        self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(token: UTColorTokens.globalHeaderContainerBackground).normal.cgColor        
        super.setThemeColors()
    }
}
