//
//  ControlsViewController.swift
//  ComponentApp
//
//  Created by James Nestor on 23/08/2021.
//

import Cocoa
import UIToolkit

class ControlsViewController: UTBaseViewController {
    
    @IBOutlet var loadingSpinnerStackView: NSStackView!
    
    private var extraSmallLoadingSpinner:UTSpinnerView!
    private var smallLoadingSpinner:UTSpinnerView!
    private var mediumLoadingSpinner:UTSpinnerView!
    private var largeLoadingSpinner:UTSpinnerView!
    
    @IBOutlet var progressSpinnerStackView: NSStackView!
    
    private var extraSmallProgressSpinner:UTSpinnerView!
    private var smallProgressSpinner:UTSpinnerView!
    private var mediumProgressSpinner:UTSpinnerView!
    private var largeProgressSpinner:UTSpinnerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        
        extraSmallProgressSpinner = UTSpinnerView(size: .extraSmall, style: .loading)
        smallLoadingSpinner       = UTSpinnerView(size: .small, style: .loading)
        mediumLoadingSpinner      = UTSpinnerView(size: .medium, style: .loading)
        largeLoadingSpinner       = UTSpinnerView(size: .large, style: .loading)
        
        loadingSpinnerStackView.addArrangedSubview(extraSmallProgressSpinner)
        loadingSpinnerStackView.addArrangedSubview(smallLoadingSpinner)
        loadingSpinnerStackView.addArrangedSubview(mediumLoadingSpinner)
        loadingSpinnerStackView.addArrangedSubview(largeLoadingSpinner)
        
        extraSmallProgressSpinner = UTSpinnerView(size: .extraSmall, style: .progress)
        smallProgressSpinner      = UTSpinnerView(size: .small, style: .progress)
        mediumProgressSpinner     = UTSpinnerView(size: .medium, style: .progress)
        largeProgressSpinner      = UTSpinnerView(size: .large, style: .progress)
        
        progressSpinnerStackView.addArrangedSubview(extraSmallProgressSpinner)
        progressSpinnerStackView.addArrangedSubview(smallProgressSpinner)
        progressSpinnerStackView.addArrangedSubview(mediumProgressSpinner)
        progressSpinnerStackView.addArrangedSubview(largeProgressSpinner)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        smallLoadingSpinner.startSpinner()
        mediumLoadingSpinner.startSpinner()
        largeLoadingSpinner.startSpinner()
        
        smallProgressSpinner.startSpinner()
        mediumProgressSpinner.startSpinner()
        largeProgressSpinner.startSpinner()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
    }
    
    override func setThemeColors() {
        self.view.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-primary").normal.cgColor
        loadingSpinnerStackView.setThemeableViewColors()
        progressSpinnerStackView.setThemeableViewColors()
        
        super.setThemeColors()
    }
    
}
