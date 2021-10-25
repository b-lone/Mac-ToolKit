//
//  UTInputTextFieldHintLabel.swift
//  UIToolkit
//
//  Created by James Nestor on 21/05/2021.
//

import Cocoa

public class UTHintLabel: UTView {
    
    public var validationState:UTTextFieldValidationState = .noError {
        didSet{
            updateIconVisibility()
            updateStyle()
            setThemeColors()
        }
    }
    
    public var hintString:String = "" {
        didSet{
            self.hintLabel.stringValue = hintString
        }
    }
    
    var iconType:MomentumRebrandIconType{
        return .warningBold
    }
    
    private var style : UTIconLabelStyle {
        return validationState == .noError ? .secondary : .error
    }
    
    private var iconStackView:NSStackView!
    private var stackView:NSStackView!
    private var errorIcon:UTIcon!
    private var hintLabel:UTLabel!
            
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    override func initialise(){
        self.wantsLayer = true
        
        stackView = NSStackView()
        stackView.edgeInsets = NSEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stackView.orientation = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .centerY
        stackView.spacing = 6
        stackView.distribution = .fillProportionally
        
        self.setAsOnlySubviewAndFill(subview: stackView)
        
        errorIcon = UTIcon(iconType: iconType, style: style, size: .mediumSmall)
        errorIcon.setContentHuggingPriority(.required, for: .vertical)
        errorIcon.setContentHuggingPriority(.required, for: .horizontal)
        
        hintLabel = UTLabel(fontType: .bodySecondary, style: style, lineBreakMode: .byWordWrapping)
        hintLabel.maximumNumberOfLines = 4
        hintLabel.cell?.truncatesLastVisibleLine = true
        
        iconStackView = NSStackView()
        iconStackView.wantsLayer = true
        iconStackView.orientation = .vertical
        iconStackView.distribution = .gravityAreas
        iconStackView.alignment = .centerX
        iconStackView.edgeInsets = NSEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        iconStackView.setHuggingPriority(.required, for: .horizontal)
        iconStackView.setHuggingPriority(.defaultLow, for: .vertical)
                
        iconStackView.addView(errorIcon, in: .top)        
        
        stackView.addArrangedSubview(iconStackView)
        stackView.addArrangedSubview(hintLabel)
        
        iconStackView.isHidden = true
        updateStyle()
        
        setThemeColors()
    }
    
    override public func setThemeColors() {
        errorIcon.setThemeColors()
        hintLabel.setThemeColors()
    }
    
    public func announceHint() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { [weak self] in
            if let msg = self?.hintString {
                NSAccessibility.post(element: NSApp.mainWindow as Any,
                                     notification: .announcementRequested,
                                         userInfo: [.announcement: msg,
                                                        .priority: NSAccessibilityPriorityLevel.high.rawValue])
            }
        })
    }
    
    private func updateIconVisibility() {
        iconStackView.isHidden = validationState == .noError
        
        if iconStackView.isHidden == false {
            announceHint()
        }
    }
    
    private func updateStyle() {
        hintLabel.style = style
        errorIcon.style = style
    }
}
