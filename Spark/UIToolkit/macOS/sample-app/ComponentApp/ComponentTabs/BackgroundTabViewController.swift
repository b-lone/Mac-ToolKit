//
//  OverlayTabViewController.swift
//  ComponentApp
//
//  Created by Jimmy Coyne on 10/09/2021.
//

import Cocoa
import UIToolkit

class BackgroundTabViewController: UTBaseViewController {
        
    @IBOutlet weak var normalOverlayView: UTBackgroundView!
    @IBOutlet weak var primaryGradientOverlayView: UTBackgroundView!
    @IBOutlet weak var secondaryGradientOverlayView: UTBackgroundView!
    @IBOutlet weak var clearOverlayView: UTBackgroundView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.cyan.cgColor
        
        normalOverlayView.style = .solidPrimary
        normalOverlayView.toolTip = "Normal"
    
        primaryGradientOverlayView.style = .gradientPrimary
        primaryGradientOverlayView.toolTip = "Gradient Primary"
    
        secondaryGradientOverlayView.style = .gradientSecondary
        secondaryGradientOverlayView.toolTip = "Gradient Secondary"
        
        clearOverlayView.style = .clear
        clearOverlayView.toolTip = "Clear"
   
    }
    
    override func setThemeColors() {
        normalOverlayView.setThemeColors()
        secondaryGradientOverlayView.setThemeColors()
        clearOverlayView.setThemeColors()
        primaryGradientOverlayView.setThemeColors()
    }
    
}
