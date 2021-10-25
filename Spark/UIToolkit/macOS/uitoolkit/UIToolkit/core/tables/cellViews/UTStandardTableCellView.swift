//
//  UTStandardTableCellView.swift
//  UIToolkit
//
//  Created by James Nestor on 10/06/2021.
//

import Cocoa

class UTStandardTableCellView : UTTableCellView {
    
    //Container stack view
    private var containerStackView:NSStackView!
    
    //Avatar
    private var avatarView: UTAvatarView!
    
    //Title stack view
    private var titleStackView: NSStackView!
    private var titleLabel:UTLabel!
    private var titleSecondLinelabel:UTLabel!
    
    //Sub title
    private var subtitleStackView:NSStackView!
    private var subTitleLabel:UTLabel!
    private var subtitleSecondLineStackView:NSStackView!
    private var subTitleSecondLineLabel:UTLabel!
    
    private var subTitleIcons:[UTIcon] = []
    
    //Indicator
    private var indicatorBadges:[UTIndicatorBadge] = []
    
    //Hover and selection buttons
    private var hoverButtons:[UTButton] = []
    
    private var callButton:UTButton?
    
    private var isSelected:Bool = false
    private var uniqueId:String = ""
    
    override internal func initialise(){
        
        //Configure container stack view
        containerStackView              = NSStackView()
        containerStackView.wantsLayer   = true
        containerStackView.orientation  = .horizontal
        containerStackView.edgeInsets   = NSEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        containerStackView.distribution = .fillProportionally
        containerStackView.identifier   = NSUserInterfaceItemIdentifier(rawValue: "ContainerStackView")
        containerStackView.setClippingResistancePriority(.init(751), for: .horizontal)
                
        setAsOnlySubviewAndFill(subview: containerStackView)
        
        avatarView = UTAvatarView()
                
        //Title section
        titleStackView              = NSStackView()
        titleStackView.wantsLayer   = true
        titleStackView.distribution = .fillProportionally
        titleStackView.orientation  = .vertical
        titleStackView.alignment    = .leading
        titleStackView.spacing      = 0
        titleStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleStackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        titleStackView.identifier = NSUserInterfaceItemIdentifier(rawValue: "TitleStackView")
        
        titleLabel = UTLabel(fontType: .bodyPrimary, tokenName: "text-primary")
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleSecondLinelabel = UTLabel(fontType: .bodyCompact, tokenName: "text-secondary")
        titleSecondLinelabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleSecondLinelabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleSecondLinelabel)

        //Subtitle section
        subtitleStackView                = NSStackView()
        subtitleStackView.wantsLayer     = true
        subtitleStackView.orientation    = .vertical
        subtitleStackView.alignment      = .right
        subtitleStackView.edgeInsets.top = 4
        subtitleStackView.spacing        = 2
        subtitleStackView.setHuggingPriority(.required, for: .vertical)
        subtitleStackView.identifier = NSUserInterfaceItemIdentifier(rawValue: "SubtitleStackView")
                
        subTitleLabel = UTLabel(fontType: .bodyCompact, tokenName: "text-secondary")
        subTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        subTitleLabel.identifier = NSUserInterfaceItemIdentifier(rawValue: "SubTitleLabel")
        
        subtitleStackView.addArrangedSubview(subTitleLabel)
        
        //Subtitle second line stack view
        subtitleSecondLineStackView              = NSStackView()
        subtitleSecondLineStackView.wantsLayer   = true
        subtitleSecondLineStackView.orientation  = .horizontal
        subtitleSecondLineStackView.alignment    = .centerY
        subtitleSecondLineStackView.distribution = .fillProportionally
        subtitleSecondLineStackView.identifier   = NSUserInterfaceItemIdentifier(rawValue: "SubtitleSecondLineStackView")
        subtitleSecondLineStackView.spacing      = 6
        subtitleSecondLineStackView.setHuggingPriority(.required, for: .vertical)
                
        subTitleSecondLineLabel = UTLabel(fontType: .bodyCompact, tokenName: "text-secondary")
        subTitleSecondLineLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subTitleSecondLineLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        subTitleSecondLineLabel.identifier = NSUserInterfaceItemIdentifier(rawValue: "SubTitleSecondLineLabel")
                
        subtitleSecondLineStackView.addArrangedSubview(subTitleSecondLineLabel)
        subtitleSecondLineStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        subtitleStackView.addArrangedSubview(subtitleSecondLineStackView)
        subtitleSecondLineStackView.addArrangedSubview(subTitleSecondLineLabel)
        
        containerStackView.addArrangedSubview(avatarView)
        containerStackView.addArrangedSubview(titleStackView)
        containerStackView.addArrangedSubview(subtitleStackView)
        
        updateButtonVisibility(bShow: false)
        
        super.initialise()
    }
    
    override public func setThemeColors() {
        
        avatarView.setThemeColors()
        titleLabel.setThemeColors()
        titleSecondLinelabel.setThemeColors()
        
        subTitleLabel.setThemeColors()
        subTitleSecondLineLabel.setThemeColors()
        
        for badge in indicatorBadges{
            badge.setThemeColors()
        }
        
        for icon in subTitleIcons {
            icon.setThemeColors()
        }

        for button in hoverButtons {
            button.setThemeColors()
        }
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func updateData(data:UTStandardTableCellViewData, isSelected: Bool){
        
        self.uniqueId = data.uniqueId
        self.isSelected = isSelected

        self.titleLabel.attributedStringValue = data.primaryTitleLabel
        
        self.titleSecondLinelabel.stringValue = data.primaryTitleSecondLineLabel ?? ""
        self.titleSecondLinelabel.isHidden = data.primaryTitleSecondLineLabel?.isEmpty == true

        self.subTitleLabel.stringValue = data.subTitleLabel ?? ""
        self.subTitleLabel.isHidden = data.subTitleLabel?.isEmpty == true
        
        self.subTitleSecondLineLabel.stringValue = data.subTitleSecondLineLabel ?? ""
        self.subTitleSecondLineLabel.isHidden = data.subTitleSecondLineLabel?.isEmpty == true

        //Remove old buttons and add new ones
        containerStackView.removeViews(items: indicatorBadges)
        containerStackView.removeViews(items: hoverButtons)
        subtitleSecondLineStackView.removeViews(items: subTitleIcons)
        
        if let callButton = callButton {
            containerStackView.removeView(callButton)
        }
        
        avatarView.dataSource = AvatarImageViewDataSource(size: .small, name: data.primaryTitleLabel.string, bgColor: NSColor.gray)
        
        indicatorBadges = data.indicatorBadges
        hoverButtons    = data.hoverButtons
        subTitleIcons   = data.subtitleIcons
        callButton      = data.callButton
                
        for icon in subTitleIcons{
            subtitleSecondLineStackView.insertArrangedSubview(icon, at: 0)
        }
        
        for badge in indicatorBadges {
            containerStackView.addArrangedSubview(badge)
        }
        
        for button in hoverButtons {
            containerStackView.addArrangedSubview(button)
        }
        
        if let callButton = callButton {
            containerStackView.addArrangedSubview(callButton)
        }
        
        self.updateButtonVisibility(bShow: isSelected || isMouseInVisibleRect)
        setThemeColors()
    }
    
    public func updateCallButtonText(text:String){
        callButton?.title = text
    }
       
    private func updateButtonVisibility(bShow:Bool){
        
        for button in hoverButtons {
            button.isHidden = !bShow || callButton != nil
        }
        
        subtitleStackView.isHidden = bShow || callButton != nil
        
        for badge in indicatorBadges {
            badge.isHidden = bShow || callButton != nil
        }
    }
    
    override func mouseInRowUpdated(mouseInside: Bool) {
        updateButtonVisibility(bShow: mouseInside || isSelected)
    }
}
