//
//  CallHistoryLandingVC.swift
//  ComponentApp
//
//  Created by James Nestor on 16/06/2021.
//

import Cocoa
import UIToolkit

class CallHistoryLandingVC: UTBaseViewController {

    @IBOutlet var stackView: NSStackView!
    
    private var titleLabel:UTLabel!
    private var userCallLabel:UTWrappingIconLabel!
    private var userMeetingLabel:UTWrappingIconLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView.wantsLayer = true
        
        titleLabel = UTLabel(stringValue: LocalizationStrings.freeCallUserTitle, fontType: .bannerPrimary, style: .primary, lineBreakMode: .byWordWrapping)
        
        stackView.addArrangedSubview(titleLabel)        
        userCallLabel = UTWrappingIconLabel(iconType: .searchBold, style: .secondary, iconSize: .medium, label: LocalizationStrings.freeCallUserCallDetail, fontType: .bodyPrimary)
        userMeetingLabel = UTWrappingIconLabel(iconType: .dialpadBold, style: .secondary, iconSize: .medium, label: LocalizationStrings.freeCallUserMeetingDetail, fontType: .bodyPrimary)
        
        stackView.addArrangedSubview(userCallLabel)
        stackView.addArrangedSubview(userMeetingLabel)
        
        if let image = Bundle.main.image(forResource: "call") {
            
            if let lastView = stackView.views.last {
                stackView.setCustomSpacing(48, after: lastView)
            }
            
            stackView.addArrangedSubview(NSImageView(image: image))
        }
        
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        stackView.setThemeableViewColors()
    }
    
    override func onLanguageChanged() {
        
        titleLabel.stringValue       = LocalizationStrings.freeCallUserTitle
        userCallLabel.labelString    = LocalizationStrings.freeCallUserCallDetail
        userMeetingLabel.labelString = LocalizationStrings.freeCallUserMeetingDetail
        
        super.onLanguageChanged()
    }
    
}
