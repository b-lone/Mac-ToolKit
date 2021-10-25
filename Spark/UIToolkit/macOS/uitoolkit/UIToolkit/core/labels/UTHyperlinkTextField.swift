//
//  UTHyperlinkTextField.swift
//  UIToolkit
//
//  Created by James Nestor on 27/08/2021.
//

import Cocoa

class UTHyperLinkTextFieldData {
    var plainText:String = ""
    var link:String = ""
    var range:NSRange = NSRange()
    var rect:NSRect?
    
    init(str:String, link:String, range:NSRange, rect: NSRect? = nil) {
        self.plainText = str
        self.link = link
        self.range = range
        self.rect = rect
    }
}

public protocol UTHyperlinkTextFieldDelegate : AnyObject {
    func onLinkAction(sender: UTHyperlinkTextField, link: String, plainText: String)
}

public class UTHyperlinkTextField : UTLabel {
    
    public weak var hyperlinkDelegate:UTHyperlinkTextFieldDelegate?
    
    var linkData:UTHyperLinkTextFieldData?
    var isFocused:Bool = false {
        didSet {
            self.needsDisplay = true
        }
    }
    
    private var clickRecognizer = NSClickGestureRecognizer()
    
    override public var acceptsFirstResponder: Bool {
        return linkData != nil
    }
    
    override public var canBecomeKeyView: Bool {
        return linkData != nil
    }
    
    override public func initialise() {
        super.initialise()
        self.allowsEditingTextAttributes = true
        self.isSelectable = true
        
        self.attributedStringValue = NSMutableAttributedString(string: stringValue, attributes: [NSAttributedString.Key.font: self.fontType.font(),
                                                                                                 NSAttributedString.Key.foregroundColor: textColor as Any])
     
        clickRecognizer.target = self
        clickRecognizer.action = #selector(self.onClick(_:))
        self.addGestureRecognizer(clickRecognizer)
     
        setAccessibilityRole(NSAccessibility.Role.link)
    }
    
    public func removeLink(){
        self.attributedStringValue = NSMutableAttributedString(string: stringValue, attributes: [NSAttributedString.Key.font: self.fontType.font(),
                                                                                                 NSAttributedString.Key.foregroundColor: textColor as Any])
        self.linkData = nil
        self.discardCursorRects()
    }
        
    public func convertSubstrToLink(str:String) {
     
        self.attributedStringValue = NSMutableAttributedString(string: stringValue, attributes: [NSAttributedString.Key.font: self.fontType.font(),
                                                                                                 NSAttributedString.Key.foregroundColor: textColor as Any])
     
        if let range = self.stringValue.range(of: str) {
            let attrString = NSMutableAttributedString(attributedString: self.attributedStringValue)

            let nsRange = NSRange(range, in: stringValue)
                        
            attrString.setAttributes([NSAttributedString.Key.cursor: NSCursor.pointingHand,
                                      NSAttributedString.Key.foregroundColor: UTIconLabelStyle.hyperlink.colorStates.normal,
                                      NSAttributedString.Key.font: UTFontType.hyperlinkSecondary.font(),
                                      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: nsRange)

            self.attributedStringValue = attrString

            linkData = UTHyperLinkTextFieldData(str: str, link: "", range: nsRange, rect: boundingRectForRange(range: nsRange))
        }
        
        self.discardCursorRects()
    }
    
    override public func setThemeColors() {
        super.setThemeColors()
        
        self.attributedStringValue = NSMutableAttributedString(string: stringValue, attributes: [NSAttributedString.Key.font: self.fontType.font(),
                                                                                                 NSAttributedString.Key.foregroundColor: textColor as Any])
        
        if let linkData = linkData {
            let attrString = NSMutableAttributedString(attributedString: self.attributedStringValue)
                       
                        
            attrString.setAttributes([NSAttributedString.Key.cursor: NSCursor.pointingHand,
                                      NSAttributedString.Key.foregroundColor: UTIconLabelStyle.hyperlink.colorStates.normal,
                                      NSAttributedString.Key.font: UTFontType.hyperlinkSecondary.font(),
                                      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue], range: linkData.range)

            self.attributedStringValue = attrString
        }
    }
    
    override public func resetCursorRects() {
        super.resetCursorRects()

        if let data = linkData,
           let rect = data.rect {
            addCursorRect(rect, cursor: .pointingHand)
        }
    }
    
    override public var frame: NSRect{
        didSet {
            if let data = linkData{
                let rect = boundingRectForRange(range: data.range)
                data.rect = rect
                self.needsDisplay = true
            }
        }
    }
    
    @IBAction func onClick(_ sender: NSGestureRecognizer) {
        if isMouseInLinkRect() {
            actionLink()
        }
    }
    
    internal func actionLink() {
        if let data = linkData {
            hyperlinkDelegate?.onLinkAction(sender: self, link: data.link, plainText: data.plainText)
        }
    }
    
    private func boundingRectForRange(range:NSRange) -> NSRect {
        
        let textStorage = NSTextStorage(attributedString: attributedStringValue)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0
        layoutManager.addTextContainer(textContainer)

        var actualRange = NSRange()
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &actualRange)
        let boundingRect = layoutManager.boundingRect(forGlyphRange: actualRange, in: textContainer)
        return NSMakeRect(boundingRect.minX, boundingRect.minY, boundingRect.width + 4, boundingRect.height)
    }
    
    
    @objc private func deselectText() {
        if let textView =  self.currentEditor() as? NSTextView {
            textView.setSelectedRange(NSMakeRange(0, 0))
        }
    }
    
    private func isMouseInLinkRect() -> Bool {
        if let data = linkData,
           let rect = data.rect {

            if let mouseLocation = self.window?.mouseLocationOutsideOfEventStream {
                let pt = self.convert(mouseLocation, from: nil)
                return NSPointInRect(pt, rect)
            }

        }

        return false
    }
}
