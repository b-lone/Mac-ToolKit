//
//  PresenceIconView.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 17/06/2021.
//

import Cocoa

class PresenceIconTextLayer : CATextLayer {

    override func draw(in context: CGContext) {
        let height = self.bounds.size.height
        let yDiff = ((height - fontSize) / 2)

        context.saveGState()
        context.translateBy(x: 0, y: -yDiff)
        super.draw(in: context)
        context.restoreGState()
   }
}

class PresenceIconView: NSView, CALayerDelegate, ThemeableProtocol {
    
    private var containerLayer = CALayer()
    private var shapeLayer = CAShapeLayer()
    private var iconLayer = PresenceIconTextLayer()
    
    var dataSource:AvatarImageViewDataSourceProtocol! {
        didSet {
            initialise()
        }
    }
    
    var size:UTAvatarView.Size {
        return dataSource?.size ?? .small
    }
    
    var presenceState: UTPresenceState {
        return dataSource?.presenceState ?? .none
    }
    
    private var isRoundedRect : Bool {
        switch presenceState {
        
        case .active,
              .dnd,
              .quiet,
              .pto,
              .recents,
              .callHold,
              .none:
            return false
             
        
        case .call,
             .meeting,
             .scheduleMeeting,
             .screenShare,
             .mobile,
             .device:
            return true
        }
    }
    
    private var isSmallAvatar : Bool {
        return size == .extraSmall || size == .small || size == .medium
    }
    
    private var backgroundToken:String {
        return UIToolkit.shared.isUsingLegacyTokens ? "background-secondary" : UTColorTokens.avatarPresenceIconBackground.rawValue
    }
    
    private func initialise() {
        self.wantsLayer = true
        containerLayer.masksToBounds = false
        containerLayer.frame = NSMakeRect(0, 0, frame.width, frame.height)
        layer?.addSublayer(containerLayer)
        iconLayer.delegate = self
        shapeLayer.delegate = self
        refresh()
    }
    
    func refresh() {
        setupShape()
        setupIcon()
        setBackingScale()
    }
    
    func setupShape() {
        
        shapeLayer.frame = self.bounds
        
        if isRoundedRect {
            shapeLayer.path = NSBezierPath(roundedRect: self.bounds.getAdjustedRect(adjust: 1), xRadius: 4, yRadius: 4).cgPath
        }
        else {
            //Circle
            shapeLayer.path = NSBezierPath(ovalIn: self.bounds.getAdjustedRect(adjust: 1)).cgPath
        }
        
        shapeLayer.fillColor = UIToolkit.shared.getThemeManager().getColors(tokenName: backgroundToken).normal.cgColor
        containerLayer.addSublayer(shapeLayer)
    }
    
    private func setBackingScale() {
        if let scale = window?.backingScaleFactor {
            containerLayer.contentsScale = scale
            iconLayer.contentsScale      = scale
            shapeLayer.contentsScale    = scale
        }
    }
    
    internal func enableDebugBorder(enable: Bool) {
        if enable {
            shapeLayer.borderWidth = 1
            shapeLayer.borderColor = NSColor.cyan.cgColor
            
            iconLayer.borderWidth = 1
            iconLayer.borderColor = NSColor.blue.cgColor
        } else {
            shapeLayer.borderWidth = 0
            iconLayer.borderWidth   = 0
        }
    }
    
    func setupIcon(){
        shapeLayer.addSublayer(iconLayer)
        
        let fontSize = CGFloat(getFontSize())
        let icon = getFont(state: dataSource.presenceState)
        let color = getColor(state: dataSource.presenceState)
        let fontIconAttString = NSMutableAttributedString.getIcon(fontName: icon.ligature, size:  fontSize, color: color)
        
        iconLayer.alignmentMode = .center
        iconLayer.fontSize = fontSize
        iconLayer.frame    = shapeLayer.frame
        
        iconLayer.string = fontIconAttString
    }
    
    func getFontSize() -> Int {
        switch dataSource.size {
        case .extraExtraLarge: return 36
        case .extraLarge: return 26
        case .large: return 20
        case .medium: return 14
        case .small: return 12
        case .extraSmall: return 12
        }
    }
    
    func getFont(state:UTPresenceState) -> MomentumRebrandIconType {
        
        switch state {
            case .active: return .unreadFilled
            case .call: return .handsetFilled
            case .dnd: return .dndPresenceSmallFilled
            case .meeting: return .cameraFilled
            case .scheduleMeeting: return .meetingsPresenceSmallFilled
            case .none: return .cameraPresenceFilled
            case .pto: return .ptoPresenceFilled
            case .quiet: return .quietHoursPresenceFilled
            case .recents: return .recentsPresenceSmallFilled
            case .screenShare: return .shareScreenSmallFilled
            case .mobile: return .phoneSmallFilled
            case .device: return .genericDeviceVideoSmallFilled
            case .callHold: return .pauseFilled
        }
    }
        
    func getColor(state:UTPresenceState) -> NSColor {
        switch state {
        case .active: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconActive.rawValue).normal
        case .call: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconMeeting.rawValue).normal
        case .dnd: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconDnd.rawValue).normal
        case .meeting: return  UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconMeeting.rawValue).normal
        case .scheduleMeeting: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconSchedule.rawValue).normal
        case .none: return .clear
        case .pto: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconOoo.rawValue).normal
        case .quiet: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconQuietHours.rawValue).normal
        case .recents: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconAway.rawValue).normal
        case .screenShare: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconPresenting.rawValue).normal
        case .mobile: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconAway.rawValue).normal
        case .device: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconAway.rawValue).normal
        case .callHold: return UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarPresenceIconAway.rawValue).normal
            
        }
    }
    
    override open func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        if let scale = window?.backingScaleFactor {
            iconLayer.contentsScale = scale
        }
    }
    
    func setThemeColors() {
        refresh()
    }
}

extension PresenceIconView: NSViewLayerContentScaleDelegate {
    public func layer(_ layer: CALayer, shouldInheritContentsScale newScale: CGFloat, from window: NSWindow) -> Bool { true }
}
