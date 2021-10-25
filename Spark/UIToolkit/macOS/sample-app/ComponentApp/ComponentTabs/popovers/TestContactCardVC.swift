//
//  TestContactCardVC.swift
//  ComponentApp
//
//  Created by James Nestor on 27/07/2021.
//

import Cocoa
import UIToolkit

class TestContactCardVC: UTBaseViewController {
        
    @IBOutlet var testCoverImage: NSView!
    @IBOutlet var avatarView: UTAvatarView!
    
    @IBOutlet var displayNameLabel: UTLabel!
    @IBOutlet var availabilityLabel: UTLabel!
    @IBOutlet var presenceSeparatorLabel: UTLabel!
    @IBOutlet var statusLabel: UTLabel!
    
    @IBOutlet var jobTitle: UTLabel!
    
    @IBOutlet var acitonButtonStackView: NSStackView!
    @IBOutlet var messageButton: UTRoundButton!
    @IBOutlet var videoCallButton: UTRoundButton!
    @IBOutlet var audioCallButton: UTRoundButton!
    @IBOutlet var peopleInsightsButton: UTRoundButton!
    
    @IBOutlet var workNumberStackView: NSStackView!
    @IBOutlet var mobileNumberStackView: NSStackView!
    
    @IBOutlet var emailLink: UTHyperlinkButton!
    @IBOutlet var workNumber: UTHyperlinkButton!
    @IBOutlet var mobileNumber: UTHyperlinkButton!
    
    @IBOutlet var pmrButton: UTRoundButton!
    @IBOutlet var emailButton: UTRoundButton!
    
    @IBOutlet var workLabel: UTLabel!
    @IBOutlet var mobileLabel: UTLabel!
    
    @IBOutlet var emailLabel: UTLabel!
    @IBOutlet var departmentLabel: UTLabel!
    @IBOutlet var managerLabel: UTLabel!
    @IBOutlet var managerValue: UTLabel!
    @IBOutlet var departmentValue: UTLabel!
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        //self.view.layer?.backgroundColor = NSColor.red.cgColor
        testCoverImage.wantsLayer = true
        testCoverImage.layer?.backgroundColor = NSColor.systemTeal.cgColor
        
        avatarView.dataSource = AvatarImageViewDataSource(presenceState: .active, size: .large , avatar: NSImage(named: "maya")!)
        
        jobTitle.fontType = .labelCompact
        jobTitle.style    = .primary
        
        emailLabel.fontType = .labelCompact
        emailLabel.style    = .secondary
        
        mobileLabel.fontType = .labelCompact
        mobileLabel.style    = .secondary
        workLabel.fontType   = .labelCompact
        workLabel.style      = .secondary
        
        departmentLabel.fontType = .labelCompact
        departmentLabel.style    = .secondary
        
        managerLabel.fontType = .labelCompact
        managerLabel.style    = .secondary
        
        managerValue.fontType = .labelCompact
        managerValue.style    = .primary
        
        departmentValue.fontType = .labelCompact
        departmentValue.style    = .primary
                
        messageButton.buttonHeight = .small
        messageButton.style = .message
        messageButton.fontIcon = .chatBold
        
        videoCallButton.buttonHeight = .small
        videoCallButton.style = .join
        videoCallButton.fontIcon = .videoBold
        
        audioCallButton.buttonHeight = .small
        audioCallButton.fontIcon = .handsetBold
        audioCallButton.style = .join
                
        peopleInsightsButton.buttonHeight = .small
        peopleInsightsButton.style = .secondary
        peopleInsightsButton.fontIcon = .contactCardBold
        
        emailLink.title = "joeblogs@acme.com"
        emailLink.style = .hyperlink
        emailLink.buttonHeight = .extrasmall
        
        workNumber.style = .hyperlink
        workNumber.title = "+1 206 5043 234"
        workNumber.buttonHeight = .extrasmall
                
        mobileNumber.style = .hyperlink
        mobileNumber.title = "+1 206 5043 111"
        mobileNumber.buttonHeight = .extrasmall
        
        pmrButton.buttonHeight = .extrasmall
        pmrButton.fontIcon = .pmrBold
        pmrButton.style = .secondary
        
        emailButton.buttonHeight = .extrasmall
        emailButton.fontIcon = .emailBold
        emailButton.style = .secondary
        
        mobileNumberStackView.isHidden = true
        workNumberStackView.isHidden = true
        
        availabilityLabel.fontType = .labelCompact
        availabilityLabel.style    = .secondary
        
        presenceSeparatorLabel.fontType = .labelCompact
        presenceSeparatorLabel.style    = .secondary
        presenceSeparatorLabel.isEnabled = false
        
        statusLabel.fontType = .labelCompact
        statusLabel.style    = .secondary
        
        displayNameLabel.fontType = .headerPrimary
        displayNameLabel.style = .primary
    }
       
        
    @IBAction func messageButtonAction(_ sender: Any) {
        mobileNumberStackView.isHidden = !mobileNumberStackView.isHidden
        workNumberStackView.isHidden   = !workNumberStackView.isHidden
    }
    
    @IBAction func videoCallButtonAction(_ sender: Any) {
        emailLink.isEnabled    = !emailLink.isEnabled
        workNumber.isEnabled   = !workNumber.isEnabled
        mobileNumber.isEnabled = !mobileNumber.isEnabled
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        avatarView.setThemeColors()
        
        jobTitle.setThemeColors()
        
        emailLink.setThemeColors()
        workNumber.setThemeColors()
        mobileNumber.setThemeColors()
        pmrButton.setThemeColors()
        emailButton.setThemeColors()
        
        acitonButtonStackView.setThemeableViewColors()
        
        emailLabel.setThemeColors()
        departmentLabel.setThemeColors()
        managerLabel.setThemeColors()
        managerValue.setThemeColors()
        departmentValue.setThemeColors()
        
        availabilityLabel.setThemeColors()
        presenceSeparatorLabel.setThemeColors()
        statusLabel.setThemeColors()
        
        displayNameLabel.setThemeColors()
        
        mobileLabel.setThemeColors()
        workLabel.setThemeColors()
    }
    
}
