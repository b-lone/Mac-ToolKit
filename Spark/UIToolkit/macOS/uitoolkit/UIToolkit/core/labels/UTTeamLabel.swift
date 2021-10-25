//
//  UTTeamLabel.swift
//  UIToolkit
//
//  Created by James Nestor on 11/10/2021.
//

import Cocoa
import Carbon.HIToolbox

public protocol UTTeamLabelDelegate: AnyObject {
    func onLabelActioned(sender: UTTeamLabel)
}

public class UTTeamLabel: NSTextField, ThemeableProtocol, FontProtocol {
    
    //MARK: - Size enum
    public enum Size {
        
        ///bodyCompact
        case small
        
        ///bodySecondary
        case medium
        
        ///bodyLarge
        case large
        
        var fontType:UTFontType {
            switch self {
            case .small: return .bodyCompact
            case .medium: return .bodySecondary
            case .large: return .bodyPrimary
            }
        }
        
        var font:NSFont {
            return fontType.font()
        }
    }
    
    //Public variables
    public var size:Size = .medium {
        didSet {
            updateFont()
        }
    }
    
    public var style:UTTeamStyle = .defaultStyle {
        didSet {
            setThemeColors()
        }
    }
    
    public var isActionable:Bool = false {
        didSet {
            resetCursorRects()
        }
    }
    
    public override var focusRingMaskBounds: NSRect {
        return self.bounds
    }
    
    public override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    public override var acceptsFirstResponder: Bool{
        return isActionable
    }
    
    public override var canBecomeKeyView: Bool{
        return !self.isHidden && self.isEnabled && isActionable
    }
    
    public weak var teamLabelDeleage:UTTeamLabelDelegate?
    
    public var customColor:CCColor?

    public convenience init(stringValue:String = "", size:UTTeamLabel.Size, style:UTTeamStyle, lineBreakMode: NSLineBreakMode = .byTruncatingMiddle) {
        self.init(wrappingLabelWithString: stringValue)
        self.size = size
        self.lineBreakMode = lineBreakMode
        self.isSelectable = false
        self.style = style
        initialise()
    }
  
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
        lineBreakMode = .byTruncatingMiddle
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    internal func initialise(){
        self.wantsLayer = true
        updateFont()
        isEditable = false
        drawsBackground = false
        isBordered = false
        cell?.truncatesLastVisibleLine = true
        setThemeColors()
    }
    
    public func configure(style:UTTeamStyle, customColor: CCColor?){
        self.customColor = customColor
        self.style = style
    }
    
    public  func setThemeColors() {
                
        if style == .custom {
            if let color = customColor {
                self.textColor = color
            }
            else {
                self.textColor = style.teamMarkerColors.normal
            }
        }
        else {
            self.textColor = style.teamMarkerColors.normal
        }
    }

    public func updateFont() {
        self.font = size.font
        self.invalidateIntrinsicContentSize()
    }
    
    override public func keyDown(with event: NSEvent) {
        let keyCode:Int = Int(event.keyCode)
        if isActionKeyCode(keyCode: keyCode) {
            teamLabelDeleage?.onLabelActioned(sender: self)
        }
        else {
            super.keyDown(with: event)
        }
    }
    
    override public func mouseDown(with event: NSEvent) {
        if isActionable {
            teamLabelDeleage?.onLabelActioned(sender: self)
        }
        else {
            super.mouseDown(with: event)
        }
    }
    
    public override func resetCursorRects() {
        if isActionable {
            discardCursorRects()
            self.addCursorRect(self.bounds, cursor: .pointingHand)
        }
        else {
            super.resetCursorRects()
        }
    }
    
    public override func drawFocusRingMask() {
        self.bounds.fill()
    }
    
    private func isActionKeyCode(keyCode:Int) -> Bool{
        return keyCode == kVK_Return ||
               keyCode == kVK_ANSI_KeypadEnter ||
               keyCode == kVK_Space
    }
}
