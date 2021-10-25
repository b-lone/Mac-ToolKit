//
//  UTAvatarView.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 19/06/2021.
//

import Cocoa

public class UTAvatarView: UTHoverableView {
    
    public enum Size : CGFloat {
        
        ///24 x 24
        case extraSmall = 24
        
        ///32 x 32
        case small = 32
        
        ///48 x 48
        case medium = 48
        
        ///72 x 72
        case large = 72
        
        ///88 x 88
        case extraLarge = 88
        
        ///124 x 124
        case extraExtraLarge = 124
        
        func getImageSize() ->  NSSize {
            return  NSSize(width: self.rawValue, height: self.rawValue)
        }
            
        func getFrameSize() ->  NSSize {
            return NSSize(width: self.rawValue + presenceRectWidthPadding, height: self.rawValue)
        }
        
        func getFrameRect() ->  NSRect {
            return NSRect(x:0, y:0, width: self.rawValue + presenceRectWidthPadding, height: self.rawValue)
        }
        
        
        ///The three smaller sizes have a 4 px padding for the presence
        ///icon that goes outside the avatar view. the three larger sizes don't need this
        var presenceRectWidthPadding : CGFloat {
            switch self {
            case .extraSmall: return 4
            case .small: return 4
            case .medium: return 4
            case .large: return 0
            case .extraLarge: return 0
            case .extraExtraLarge: return 0
            }
        }
        
        var presenceRectYPos : CGFloat {
            switch self {
            case .extraSmall: return -1
            case .small: return -1
            case .medium: return -1
            case .large: return -2
            case .extraLarge: return -2
            case .extraExtraLarge: return -2
            }
        }
        
        public var initialsFont : NSFont {
            switch self {
            case .extraSmall: return UTFontType.labelCompact.font()
            case .small: return UTFontType.subheaderSecondary.font()
            case .medium: return UTFontType.title.font()
            case .large: return UTFontType.bannerPrimary.font()
            case .extraLarge: return UTFontType.bannerPrimary.font()
            case .extraExtraLarge: return UTFontType.display.font()
            }
        }
     }
    
    public var backgroundStyle:UTTeamStyle = .defaultStyle
    public var isFocusable: Bool = false
    
    public override var focusRingMaskBounds: NSRect {
        return NSRect(x:0, y:0, width: self.bounds.width - size.presenceRectWidthPadding, height: self.bounds.height)
    }
    
    override public var acceptsFirstResponder: Bool{
        if isFocusable {
            return true
        }
        
        return super.acceptsFirstResponder
    }
    
    private var imageView:NSImageView!
    private var presenceIconView:PresenceIconView!
    private var typingImage:NSImageView?
    private static var currentBundle = Bundle.getUIToolKitBundle()!
     
    private var defaultBackgroundToken : String {
        return UIToolkit.shared.isUsingLegacyTokens ? "wx-default-avatar-background" :  UTColorTokens.avatarColorAvatarBackgroundDefault.rawValue
    }
    
    private var avatarInitialsToken : String {
        return UIToolkit.shared.isUsingLegacyTokens ? "wx-avatarInitials-text" : UTColorTokens.avatarColorAvatarText.rawValue
    }
    
    private var defaultBackgroundColor : CCColor {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: defaultBackgroundToken).normal
    }
    
    private var avatarInitialsColor : CCColor {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: avatarInitialsToken).normal
    }
    
    private var size:UTAvatarView.Size {
        return dataSource?.size ?? Size.extraSmall
    }
    
    init() {
        let rect = Size.extraSmall.getFrameRect()
        super.init(frame: rect)
    }
        
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    public init(size:UTAvatarView.Size) {
        let rect = size.getFrameRect()
        super.init(frame: rect)
        dataSource = AvatarImageViewDataSource(size: size, avatar: NSImage())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func initialise() {
        super.initialise()
        
        //Since the contact card manager is handling the
        //delay set the hover delay to 0
        hoverDelay = 0        
    }
    
    public override var intrinsicContentSize: NSSize{
        guard let size = dataSource?.size else {
            print("no size")
            return NSSize(width: 0,height: 0)
        }
        return size.getFrameSize()
    }
    
    
    public var dataSource:AvatarImageViewDataSourceProtocol! {
        didSet {
            self.invalidateIntrinsicContentSize()
            refresh()
        }
    }
    
    public var isTyping: Bool = false {
        didSet {
            refresh()
        }
    }
    
    public func refresh() {
        guard let dataSource = dataSource else {
            //assert(false, "datasource not set")//
            return
        }
        self.wantsLayer = true
        imageView?.removeFromSuperview()
        let type = dataSource.avatarType
        self.frame = NSRect(x: 0, y: 0, width: dataSource.size.rawValue, height: dataSource.size.rawValue)
        switch type {
        case .defaultAvatar: break
        case .defaultExConferenceAvatar,
            .lockedIconWithBackground,
            .pair,
            .meetingIcon:
            removePresenceIcon()
            drawIconWithBackground(dataSource: dataSource)
        case .image:
            if let image = dataSource.avatar {
                drawImage(image: image)
                addPresenceIcon()
            }
        case .initialsWithBackground:
            drawInitialsWithBackground(dataSource: dataSource)
            addPresenceIcon()
        case .messageSentBySelf:
            removePresenceIcon()
            drawSelfMessage(dataSource: dataSource)
        case .unknown: break
        }
        
        setTyping(isTyping: isTyping)
        self.needsDisplay = true
    }
    
    private func drawInitialsWithBackground(dataSource: AvatarImageViewDataSourceProtocol) {

        let size      = dataSource.size
        let theRect   = NSRect(x: 0, y: 0, width: size.rawValue, height: size.rawValue)
        let textAttrs = textAttributesFrom(data: dataSource)
        let initials  = NSAttributedString(string: dataSource.initials, attributes: textAttrs)
        
        let image = generateBackgroundImage(backgroundRect: theRect, attrString: initials)
        addImageView(image: image, size: size.getImageSize())
    }
    
    private func drawIconWithBackground(dataSource: AvatarImageViewDataSourceProtocol) {
        
        let size    = dataSource.size
        let theRect = NSRect(x: 0, y: 0, width: size.rawValue, height: size.rawValue)
        
        var icon:NSAttributedString?

        switch dataSource.avatarType {
        case .lockedIconWithBackground:
            icon = getLockIcon(from: dataSource)
        case .pair:
            icon = getPairedIcon(from: dataSource)
        case .defaultExConferenceAvatar:
            icon = getMeetIcon(from: dataSource)
        case .meetingIcon:
            icon = getScheduledMeetingIcon(from: dataSource)
        default:
            break
        }
             
        guard let iconStr = icon else {
            NSLog("unsupported type")
            return
        }
        
        let image = generateBackgroundImage(backgroundRect: theRect, attrString: iconStr)
        addImageView(image: image, size: size.getImageSize())
    }
    
    private func setTyping(isTyping: Bool){
        
        guard let dataSource = self.dataSource,  dataSource.size == .extraSmall else {
            NSLog("Set typing is not supported for avatar size")
            return
        }
        
        typingImage?.removeFromSuperview()

        if isTyping {
            if typingImage == nil {
                typingImage = NSImageView(frame: self.frame)
                typingImage?.wantsLayer = true
                typingImage?.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(token: UTColorTokens.overlayFadeSecondaryBackground).normal.cgColor //temp until we get spec
                typingImage?.layer?.cornerRadius = bounds.width / 2.0
                typingImage?.layer?.masksToBounds = true
                typingImage?.animates = true
                let image =  UTAvatarView.currentBundle.image(forResource: "istyping")
                typingImage?.image = image
            }
            if let typingImage = typingImage {
                self.addSubview(typingImage)
            }
        } else {
            typingImage?.removeFromSuperview()
            typingImage = nil
        }
        
    }
    
    
    private func drawSelfMessage(dataSource: AvatarImageViewDataSourceProtocol) {
        
        let size = dataSource.size
        let imageSize = size.getImageSize()
        let image = NSImage(size: imageSize)
        image.lockFocus()
        
        guard let context = NSGraphicsContext.current?.cgContext else {
            image.unlockFocus()
            return
        }
        
        let iconColor   = UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarChatBubbleIconNormal.rawValue).normal
        let borderColor = UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.avatarChatBubbleBorderNormal.rawValue).normal
        let theRect = NSMakeRect(0, 0, imageSize.width, imageSize.height)
        let circlePath = CGPath(ellipseIn: theRect, transform: nil)
        
        context.interpolationQuality = .high
        
        context.addPath(circlePath)
        context.clip()
        
        context.setLineWidth(2)
        context.setStrokeColor(borderColor.cgColor)
        context.strokeEllipse(in: theRect)
        
        
        let icon = getChatIcon(from: dataSource, color: iconColor)
        let iconHeight = icon.size().height
        
        icon.drawCentred(in: bounds, yDelta: iconHeight / 8)
        
        image.unlockFocus()
        
        addImageView(image: image, size: size.getImageSize())
    }
    
    //Create a background circle with text of icon drawn in the centre as an image
    private func generateBackgroundImage(backgroundRect:NSRect, attrString:NSAttributedString) -> NSImage {
        
        let image = NSImage(size: backgroundRect.size)
        image.lockFocus()
        
        guard let context = NSGraphicsContext.current?.cgContext else {
            image.unlockFocus()
            return image
        }
        
        context.interpolationQuality = .high
        let circlePath = CGPath(ellipseIn: backgroundRect, transform: nil)
        context.addPath(circlePath)
        context.clip()
        let bgColor = dataSource.bgColor ?? defaultBackgroundColor
        context.setFillColor(bgColor.cgColor)
        context.fill(self.bounds)
        attrString.drawCentred(in: bounds)
        image.unlockFocus()
        
        return image
    }
    
    private func addImageView(image:NSImage, size:NSSize){
        self.imageView                      = NSImageView(frame: NSRect(x: 0, y: 0, width: size.width, height: size.height))
        self.imageView.wantsLayer           = true
        self.imageView.layer?.masksToBounds = true
        self.imageView.layer?.cornerRadius  =  size.height / 2
        self.imageView.image                = image
        self.layer?.layoutIfNeeded()
        self.addSubview(imageView)
    }
    
    private func textAttributesFrom(data: AvatarImageViewDataSourceProtocol) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: avatarInitialsColor]
        attributes[NSAttributedString.Key.font] = size.initialsFont        
        return attributes
    }
    
    private func getLockIcon(from data: AvatarImageViewDataSourceProtocol) -> NSAttributedString {
        return getAvatarIcon(size: data.size.rawValue, boldIcon: .privateBold, regularIcon: .privateRegular, lightIcon: .privateLight, color: avatarInitialsColor)
    }
    
    private func getPairedIcon(from data: AvatarImageViewDataSourceProtocol) -> NSAttributedString {
        return getAvatarIcon(size: data.size.rawValue, boldIcon: .pairedDeviceBold, regularIcon: .pairedDeviceRegular, lightIcon: .pairedDeviceLight, color: avatarInitialsColor)
    }
    
    private func getMeetIcon(from data: AvatarImageViewDataSourceProtocol) -> NSAttributedString {
        return getAvatarIcon(size: data.size.rawValue, boldIcon: .meetBold, regularIcon: .meetRegular, lightIcon: .meetLight, color: avatarInitialsColor)
    }

    private func getScheduledMeetingIcon(from data: AvatarImageViewDataSourceProtocol) -> NSAttributedString {
        return getAvatarIcon(size: data.size.rawValue, boldIcon: .meetingsBold, regularIcon: .meetingsRegular, lightIcon: .meetingsLight, color: avatarInitialsColor)
    }
    
    private func getAvatarIcon(size:CGFloat, boldIcon:MomentumRebrandIconType, regularIcon:MomentumRebrandIconType, lightIcon:MomentumRebrandIconType, color:CCColor) -> NSAttributedString {
        let fontSize = size * 0.46
        var momentumIcon:MomentumRebrandIconType = boldIcon
        
        if fontSize > 32 {
            momentumIcon = lightIcon
        }
        else if fontSize > 15 {
            momentumIcon = regularIcon
        }
        
        return NSAttributedString.getAttributedString(iconType: momentumIcon, iconSize: max(fontSize, 12), color: color)
    }
    
    private func getChatIcon(from data: AvatarImageViewDataSourceProtocol, color:CCColor) -> NSAttributedString {
        let fontSize = data.size.rawValue * 0.46
        let momentumIcon:MomentumRebrandIconType = .chatFilled
        
        return NSAttributedString.getAttributedString(iconType: momentumIcon, iconSize: max(fontSize, 12), color: color)
    }
    
    private func drawImage(image:NSImage) {
    
        guard let size = dataSource?.size else {
            return
        }
        
        let x = frame.size.width / 2 - dataSource.size.rawValue / 2
        let y = frame.size.height / 2 - dataSource.size.rawValue / 2
        let cropImage = image.cropImageForAvatar(NSRect(x: 0, y: 0, width: size.rawValue, height: size.rawValue))
        imageView = NSImageView(frame: NSRect(x: x, y: y, width: size.rawValue, height: size.rawValue))
        imageView.wantsLayer = true
        imageView.image = cropImage
        imageView.layer?.masksToBounds = true
        imageView.layer?.cornerRadius =  size.rawValue/2
        self.layer?.layoutIfNeeded()
        self.addSubview(imageView)
    }
    
    private func addPresenceIcon() {
        
        guard let config = dataSource else {
            assert(false, "avatarImageViewDataSource is nil ")
            return
        }
        
        if config.presenceState == .none {
            presenceIconView?.removeFromSuperview()
            return
        }
        
        if presenceIconView != nil {
            presenceIconView.removeFromSuperview()
        }
        
        presenceIconView = PresenceIconView(frame: getPresenceRect(size: config.size))
        presenceIconView.dataSource = config
        presenceIconView.wantsLayer = true

        presenceIconView.layer?.masksToBounds = false
        self.addSubview(presenceIconView)
        enableDebugBorder(enable: false)
    }
        
    func getPresenceOuterCircleSize(size:UTAvatarView.Size) -> CGFloat {
        switch size {
        case .extraExtraLarge: return 44
        case .extraLarge: return  32
        case .large: return 24
        case .medium: return 18
        case .small: return 16
        case .extraSmall: return 16
        }
    }
    
    func getPresenceRect(size:UTAvatarView.Size) -> NSRect {
        
        let circleSize = getPresenceOuterCircleSize(size: size)
        let width = self.bounds.width
        let xPos = (width - circleSize) + size.presenceRectWidthPadding
        let yPos = size.presenceRectYPos
        
        return NSMakeRect(xPos, yPos, circleSize, circleSize)
    }
    
    internal func enableDebugBorder(enable: Bool) {
        if enable {
            self.wantsLayer = true
            self.layer?.borderWidth = 1
            presenceIconView.layer?.borderWidth = 1
            presenceIconView.layer?.borderColor = NSColor.red.cgColor
        } else {
            self.layer?.borderWidth = 0
            presenceIconView.layer?.borderWidth = 0
            presenceIconView.layer?.borderColor = NSColor.red.cgColor
        }
        
        presenceIconView.enableDebugBorder(enable: enable)
    }
    
    override public func setThemeColors() {
        refresh()
        presenceIconView?.setThemeColors()
    }
    
    private func removePresenceIcon() {
        presenceIconView?.removeFromSuperview()
        presenceIconView = nil
    }
    
    public override func drawFocusRingMask() {
        let path = NSBezierPath(ovalIn: NSMakeRect(0, 0, self.bounds.width - size.presenceRectWidthPadding, self.bounds.height))
        path.fill()
    }

}
