//
//  TestSpaceCellView.swift
//  ComponentApp
//
//  Created by James Nestor on 02/07/2021.
//

import Cocoa
import UIToolkit

//MARK: - Test regular space cell. One or two line with with indicator (unread /  mention etc)
class UTTestSpaceTableCellView : UTTableCellView {
    
    //Container stack view
    private var containerStackView:NSStackView!
    
    //Avatar
    private var avatarView: UTAvatarView!
    
    //Title stack view
    private var titleStackView: NSStackView!
    private var titleLabel:UTLabel!
    private var titleSecondLinelabel:UTLabel!
    private var indicatorBadge:UTIndicatorBadge!
    
    private var isSelected:Bool = false
    private weak var data:TestSpaceListData?
    
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

        //Avatar
        avatarView = UTAvatarView()
                
        //Title section
        titleStackView              = NSStackView()
        titleStackView.wantsLayer   = true
        titleStackView.distribution = .fillProportionally
        titleStackView.orientation  = .vertical
        titleStackView.alignment    = .leading
        titleStackView.spacing      = 0
        titleStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleStackView.identifier = NSUserInterfaceItemIdentifier(rawValue: "TitleStackView")
        
        titleLabel = UTLabel(fontType: .bodyPrimary, style: .primary)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleSecondLinelabel = UTLabel(fontType: .bodyCompact, style: .secondary)
        titleSecondLinelabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleSecondLinelabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleSecondLinelabel)
        
        //Indicator badge (unread message/mention etc.)
        indicatorBadge = UTIndicatorBadge()
        indicatorBadge.badgeType = .noBadge
                
        //Add components to container
        containerStackView.addArrangedSubview(avatarView)
        containerStackView.addArrangedSubview(titleStackView)
        containerStackView.addArrangedSubview(indicatorBadge)
        
        super.initialise()
    }
    
    override public func setThemeColors() {
        
        avatarView.setThemeColors()
        titleLabel.setThemeColors()
        
        if let data = data,
           let teamData = data.teamData {
            self.titleSecondLinelabel.textColor = UIToolkit.shared.getThemeManager().isDarkTheme() ? teamData.darkColor : teamData.lightColor
        }
        else{
            self.titleSecondLinelabel.setThemeColors()
        }
        
        indicatorBadge.setThemeColors()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func updateData(data:TestSpaceListData, isSelected: Bool){
        
        self.isSelected = isSelected
        self.data = data

        self.titleLabel.stringValue = data.displayName
        self.titleSecondLinelabel.isHidden = !data.isTeamSpace
        
        if isSelected {
            titleLabel.fontType = .highlightPrimary
        }
        else {
            titleLabel.fontType = .bodyPrimary
        }

        if let teamData = data.teamData {
            self.titleSecondLinelabel.stringValue = teamData.teamName
        }
        
        avatarView.dataSource = AvatarImageViewDataSource(presenceState: data.presence, size: .small, name: data.displayName, bgColor: data.avatarColor)
        
        self.indicatorBadge.badgeType = data.notificationState.asIndicatorType()
        if self.indicatorBadge.badgeType != .noBadge {
            self.indicatorBadge.isHidden = false
        }
        
        setThemeColors()
    }
   
    override func mouseInRowUpdated(mouseInside: Bool) {}
}


protocol UTTestSpaceCallTableCellViewDelegate : AnyObject {
    func participantButtonHoverChanged(sender:UTView, isHovered: Bool)
    func callButtonAction(sender:Any)
}

//MARK: - Test space on a call. One or two line with timer call button. Include participant icon button which can be hovered
class UTTestSpaceCallTableCellView : UTTableCellView {
 
    public weak var delegate:UTTestSpaceCallTableCellViewDelegate?
    
    //Container stack view
    private var containerStackView:NSStackView!
    
    //Avatar
    private var avatarView: UTAvatarView!
    
    //Title stack view
    private var titleStackView: NSStackView!
    private var titleLabel:UTLabel!
    private var titleSecondLinelabel:UTLabel!
    private var callButton:UTPillButton!
    private var hoverIconLabel:UTIconLabel!
    
    private var isSelected:Bool = false
    private weak var data:TestSpaceListData?
    
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
        
        //Avatar
        avatarView = UTAvatarView()
                
        //Title section
        titleStackView              = NSStackView()
        titleStackView.wantsLayer   = true
        titleStackView.distribution = .fillProportionally
        titleStackView.orientation  = .vertical
        titleStackView.alignment    = .leading
        titleStackView.spacing      = 0
        titleStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleStackView.identifier = NSUserInterfaceItemIdentifier(rawValue: "TitleStackView")
        
        titleLabel = UTLabel(fontType: .bodyPrimary, style: .primary)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleSecondLinelabel = UTLabel(fontType: .bodyCompact, style: .secondary)
        titleSecondLinelabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleSecondLinelabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleSecondLinelabel)
        
        hoverIconLabel = UTIconLabel(iconType: .peopleBold, iconSize: .large, label: "00", fontType: .bodyCompact, style: .primary, iconAlignment: .right, enableHover: true)
        hoverIconLabel.hoverDelegate = self
        
        //call button
        callButton = UTPillButton()
        callButton?.buttonHeight = .small
        callButton?.style        = .join
        callButton?.title        = ""
        callButton?.action       = #selector(callButtonAction)
        callButton?.target       = self
                
        //Add components to container
        containerStackView.addArrangedSubview(avatarView)
        containerStackView.addArrangedSubview(titleStackView)
        containerStackView.addArrangedSubview(hoverIconLabel)
        containerStackView.addArrangedSubview(callButton)
        
        super.initialise()
    }
    
    override public func setThemeColors() {
        
        avatarView.setThemeColors()
        titleLabel.setThemeColors()
        
        if let data = data,
           let teamData = data.teamData {
            self.titleSecondLinelabel.textColor = UIToolkit.shared.getThemeManager().isDarkTheme() ? teamData.darkColor : teamData.lightColor
        }
        else{
            self.titleSecondLinelabel.setThemeColors()
        }
        
        callButton.setThemeColors()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func updateData(data:TestSpaceListData, isSelected: Bool){
        
        self.isSelected = isSelected
        self.data = data

        self.titleLabel.stringValue = data.displayName
        self.titleSecondLinelabel.isHidden = !data.isTeamSpace
        
        if let teamData = data.teamData {
            self.titleSecondLinelabel.stringValue = teamData.teamName
        }
        
        avatarView.dataSource = AvatarImageViewDataSource(presenceState: data.presence, size: .small, name: data.displayName, bgColor: data.avatarColor)
        hoverIconLabel.label = String(data.callParticipantCount)
        
        callButton.title = String.formatCallDurationSinceDate(data.callStartTime)
        setThemeColors()
    }
    
    public func updateCallButtonText(text: String){
        callButton.title = text
    }
           
    override func mouseInRowUpdated(mouseInside: Bool) {}
    
    @IBAction func callButtonAction(_ sender:AnyObject) {
        delegate?.callButtonAction(sender: sender)
    }
    
}

extension UTTestSpaceCallTableCellView: UTHoverableViewDelegate {
    public func isHoveredChanged(sender: UTView, isHovered: Bool) {
        delegate?.participantButtonHoverChanged(sender: sender, isHovered: isHovered)
    }
}

//MARK: - Test compact row with one line display name. can also have a second label for team on same line
class UTTestCompactSpaceTableCellView : UTTableCellView {
    
    //Container stack view
    private var containerStackView:NSStackView!
    
    //Avatar
    private var avatarView: UTAvatarView!
    
    //Title stack view
    private var titleStackView: NSStackView!
    private var titleLabel:UTLabel!
    private var titleSecondLinelabel:UTLabel!
    private var indicatorBadge:UTIndicatorBadge!
    
    private var dot:UTLabel!
    
    private var isSelected:Bool = false
    private weak var data:TestSpaceListData?
    
    override internal func initialise(){
        
        //Configure container stack view
        containerStackView              = NSStackView()
        containerStackView.wantsLayer   = true
        containerStackView.orientation  = .horizontal
        containerStackView.edgeInsets   = NSEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        containerStackView.distribution = .gravityAreas
        containerStackView.identifier   = NSUserInterfaceItemIdentifier(rawValue: "ContainerStackView")
        containerStackView.setClippingResistancePriority(.init(751), for: .horizontal)
        containerStackView.spacing = 12
                
        setAsOnlySubviewAndFill(subview: containerStackView)
        
        avatarView = UTAvatarView()
                
        //Title section
        titleStackView              = NSStackView()
        titleStackView.wantsLayer   = true
        titleStackView.distribution = .fillProportionally
        titleStackView.orientation  = .horizontal
        titleStackView.spacing      = 8
        titleStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleStackView.identifier = NSUserInterfaceItemIdentifier(rawValue: "TitleStackView")

        titleLabel = UTLabel(fontType: .bodyCompact)
        titleLabel.setContentHuggingPriority(.init(751), for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleSecondLinelabel = UTLabel(fontType: .bodyCompact, style: .secondary)
        titleSecondLinelabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleSecondLinelabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        dot = UTLabel(fontType: .bodyCompact, style: .secondary)
        dot.stringValue = "•"
        dot.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(dot)
        titleStackView.addArrangedSubview(titleSecondLinelabel)
        
        //Indicator badge (unread message/mention etc.)
        indicatorBadge = UTIndicatorBadge()
        indicatorBadge.badgeType = .noBadge
                
        //Add components to container
        containerStackView.addView(avatarView, in: .leading)
        containerStackView.addView(titleStackView, in: .leading)
        containerStackView.addView(indicatorBadge, in: .trailing)
        
        super.initialise()
    }
    
    override public func setThemeColors() {
        
        avatarView.setThemeColors()
        titleLabel.setThemeColors()
        
        if let data = data,
           let teamData = data.teamData {
            self.titleSecondLinelabel.textColor = UIToolkit.shared.getThemeManager().isDarkTheme() ? teamData.darkColor : teamData.lightColor
        }
        else{
            self.titleSecondLinelabel.setThemeColors()
        }
        
        indicatorBadge.setThemeColors()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func updateData(data:TestSpaceListData, isSelected: Bool){
        
        self.isSelected = isSelected
        self.data = data

        self.titleLabel.stringValue = data.displayName
        self.titleSecondLinelabel.isHidden = !data.isTeamSpace
        self.dot.isHidden = !data.isTeamSpace
        
        if let teamData = data.teamData {
            self.titleSecondLinelabel.stringValue = teamData.teamName
        }
        
        avatarView.dataSource = AvatarImageViewDataSource(presenceState: data.presence, size: .extraSmall, name: data.displayName, bgColor: data.avatarColor)
        
        self.indicatorBadge.badgeType = data.notificationState.asIndicatorType()
        if self.indicatorBadge.badgeType != .noBadge {
            self.indicatorBadge.isHidden = false
        }
        
        setThemeColors()
    }
   
    override func mouseInRowUpdated(mouseInside: Bool) {}
}

class UTTestSpaceHeaderTableCellView : UTTableCellView {
    
    //Container stack view
    private var containerStackView:NSStackView!
    
    private var titleLabel:UTLabel!
    private var isSelected:Bool = false
    private weak var data:TestSpaceHeader?
    private var arrowIcon:UTClearIconButton!
    
    override internal func initialise(){
        
        //Configure container stack view
        containerStackView              = NSStackView()
        containerStackView.wantsLayer   = true
        containerStackView.orientation  = .horizontal
        containerStackView.edgeInsets   = NSEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        containerStackView.distribution = .gravityAreas
        containerStackView.identifier   = NSUserInterfaceItemIdentifier(rawValue: "ContainerStackView")
        containerStackView.setClippingResistancePriority(.init(751), for: .horizontal)
        containerStackView.spacing = 12
                
        setAsOnlySubviewAndFill(subview: containerStackView)

        titleLabel = UTLabel(fontType: .bodyCompact)
        titleLabel.setContentHuggingPriority(.init(751), for: .horizontal)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        arrowIcon = UTClearIconButton()
        arrowIcon.fontIcon = .arrowDownBold
        //arrowIcon.icon
        
        //Add components to container
        containerStackView.addView(titleLabel, in: .leading)
        containerStackView.addView(arrowIcon, in: .trailing)
        
        super.initialise()
    }
    
    func setButtonAction(sel:Selector, target:AnyObject){
        arrowIcon.action = sel
        arrowIcon.target = target
    }
    
    override public func setThemeColors() {
        
        titleLabel.setThemeColors()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func updateData(data:TestSpaceHeader, isSelected: Bool){
        
        self.isSelected = isSelected
        self.data = data

        self.titleLabel.stringValue = data.title
        
        setThemeColors()
    }
   
    override func mouseInRowUpdated(mouseInside: Bool) {}
}
