//
//  PopoversAndDialogsViewController.swift
//  ComponentApp
//
//  Created by James Nestor on 24/05/2021.
//

import Cocoa
import UIToolkit

class PopoversAndDialogsViewController: UTBaseViewController {
    
    @IBOutlet var showPopoverButton1: UTRoundButton!
    @IBOutlet var showPopoverButton2: UTRoundButton!
    @IBOutlet var showPopoverButton3: UTRoundButton!
    
    @IBOutlet var createToastButton: UTPillButton!
    @IBOutlet var createMeetingReminderButton: UTPillButton!
    @IBOutlet var createMeetingInfoToast: UTPillButton!
    @IBOutlet var createCallTosatButton: UTPillButton!
    @IBOutlet var createTextToast: UTPillButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showPopoverButton1.fontIcon     = .settingsRegular
        showPopoverButton1.buttonHeight = .extrasmall
        
        showPopoverButton2.fontIcon     = .cancelBold
        showPopoverButton2.buttonHeight = .extrasmall
        
        showPopoverButton3.fontIcon     = .filterRegular
        showPopoverButton3.buttonHeight = .extrasmall
        
        createToastButton.title           = LocalizationStrings.createToast
        createMeetingReminderButton.title = LocalizationStrings.createMeetingReminderToast
        createMeetingInfoToast.title      = LocalizationStrings.createMeetingInfoToast
        createCallTosatButton.title       = LocalizationStrings.callToast
        createTextToast.title             = LocalizationStrings.createTextToast
        
        createMeetingReminderButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        showPopoverButton1.setThemeColors()
        showPopoverButton2.setThemeColors()
        showPopoverButton3.setThemeColors()
        createToastButton.setThemeColors()
        createMeetingReminderButton.setThemeColors()
        createMeetingInfoToast.setThemeColors()
        createCallTosatButton.setThemeColors()
        createTextToast.setThemeColors()
    }
    
    @IBAction func showPopoverButton1Action(_ sender: Any) {
        _ = UTPopover(contentViewController: TestContactCardVC(),
                                     sender: showPopoverButton1,
                                     bounds: showPopoverButton1.bounds)
    }
    
    @IBAction func showPopoverButton2Action(_ sender: Any) {
        _ = UTPopover(contentViewController: BadgesViewController(),
                                     sender: showPopoverButton2,
                                     bounds: showPopoverButton2.bounds,
                            addCancelButton: true)
    }
    
    
    @IBAction func showPopoverButton3Action(_ sender: Any) {
        _ = UTPopover(contentViewController: TestPopoverList(),
                                     sender: showPopoverButton3,
                                     bounds: showPopoverButton3.bounds,
                                     behavior: .semitransient)
    }
    
    @IBAction func createToastAction(_ sender: Any) {
        TestToastWindowManager.shared.createToast()
    }
    
    @IBAction func createTextToastAction(_ sender: Any) {
        TestToastWindowManager.shared.createTextToast()
    }
    
    @IBAction func createMeetingReminderToastAction(_ sender: Any) {
        TestToastWindowManager.shared.createReminderToast()
    }
    
    @IBAction func createMeetingInfoToast(_ sender: Any) {
        TestToastWindowManager.shared.createInfoToast()
    }
    
    @IBAction func createCallToastAction(_ sender: Any){
        TestToastWindowManager.shared.createCallToast()
    }
}
