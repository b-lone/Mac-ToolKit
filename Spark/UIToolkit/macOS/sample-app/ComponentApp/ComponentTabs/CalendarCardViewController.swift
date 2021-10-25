//
//  CalendarCardViewController.swift
//  ComponentApp
//
//  Created by Michelle Mulcair on 17/09/2021.
//

import Cocoa
import UIToolkit

class CalendarCardViewController: UTBaseViewController {

    @IBOutlet weak var calendarCard: UTCard!
    @IBOutlet weak var activeRadioButton: NSButton!
    @IBOutlet weak var cancelledRadioButton: NSButton!
    @IBOutlet weak var inactiveRadioButton: NSButton!
    @IBOutlet weak var acceptedRadioButton: NSButton!
    @IBOutlet weak var noResponseRadioButton: NSButton!
    @IBOutlet weak var tentativeRadioButton: NSButton!
    @IBOutlet weak var pastRadioButton: NSButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        calendarCard.status = .active
        calendarCard.markerType = .accepted
        activeSelected(activeRadioButton!)
        
        setThemeColors()
        
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-primary").normal.cgColor
    }
    
    @IBAction func activeSelected(_ sender: Any) {
        calendarCard.status = .active
        defaultMarkerButton()
        setOnForStatusButtons(button: activeRadioButton)
    }
    
    @IBAction func cancelledSelected(_ sender: Any) {
        calendarCard.status = .cancelled
        calendarCard.markerType = .none
        setOnForStatusButtons(button: cancelledRadioButton)
        setOnForMarkeTypeButtons(button: cancelledRadioButton)
    }
    
    @IBAction func inactiveSelected(_ sender: Any) {
        calendarCard.status = .inactive
        defaultMarkerButton()
        setOnForStatusButtons(button: inactiveRadioButton)
    }
    
    @IBAction func accetptedSelected(_ sender: Any) {
        calendarCard.markerType = .accepted
        defaultStatusButton()
        setOnForMarkeTypeButtons(button: acceptedRadioButton)
    }
    
    @IBAction func noResponseSelected(_ sender: Any) {
        calendarCard.hasBorder = true
        calendarCard.markerType = .tentative
        defaultStatusButton()
        setOnForMarkeTypeButtons(button: noResponseRadioButton)
    }
    
    @IBAction func tentativeSelected(_ sender: Any) {
        calendarCard.markerType = .tentative
        defaultStatusButton()
        setOnForMarkeTypeButtons(button: tentativeRadioButton)
    }
    
    @IBAction func pastSelected(_ sender: Any) {
        calendarCard.status =  .inactive
        calendarCard.markerType = .none
        setOnForStatusButtons(button: pastRadioButton)
        setOnForMarkeTypeButtons(button: pastRadioButton)
    }
    
    private func setOnForStatusButtons(button: NSButton) {
        
        if button == activeRadioButton {
            activeRadioButton.state = .on
        } else {
            activeRadioButton.state = .off
        }
        if button == cancelledRadioButton {
            cancelledRadioButton.state = .on
        } else {
            cancelledRadioButton.state = .off
        }
        if button == inactiveRadioButton {
            inactiveRadioButton.state = .on
        } else {
            inactiveRadioButton.state = .off
        }
        if button == pastRadioButton {
            pastRadioButton.state = .on
        } else {
            pastRadioButton.state = .off
        }
        
        calendarCard.hasBorder = cancelledRadioButton.state == .on || noResponseRadioButton.state == .on
    }
    
    private func setOnForMarkeTypeButtons(button: NSButton) {
        
        if button == acceptedRadioButton {
            acceptedRadioButton.state = .on
        } else {
            acceptedRadioButton.state = .off
        }
        if button == tentativeRadioButton {
            tentativeRadioButton.state = .on
        } else {
            tentativeRadioButton.state = .off
        }
        if button == noResponseRadioButton {
            noResponseRadioButton.state = .on
        } else {
            noResponseRadioButton.state = .off
        }
        
        calendarCard.hasBorder = cancelledRadioButton.state == .on || noResponseRadioButton.state == .on
    }
    
    private func defaultStatusButton() {
        if inactiveRadioButton.state == .on {
            calendarCard.status = .inactive
            setOnForStatusButtons(button: inactiveRadioButton)
        } else {
            calendarCard.status = .active
            setOnForStatusButtons(button: activeRadioButton)
        }
    }
    
    private func defaultMarkerButton() {
        if tentativeRadioButton.state == .on {
            calendarCard.markerType = .tentative
            setOnForStatusButtons(button: tentativeRadioButton)
        } else if noResponseRadioButton.state == .on {
            calendarCard.markerType = .tentative
            setOnForStatusButtons(button: noResponseRadioButton)
        } else {
            calendarCard.markerType = .accepted
            setOnForStatusButtons(button: acceptedRadioButton)
        }
    }
}
