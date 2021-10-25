//
//  UTTableCellView.swift
//  UIToolkit
//
//  Created by James Nestor on 20/05/2021.
//

import Cocoa

open class UTTableCellView: NSTableCellView, ThemeableProtocol {
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    open func initialise(){
        self.wantsLayer = true        
    }

    ///This will be called by UTTableRowView when the mouse inside the row changes
    open func mouseInRowUpdated(mouseInside:Bool){
    }
    
    open func setThemeColors() {
    }
    
}

public class UTSeparatorCellView : UTTableCellView {
    
    public enum RowSize {
        case primary
        
        public var asFloat:CGFloat {
            switch self {
            case .primary:
                return 8
            }
        }
    }
    
    private var separatorView:UTSeparatorView!
    
    override open func initialise() {
        super.initialise()
        
        separatorView = UTSeparatorView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(separatorView)
        
        let leadingConstraint  = NSLayoutConstraint.createLeadingSpaceToViewConstraint(firstItem: separatorView, secondItem: self, constant: 0)
        let trailingConstraint = NSLayoutConstraint.createTrailingSpaceToViewConstraint(firstItem: separatorView, secondItem: self, constant: 0)
        let heightConstrinat   = NSLayoutConstraint.createHeightConstraint(firstItem: separatorView, constant: 1)
        let yPosConstraint     = NSLayoutConstraint.createCenterYViewConstraint(firstItem: separatorView, secondItem: self, constant: 1)
        
        self.addConstraints([leadingConstraint, trailingConstraint, yPosConstraint, heightConstrinat])
        
        setThemeColors()
    }
    
    public override func setThemeColors() {
        separatorView.setThemeColors()
        super.setThemeColors()
    }
    
    public class func makeWithIdentifier(_ tableView: NSTableView, cellIdentifier:String, owner: Any?) -> UTSeparatorCellView {
        
        let identifier = NSUserInterfaceItemIdentifier(rawValue: cellIdentifier)
        
        if let cellView = tableView.makeView(withIdentifier: identifier, owner: self) as? UTSeparatorCellView {
            cellView.setThemeColors()
            return cellView
        }
                
        let cellView = UTSeparatorCellView()
        cellView.identifier = identifier
        
        return cellView
    }
    
}

public class UTLinkCellView : UTTableCellView {
    
    var stackView:NSStackView!
    var label:UTLabel!
    var icon:UTIcon!
    
    override open func initialise() {
        super.initialise()
        
        stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.distribution = .gravityAreas
        
        stackView.edgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        label = UTLabel(stringValue: "", fontType: .hyperlinkPrimary, style: .hyperlink, lineBreakMode: .byTruncatingTail)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        icon  = UTIcon(iconType: .popOutBold, style: .hyperlink)
        icon.size = .mediumSmall
        
        stackView.addView(label, in: .leading)
        stackView.addView(icon, in: .trailing)
        
        self.setAsOnlySubviewAndFill(subview: stackView)
    }
    
    public func updateLabel(displayString:String) {
        label.stringValue = displayString
    }
    
    public override func setThemeColors() {
        label.setThemeColors()
        icon.setThemeColors()
    }
    
    public class func makeWithIdentifier(_ tableView: NSTableView, cellIdentifier:String, owner: Any?) -> UTLinkCellView {
        
        let identifier = NSUserInterfaceItemIdentifier(rawValue: cellIdentifier)
        
        if let cellView = tableView.makeView(withIdentifier: identifier, owner: self) as? UTLinkCellView {
            cellView.setThemeColors()
            return cellView
        }
                
        let cellView = UTLinkCellView()
        cellView.identifier = identifier
        
        return cellView
    }
    
}
