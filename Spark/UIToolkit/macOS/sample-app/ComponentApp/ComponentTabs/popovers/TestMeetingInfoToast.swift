//
//  TestMeetingInfoToast.swift
//  ComponentApp
//
//  Created by James Nestor on 08/07/2021.
//

import Cocoa
import UIToolkit

class TestMeetingInfoToast: UTBaseViewController {

    var containerStackView:NSStackView!
    
    var avatarView:UTAvatarView!
    
    var bodyTextStackView:NSStackView!
    var headerLabel:UTLabel!
    var subheaderLabel:UTLabel!
    
    var closeButton:UTRoundButton!
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.view = UTToastView(frame: NSMakeRect(0, 0, 322, 74))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        containerStackView = NSStackView(frame: view.bounds)
        containerStackView.wantsLayer = true
        containerStackView.orientation = .horizontal
        containerStackView.spacing = 20
        containerStackView.distribution = .fillProportionally
        containerStackView.edgeInsets = NSEdgeInsets(top: 4, left: 16, bottom: 8, right: 16)
        view.setAsOnlySubviewAndFill(subview: containerStackView)
        containerStackView.setHuggingPriority(.defaultLow, for: .horizontal)
        
        avatarView = UTAvatarView()
        avatarView.dataSource = AvatarImageViewDataSource(size: .small, name: "Maya", bgColor: CCColor.getColorFromHexString(hexString: "066070"))
        
        bodyTextStackView = NSStackView()
        bodyTextStackView.wantsLayer  = true
        bodyTextStackView.orientation = .vertical
        bodyTextStackView.spacing     = 2
        bodyTextStackView.alignment = .leading
        
        headerLabel    = UTLabel(stringValue: LocalizationStrings.meetingName, fontType: .bodyPrimary, style: .primary, lineBreakMode: .byTruncatingTail)
        subheaderLabel = UTLabel(stringValue: LocalizationStrings.onePersonWaitingToJoin, fontType: .labelCompact, style: .success, lineBreakMode: .byTruncatingTail)
        
        headerLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        headerLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        subheaderLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        bodyTextStackView.addArrangedSubview(headerLabel)
        bodyTextStackView.addArrangedSubview(subheaderLabel)
        
        closeButton = UTRoundButton()
        closeButton.style  = .ghost
        closeButton.fontIcon = .cancelBold
        closeButton.action = #selector(closeButtonAction)
        closeButton.target = self
        
        containerStackView.addArrangedSubview(avatarView)
        containerStackView.addArrangedSubview(bodyTextStackView)
        containerStackView.addArrangedSubview(closeButton)
    }
    
    @IBAction func closeButtonAction(_ sender:Any){
        self.view.window?.close()
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        bodyTextStackView.setThemeableViewColors()
        containerStackView.setThemeableViewColors()
    }
    
    override func onLanguageChanged() {
        super.onLanguageChanged()
        
        headerLabel.stringValue    = LocalizationStrings.meetingName
        subheaderLabel.stringValue = LocalizationStrings.onePersonWaitingToJoin
    }
    
}
