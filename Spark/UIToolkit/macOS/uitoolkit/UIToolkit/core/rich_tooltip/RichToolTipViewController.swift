//
//  RichToolTipViewController.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 05/08/2021.
//

import Cocoa

class RichToolTipViewController: UTBaseViewController {
    
    private let label:NSTextField!

    init(tooltip:NSAttributedString, size: UTRichTooltipDetails.Size){
        
        let rect = NSRect(x: 0, y: 0, width: 60, height: 40)
        label = NSTextField(frame: rect)
     
        super.init(nibName: nil, bundle: nil)
        
        guard let tooltipAttrString = tooltip.mutableCopy() as? NSMutableAttributedString else {
            assert(false, "could not create an NSAttributedString object")
            return
        }

        let view = NSView(frame: rect)
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view = view
        
        let range = tooltipAttrString.mutableString.range(of: tooltipAttrString.string)
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = .center
        tooltipAttrString.addAttribute( NSAttributedString.Key.paragraphStyle, value: titleParagraphStyle, range: range)
        
        
        label.attributedStringValue = tooltipAttrString
        setThemeColors()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isBezeled = false
        label.isBordered = false
        label.isEditable = false

        
        var windowWidth = toWidth(size: size )
        let stringWidth = tooltipAttrString.size().width + (UTPadding.StandardLeadingTrailing * 2)
        
        if stringWidth < windowWidth  {
            windowWidth = stringWidth
        }
   

        label.preferredMaxLayoutWidth = windowWidth
        label.sizeToFit()
            
        view.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive  = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive  = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
    }
    
    private func toWidth(size: UTRichTooltipDetails.Size) -> CGFloat {
        switch size {
        case .large: return 240
        case .medium: return 200
        case .small: return 120
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public override func setThemeColors() {
        self.view.layer?.backgroundColor = .black
        label.backgroundColor = .black
        label.textColor = .white
    }
}
