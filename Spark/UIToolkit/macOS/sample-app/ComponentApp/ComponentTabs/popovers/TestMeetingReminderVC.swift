//
//  TestMeetingReminderVC.swift
//  ComponentApp
//
//  Created by James Nestor on 08/07/2021.
//

import Cocoa
import UIToolkit

class TestMeetingReminderVC: UTBaseViewController {

    var containerStackView:NSStackView!
    var titleLabel:UTLabel!
        
    var bodyStackView:NSStackView!
    
    var avatarView:UTAvatarView!
    
    var bodyTextStackView:NSStackView!
    var headerLabel:UTLabel!
    var subheaderLabel:UTLabel!
    var callStartTimeLabel:UTLabel!
    
    var footerStackView:NSStackView!
    var joinButton:UTPillButton!
    var reminderButton:UTRoundButton!
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.view = UTToastView(frame: NSMakeRect(0, 0, 322, 176))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        containerStackView = NSStackView(frame: view.bounds)
        containerStackView.wantsLayer = true
        containerStackView.orientation = .vertical
        containerStackView.spacing = 20
        containerStackView.distribution = .fillProportionally
        containerStackView.edgeInsets = NSEdgeInsets(top: 4, left: 16, bottom: 8, right: 16)
        view.setAsOnlySubviewAndFill(subview: containerStackView)
        containerStackView.setHuggingPriority(.defaultLow, for: .horizontal)
        
        titleLabel = UTLabel(stringValue: LocalizationStrings.meetingReminder, fontType: .labelCompact, style: .secondary, lineBreakMode: .byTruncatingMiddle)
        
        bodyStackView = NSStackView()
        bodyStackView.wantsLayer = true
        bodyStackView.orientation = .horizontal
        bodyStackView.distribution = .fillProportionally
        bodyStackView.alignment = .top
        bodyStackView.spacing = 8
                
        avatarView = UTAvatarView()
        avatarView.dataSource = AvatarImageViewDataSource(size: .small, name: "Maya", bgColor: CCColor.getColorFromHexString(hexString: "066070"))
        
        bodyTextStackView = NSStackView()
        bodyTextStackView.wantsLayer  = true
        bodyTextStackView.orientation = .vertical
        bodyTextStackView.spacing     = 2
        bodyTextStackView.alignment = .leading
        
        headerLabel        = UTLabel(stringValue: LocalizationStrings.meetingName, fontType: .bodyPrimary, style: .primary, lineBreakMode: .byTruncatingTail)
        subheaderLabel     = UTLabel(stringValue: LocalizationStrings.spaceName, fontType: .bodySecondary, style: .secondary, lineBreakMode: .byTruncatingTail)
        callStartTimeLabel = UTLabel(stringValue: LocalizationStrings.now, fontType: .labelCompact, style: .success, lineBreakMode: .byTruncatingTail)
        
        headerLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        headerLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        subheaderLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        callStartTimeLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        bodyTextStackView.addArrangedSubview(headerLabel)
        bodyTextStackView.addArrangedSubview(subheaderLabel)
        bodyTextStackView.addArrangedSubview(callStartTimeLabel)
        
        bodyStackView.addArrangedSubview(avatarView)
        bodyStackView.addArrangedSubview(bodyTextStackView)
        
        footerStackView = NSStackView()
        footerStackView.orientation = .horizontal
        
        joinButton = UTPillButton()
        joinButton.style = .join
        joinButton.buttonHeight = .medium
        joinButton.title = LocalizationStrings.join
        
        reminderButton = UTRoundButton()
        reminderButton.style  = .ghost
        reminderButton.fontIcon = .alarmBold
        
        footerStackView.addView(reminderButton, in: .trailing)
        footerStackView.addView(joinButton, in: .trailing)
        
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(bodyStackView)
        containerStackView.addArrangedSubview(footerStackView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Does not get called because no xib file
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        containerStackView.setThemeableViewColors()
        bodyStackView.setThemeableViewColors()
        bodyTextStackView.setThemeableViewColors()
        containerStackView.setThemeableViewColors()
        footerStackView.setThemeableViewColors()
    }
    
    override func onLanguageChanged() {
        super.onLanguageChanged()
        
        titleLabel.stringValue = LocalizationStrings.meetingReminder
        
        headerLabel.stringValue        = LocalizationStrings.meetingName
        subheaderLabel.stringValue     = LocalizationStrings.spaceName
        callStartTimeLabel.stringValue = LocalizationStrings.now
        
        joinButton.title = LocalizationStrings.join
    }
}
