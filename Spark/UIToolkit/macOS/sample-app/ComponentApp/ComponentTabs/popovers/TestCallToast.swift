//
//  TestCallToast.swift
//  ComponentApp
//
//  Created by James Nestor on 09/07/2021.
//

import Cocoa
import UIToolkit

class TestCallToast: UTBaseViewController {

    var containerStackView:NSStackView!
    
    var bodyStackView:NSStackView!
    var avatarView:UTAvatarView!
    
    var bodyTextStackView:NSStackView!
    var headerLabel:UTLabel!
    var subheaderLabel:UTLabel!
    
    var alertButton:UTRoundButton!
    var closeButton:UTRoundButton!
    
    var footerStackView:NSStackView!
    var messageButton:UTPillButton!
    var declineButton:UTPillButton!
    var answerButton:UTPillButton!
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.view = UTToastView(frame: NSMakeRect(0, 0, 322, 121))
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
        containerStackView.edgeInsets = NSEdgeInsets(top: 20, left: 16, bottom: 8, right: 16)
        view.setAsOnlySubviewAndFill(subview: containerStackView)
        containerStackView.setHuggingPriority(.defaultLow, for: .horizontal)
        
        bodyStackView = NSStackView()
        bodyStackView.orientation = .horizontal
        bodyStackView.distribution = .fillProportionally
        
        avatarView = UTAvatarView()
        avatarView.dataSource = AvatarImageViewDataSource(size: .small, name: "Maya", bgColor: CCColor.getColorFromHexString(hexString: "066070"))
        
        bodyTextStackView = NSStackView()
        bodyTextStackView.wantsLayer  = true
        bodyTextStackView.orientation = .vertical
        bodyTextStackView.spacing     = 2
        bodyTextStackView.alignment = .leading
        
        headerLabel    = UTLabel(stringValue: LocalizationStrings.meetingName, fontType: .bodyPrimary, style: .primary, lineBreakMode: .byTruncatingTail)
        subheaderLabel = UTLabel(stringValue: LocalizationStrings.incomingCall, fontType: .bodyCompact, style: .success, lineBreakMode: .byTruncatingTail)
        
        headerLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        headerLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        subheaderLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        bodyTextStackView.addArrangedSubview(headerLabel)
        bodyTextStackView.addArrangedSubview(subheaderLabel)
        
        alertButton = UTRoundButton()
        alertButton.style  = .ghost
        alertButton.fontIcon = .alertMutedBold
        
        closeButton = UTRoundButton()
        closeButton.style  = .ghost
        closeButton.fontIcon = .cancelBold
        closeButton.action = #selector(closeButtonAction)
        closeButton.target = self
        
        
        bodyStackView.addArrangedSubview(avatarView)
        bodyStackView.addArrangedSubview(bodyTextStackView)
        bodyStackView.addArrangedSubview(alertButton)
        bodyStackView.addArrangedSubview(closeButton)
        
        closeButton = UTRoundButton()
        closeButton.style  = .ghost
        closeButton.fontIcon = .cancelBold
        closeButton.action = #selector(closeButtonAction)
        closeButton.target = self
        
        messageButton = UTPillButton()
        messageButton.style = .message
        messageButton.buttonHeight = .medium
        messageButton.title = LocalizationStrings.message
        
        declineButton = UTPillButton()
        declineButton.style = .outlineCancel
        declineButton.buttonHeight = .medium
        declineButton.title = LocalizationStrings.decline
        
        answerButton = UTPillButton()
        answerButton.style = .outlineJoin
        answerButton.buttonHeight = .medium
        answerButton.title = LocalizationStrings.answer
        
        footerStackView = NSStackView()
        footerStackView.orientation = .horizontal
        footerStackView.distribution = .fillEqually
        footerStackView.setHuggingPriority(.defaultLow, for: .horizontal)
        footerStackView.setHuggingPriority(.init(751), for: .vertical)
        
        footerStackView.addArrangedSubview(messageButton)
        footerStackView.addArrangedSubview(declineButton)
        footerStackView.addArrangedSubview(answerButton)
        
        containerStackView.addArrangedSubview(bodyStackView)
        containerStackView.addArrangedSubview(footerStackView)
    }
    
    @IBAction func closeButtonAction(_ sender:Any){
        self.view.window?.close()
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        bodyTextStackView.setThemeableViewColors()
        footerStackView.setThemeableViewColors()
        containerStackView.setThemeableViewColors()
    }
    
    override func onLanguageChanged() {
        super.onLanguageChanged()
        
        headerLabel.stringValue    = LocalizationStrings.meetingName
        subheaderLabel.stringValue = LocalizationStrings.incomingCall
        messageButton.title        = LocalizationStrings.message
        declineButton.title        = LocalizationStrings.decline
        answerButton.title         = LocalizationStrings.answer
    }
    
}
