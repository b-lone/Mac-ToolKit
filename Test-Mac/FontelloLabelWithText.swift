//
//  FontelloLabelWithText.swift
//  WebexTeams
//
//  Created by senacarr on 21/12/2020.
//  Copyright © 2020 Cisco Systems. All rights reserved.
//

import Cocoa

class FontelloLabelWithText: NSTextField {
    
    var lineHeightMultiple: CGFloat = 1.5
    var spacing: CGFloat = 17
    var padding: CGFloat = 0
    var fontSize: CGFloat = 16
    var iconSize: CGFloat = 14
    
//    var icon: MomentumIconType?
    var icon: String?
    var labelText: String = ""
    var boldText: String?
    var boldTextFont: NSFont?
    
    var iconColour: NSColor = .black {
        didSet {
            needsDisplay = true
        }
    }
    var textColour: NSColor = .black {
        didSet {
            needsDisplay = true
        }
    }
    var boldTextBackgroundColor: NSColor? {
        didSet {
            needsDisplay = true
        }
    }
    
    private func getTextAttributes() -> [NSAttributedString.Key: Any] {
        let itemStyle = NSMutableParagraphStyle()
        itemStyle.lineHeightMultiple = lineHeightMultiple
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: itemStyle,
                                                         .foregroundColor: textColour,
                                                         .font: NSFont.systemFont(ofSize: fontSize)]
        return attributes
    }
    
    private func getBoldTextAttributes() -> [NSAttributedString.Key: Any] {
        let itemStyle = NSMutableParagraphStyle()
        itemStyle.lineHeightMultiple = lineHeightMultiple
        var attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: itemStyle,
                                                         .foregroundColor: textColour]
        if let boldTextFont = boldTextFont {
            attributes[.font] = boldTextFont
        } else {
            attributes[.font] = NSFont.systemFont(ofSize: fontSize, weight: .bold)
        }
        if let boldTextBackgroundColor = boldTextBackgroundColor {
            attributes[.backgroundColor] = boldTextBackgroundColor
        }
        return attributes
    }
    
    private var textAttrString: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: labelText, attributes: getTextAttributes())
        if let boldText = boldText {
            let range = (labelText as NSString).range(of: boldText)
            attributedString.setAttributes(getBoldTextAttributes(), range: range)
        }
        
        return attributedString
    }
    
    private var iconAttributes: [NSAttributedString.Key: Any] {
//        guard let font = NSFont(name: Constants.momentumIconFont, size: iconSize) else { return [:] }
        let font = NSFont.systemFont(ofSize: iconSize)
        
        let itemStyle = NSMutableParagraphStyle()
        itemStyle.lineHeightMultiple = lineHeightMultiple
        return [NSAttributedString.Key.paragraphStyle: itemStyle,
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: iconColour,
                NSAttributedString.Key.baselineOffset: 3]
    }
    
    private var iconAttrString: NSAttributedString? {
        guard let icon = icon else { return nil }
        return NSMutableAttributedString(string: icon, attributes: iconAttributes)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    private func initialise() {
        isSelectable = true
        isEditable = false
        drawsBackground = false
        isBordered = false
    }
    
    override var intrinsicContentSize: NSSize {
        let iconWidth = iconAttrString?.size().width ?? 0
        return NSMakeSize((2 * padding) + iconWidth + spacing + textAttrString.size().width, textAttrString.size().height)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        var iconRect = CGRect.zero
        if let iconAttrString = iconAttrString {
            iconRect = NSMakeRect(0, (bounds.height - iconSize) / 2, iconAttrString.size().width, bounds.height)
            iconColour.set()
            iconAttrString.draw(in: iconRect)
        }

        let strSize = textAttrString.size()
        let textRect = NSMakeRect(iconRect.maxX + spacing, (bounds.height - strSize.height) / 2, strSize.width, bounds.height)
        textColour.set()
        textAttrString.draw(in: textRect)
    }
}
