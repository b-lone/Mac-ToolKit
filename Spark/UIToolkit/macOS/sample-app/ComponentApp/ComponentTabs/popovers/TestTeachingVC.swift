//
//  TestTeachingVC.swift
//  ComponentApp
//
//  Created by vlstanko on 10/15/21.
//

import Cocoa
import UIToolkit

class TestTeachingVC: UTBaseViewController {
    
    @IBOutlet var primaryButton: UTPillButton!
    @IBOutlet var secondaryButton: UTPillButton!
    @IBOutlet var hyperlinkButton: UTHyperlinkButton!
    @IBOutlet var brandingLabel: UTLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        
        primaryButton.title = "Primary"
        primaryButton.style = .teachingPrimary
        
        secondaryButton.title = "Secondary"
        secondaryButton.style = .teachingSecondary
        
        hyperlinkButton.title = "Hyperlink"
        hyperlinkButton.style = .teachingHyperlink
        
        brandingLabel.stringValue = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent semper quis urna at maximus. Fusce pulvinar volutpat quam a tristique. Donec magna orci, luctus vel semper a, pharetra quis augue. In hac habitasse platea dictumst."
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        primaryButton.setThemeColors()
        secondaryButton.setThemeColors()
        hyperlinkButton.setThemeColors()
        
        let teachingTokenName = UIToolkit.shared.isUsingLegacyTokens ? "wx-spinnerWithLabel-text" : UTColorTokens.coachmarkteachingButtonSecondaryText.rawValue
        brandingLabel.textColor = UIToolkit.shared.getThemeManager().getColors(tokenName: teachingTokenName).normal
    }
}
