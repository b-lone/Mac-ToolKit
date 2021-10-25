//
//  CallWindowVC.swift
//  ComponentApp
//
//  Created by alberyan on 2021/7/1.
//

import Cocoa
import UIToolkit

class CallWindowVC: UTBaseViewController {
    
    @IBOutlet var notifyHostButton: UTPillButton!
    @IBOutlet var layoutButton: UTPillButton!
    @IBOutlet var meetingInfoButton: UTPillButton!
    @IBOutlet var viewCaptionsAndHighlightsButton: UTPillButton!
    @IBOutlet var turnOnWebexAssistantButton: UTPillButton!
    @IBOutlet var inviteToMeetingOnlyButton: UTPillButton!
    @IBOutlet var panelButton2: UTRoundButton!
    @IBOutlet var panelButton3: UTRoundButton!
    @IBOutlet var panelButton4: UTPillButton!
    @IBOutlet var panelButton5: UTPillButton!
    @IBOutlet var panelButton6: UTRoundButton!
    @IBOutlet var panelButton7: UTRoundButton!
    @IBOutlet var panelButton8: UTPillButton!
    @IBOutlet var isButton1: UTRoundButton!
    @IBOutlet var isButton2: UTRoundButton!
    @IBOutlet var isButton3: UTPillButton!
    @IBOutlet var isButton4: UTDownArrowButton!
    @IBOutlet var isButton5: UTPillButton!
    @IBOutlet var isButton6: UTPillButton!
    @IBOutlet var vmButton1: UTRoundButton!
    @IBOutlet var vmButton2: UTRoundButton!
    @IBOutlet var vmButton3: UTRoundButton!
    
    
    
    lazy var buttons: [UTButton] = [notifyHostButton, layoutButton, meetingInfoButton, viewCaptionsAndHighlightsButton, turnOnWebexAssistantButton, inviteToMeetingOnlyButton, panelButton2, panelButton3, panelButton4, panelButton5, panelButton6, panelButton7, panelButton8, isButton1, isButton2, isButton3, isButton4, isButton5, isButton6]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        notifyHostButton.buttonHeight = .medium
        notifyHostButton.title = "Notify Host"
        
        layoutButton.buttonHeight = .medium
        layoutButton.title = "Layout"
        layoutButton.fontIcon = .layoutSideBySideVerticalRegular
        
        meetingInfoButton.buttonHeight = .small
        meetingInfoButton.title = "Meeting info"
        meetingInfoButton.style = .ghost
        meetingInfoButton.fontIcon = .infoCircleBold
        
        viewCaptionsAndHighlightsButton.buttonHeight = .small
        viewCaptionsAndHighlightsButton.title = "View captions and hgighlights"
        viewCaptionsAndHighlightsButton.style = .ghost
        
        turnOnWebexAssistantButton.buttonHeight = .small
        turnOnWebexAssistantButton.title = "Turn on Webex Assistant"
        
        inviteToMeetingOnlyButton.buttonHeight = .small
        inviteToMeetingOnlyButton.title = "Invite to meeting only"
        inviteToMeetingOnlyButton.style = .secondary
        inviteToMeetingOnlyButton.fontIcon = .plusBold
        
        panelButton2.buttonHeight = .extrasmall
        panelButton2.fontIcon = .searchBold
        panelButton2.style = .ghost
        
        panelButton3.buttonHeight = .extrasmall
//        panelButton3.fontIcon = .unsortedBold
        panelButton3.style = .ghost
        
        panelButton4.buttonHeight = .small
        panelButton4.title = "Mute all"
        panelButton4.style = .ghost
        
        panelButton5.buttonHeight = .small
        panelButton5.title = "Unmute all"
        panelButton5.style = .ghost
        
        panelButton6.buttonHeight = .extrasmall
        panelButton6.fontIcon = .moreBold
        panelButton6.style = .ghost
        
        panelButton7.buttonHeight = .extrasmall
        panelButton7.fontIcon = .arrowLeftBold
        panelButton7.style = .ghost
        
        panelButton8.buttonHeight = .small
        panelButton8.title = "Add"
        panelButton8.style = .secondary
        
        isButton1.buttonHeight = .medium
        isButton1.fontIcon = .deviceConnectionBold
        isButton1.style = .ghost
        
        isButton2.buttonHeight = .medium
        isButton2.fontIcon = .settingsBold
        isButton2.style = .ghost
        
        isButton3.buttonHeight = .large
        isButton3.title = "Audio: Use computer for audio"
        isButton3.style = .secondary
        isButton3.fontIcon = .headsetBold
        
        isButton4.buttonHeight = .medium
        isButton4.title = "SHN7-17-APR5"
        isButton4.style = .primary
        isButton4.fontIcon = .deviceConnectionFilled
        
        isButton5.buttonHeight = .medium
        isButton5.title = "Disconnect"
        isButton5.style = .ghost
        
        isButton6.buttonHeight = .large
        isButton6.title = "Join Meeting"
        isButton6.style = .join
        
        vmButton1.buttonHeight = .small
        vmButton1.fontIcon = .playBold
        vmButton1.style = .secondary
        
        vmButton2.buttonHeight = .large
        vmButton2.fontIcon = .deleteRegular
        vmButton2.style = .secondary
        
        vmButton3.buttonHeight = .large
        vmButton3.fontIcon = .moreRegular
        vmButton3.style = .secondary
    }
    
    override func setThemeColors() {
        buttons.forEach { (button) in
            button.setThemeColors()
        }
    }
}
