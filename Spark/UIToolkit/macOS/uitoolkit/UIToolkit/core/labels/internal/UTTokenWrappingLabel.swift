//
//  UTTokenWrappingLabel.swift
//  UIToolkit
//
//  Created by James Nestor on 24/08/2021.
//

import Cocoa

public class UTTokenWrappingLabel: UTView {

    //MARK: - Internal
    internal var containerStackView:NSStackView!
    internal var iconStackView:NSStackView!
    internal var labelStackView:NSStackView!
    
    internal var icon:UTTokenIcon!
    internal var label:UTTokenLabel!
    
    //MARK: - Public variables
    public var iconType:MomentumRebrandIconType = ._invalid {
        didSet {
            icon?.iconType = iconType
            needsDisplay = true
        }
    }
    
    public var iconSize:IconSize =  .medium{
        didSet {
            icon?.size = iconSize
            needsDisplay = true
        }
    }
        
    public var labelString:String = "" {
        didSet {
            label?.stringValue = labelString
        }
    }
    
    public var fontType:UTFontType = .bodyPrimary {
        didSet {
            label?.fontType = fontType
        }
    }
    
    public var iconAlignment:IconAlignment = .left {
        didSet{
            layoutComponents()
        }
    }
    
    //MARK: - Initialisation
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    public init(iconType:MomentumRebrandIconType, iconSize:IconSize, label:String, fontType:UTFontType, iconAlignment:IconAlignment = .left){
        super.init(frame: NSZeroRect)
        configure(iconType: iconType, iconSize: iconSize, label: label, fontType: fontType, iconAlignment: iconAlignment)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    internal override func initialise() {
        super.initialise()
                
        //Main container horizontal
        containerStackView = NSStackView()
        containerStackView.wantsLayer   = true
        containerStackView.distribution = .gravityAreas
        containerStackView.orientation  = .horizontal
        containerStackView.alignment    = .top
        containerStackView.edgeInsets   = NSEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
        containerStackView.spacing      = 12
        
        self.setAsOnlySubviewAndFill(subview: containerStackView)
        
        //Icon stack view vertical. Orientation can be changed
        //Alignment Leading CenterX or Trailing to ajust icon position
        iconStackView = NSStackView()
        iconStackView.wantsLayer   = true
        iconStackView.orientation  = .vertical
        iconStackView.distribution = .fillProportionally
        
        //Create text field
        icon = UTTokenIcon(iconType: iconType, tokenName: "", size: iconSize)
        
        iconStackView.addArrangedSubview(icon)
        
        label              = UTTokenLabel(stringValue: labelString, fontType: fontType, tokenName: "", lineBreakMode: .byWordWrapping)
        label.isSelectable = false
        label.setContentCompressionResistancePriority(.init(rawValue: 251), for: .horizontal)
        
        labelStackView = NSStackView()
        labelStackView.wantsLayer   = true
        labelStackView.orientation  = .vertical
        labelStackView.distribution = .fill
        labelStackView.edgeInsets   = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        labelStackView.addArrangedSubview(label)
        
        //Add views to container
        layoutComponents()
        
        //Set hugging priorities of components (keep everything tight horizontally)
        containerStackView.setHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh,       for: .horizontal)
        labelStackView.setHuggingPriority(.defaultHigh,     for: .horizontal)
        icon.setContentHuggingPriority(.defaultHigh,        for: .horizontal)
        iconStackView.setHuggingPriority(.required,         for: .horizontal)
    }
    
    //Mark: - Public functions
    public func configure(iconType:MomentumRebrandIconType, iconSize:IconSize, label:String, fontType:UTFontType, iconAlignment:IconAlignment = .left) {
        self.iconType      = iconType
        self.iconSize      = iconSize
        self.labelString   = label
        self.fontType      = fontType
        
        self.iconAlignment = iconAlignment
        setThemeColors()
    }
    
    override public func setThemeColors() {
        super.setThemeColors()
        icon?.setThemeColors()
        label?.setThemeColors()
    }
        
    public func setMaximumNumberOfLines(numLines: Int){
        label.maximumNumberOfLines = numLines
    }
    
    private func layoutComponents(){
        //Add views to container
        if iconAlignment == .left {
            containerStackView.addView(iconStackView, in: .leading)
            containerStackView.addView(labelStackView, in: .leading)
        }
        else {
            containerStackView.addView(labelStackView, in: .leading)
            containerStackView.addView(iconStackView, in: .leading)
        }
    }
}
