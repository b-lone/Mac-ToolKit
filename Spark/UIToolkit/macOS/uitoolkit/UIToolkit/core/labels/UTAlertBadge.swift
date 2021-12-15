//
//  UTAlertBadge.swift
//  UIToolkit
//
//  Created by James Nestor on 30/06/2021.
//

import Cocoa

public enum UTAlertBadgeStyle {
    
    case defaultBadge
    case announcement
    case alertWarning
    case important
    case alertGeneral
    
    var fontToken:String {
        switch self {
        case .defaultBadge: return UTColorTokens.alertbadgeDefaultText.rawValue
        case .announcement: return UTColorTokens.alertbadgeAnnouncementText.rawValue
        case .alertWarning: return UTColorTokens.alertbadgeWarningText.rawValue
        case .important:    return UTColorTokens.alertbadgeImportantText.rawValue
        case .alertGeneral: return UTColorTokens.alertbadgeGeneralText.rawValue
        }
    }
    
    var backgroundToken:String{
        switch self {
        case .defaultBadge: return UTColorTokens.alertbadgeDefaultBackground.rawValue
        case .announcement: return UTColorTokens.alertbadgeAnnouncementBackground.rawValue
        case .alertWarning: return UTColorTokens.alertbadgeWarningBackground.rawValue
        case .important:    return UTColorTokens.alertbadgeImportantBackground.rawValue
        case .alertGeneral: return UTColorTokens.alertbadgeGeneralBackground.rawValue
        }
    }
}

public class UTAlertBadge : UTBaseButton {
    
    public enum DisplayMode {
        case icon
        case label
        case iconAndLabel
    }
    
    public var style: UTAlertBadgeStyle = .alertGeneral {
        didSet {
            setThemeColors()
        }
    }
    
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        return 20
    }
    
    override var trailingPadding:CGFloat {
        return 8
    }
    
    override var leadingPadding:CGFloat {
        return 8
    }
    
    override func initialise(){
        super.buttonType = .pill
        super.buttonHeight = .small
        super.fontIconSize = 12
        super.buttonType = .rounded
        
        super.elementSize.minIntrinsicWidth = 28
        super.elementSize.elementPadding = 4
        super.initialise()
        
        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    override func updateLabelFontSize() {
        self.labelFont = .bodySecondary
    }
    
    override func setTokensFromStyle() {
        
        if style.backgroundToken != backgroundTokenName {
            backgroundTokenName = style.backgroundToken
        }
        
        if style.fontToken != fontTokenName {
            fontTokenName = style.fontToken
        }
            
        if style.fontToken != iconTokenName {
            iconTokenName = style.fontToken
        }
    }
    
    public init(style:UTAlertBadgeStyle, iconType:MomentumIconsRebrandType, title:String, displayMode:DisplayMode = .iconAndLabel){
        super.init(frame: NSZeroRect)
        self.style       = style
        self.fontIcon    = iconType
        self.title = title
        self.displayMode = displayMode
        
        initialise()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public var displayMode:DisplayMode = .iconAndLabel{
        didSet {
            updateDisplayMode()
        }
    }
    
    private func updateDisplayMode() {
        //TODO :
    }
}
