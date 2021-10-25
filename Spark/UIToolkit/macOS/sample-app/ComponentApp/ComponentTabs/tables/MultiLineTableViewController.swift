//
//  MultiLineTableViewController.swift
//  ComponentApp
//
//  Created by James Nestor on 22/06/2021.
//

import Cocoa
import UIToolkit

class MultiLineTableViewController: UTBaseViewController {
    
    var tableView: UTTableView!
    var dataSource: [TestMessageListData] = []    
    
    //TODO: Multiple different row sizes depending on content will need to be updated
    var size:TableSizeInfo = TableSizeInfo(rowSize: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UTTableView.makeStandardTable(in: self.view)
                
        tableView.delegate            = self
        tableView.utTableViewDelegate = self
        tableView.dataSource          = self
        tableView.action              = #selector(onTableAction)
        tableView.target              = self
        
        if #available(OSX 10.13, *) {
            tableView.usesAutomaticRowHeights = true
        }
        
        buildDataSource()
    }
    
    @objc func onTableAction(_ sender: AnyObject) {
        NSLog("row clicked on table: \(String(describing: sender.description)) at row: \(tableView.clickedRow)")
    }
    
    private func buildDataSource() {
        dataSource = TestMessageListData.buildTestMessageData(count: 500)
        tableView.reloadData()
    }
    
    func selectRowWithId(rowId:String){
        if let index = dataSource.firstIndex(where: { return $0.uniqueId == rowId }) {
            tableView.selectAndScrollRow(index)
        }
    }
    
    func reloadTableData(){
        tableView?.reloadData()
    }
    
    func setCompactMode(isCompact:Bool){
        
        self.size.rowSize =  isCompact ? .small : .large
        
        if isViewLoaded {
            tableView.reloadData()
        }
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        tableView.setThemeColors()
    }
    
    override func updateFont() {
        super.updateFont()
        
        tableView?.reloadData()        
    }
    
}

//MARK: - NSTableViewDataSource
extension MultiLineTableViewController : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
}

//MARK: - NSTableViewDelegate
extension MultiLineTableViewController : NSTableViewDelegate {

      //Not called when usesAutomaticRowHeights = true
//    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
//      //TODO: - Depends on number of lines needed
//      //self.size.getRowHeight()
//      Dynamic up to
//      114 4 line table row
//      92  3 line table row
//    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
                
        return UTTableRowView.makeWithIdentifier(tableView, rowIdentifier: "UTRoundedTableRowView", owner: self, style: .rounded)
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        tableColumn?.width = tableView.bounds.width
        
        if let data = dataSource.getItemAtIndex(row) {
            
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UTTestMessageTableCellView"), owner: self) as? UTTestMessageTableCellView ?? UTTestMessageTableCellView(frame: NSZeroRect)
            cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: "UTTestMessageTableCellView")
            cellView.updateData(data: data, isSelected: tableView.selectedRow == row, sizeInfo: size)
            return cellView
            
        }
        
        return nil
    }
    
}

//MARK: - UTTableViewDelegete extension
extension MultiLineTableViewController : UTTableViewDelegate {
    func firstResponderStatusChanged(sender: UTTableView, isFirstResponder:Bool){
        if isFirstResponder && sender.selectedRow == -1 {
            sender.selectFirstRow()
        }
    }
    
    func invokeActionForSelectedRow(sender:UTTableView){
        
    }
}


class UTTestMessageTableCellView : UTTableCellView {
    
    //Container stack view
    private var containerStackView:NSStackView!

    private var avatarStackView:NSStackView!
    
    private var vStackView:NSStackView!
    
    private var topLineStackView:NSStackView!
    private var avatarView:UTAvatarView!
    private var titleLabel:UTLabel!
    private var dateLabel:UTLabel!
    
    //private var messageStackView:NSStackView!
    private var messageLabel:UTLabel!
    
    private var isSelected:Bool = false
    private weak var data:TestMessageListData?
    
    private var size:TableSizeInfo = TableSizeInfo(rowSize: .large){
        didSet {
            if size.rowSize == .large {
                titleLabel.fontType   = .bodyPrimary
                messageLabel.fontType = .bodySecondary
                dateLabel.fontType    = .labelCompact
            }
            else if size.rowSize == .small {                
                titleLabel.fontType   = .bodySecondary
                messageLabel.fontType = .labelCompact
                dateLabel.fontType    = .labelCompact
            }
        }
    }
    
    override internal func initialise(){
        
        //Configure container stack view
        containerStackView              = NSStackView()
        containerStackView.wantsLayer   = true
        containerStackView.orientation  = .horizontal
        containerStackView.edgeInsets   = NSEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        containerStackView.distribution = .gravityAreas
        containerStackView.identifier   = NSUserInterfaceItemIdentifier(rawValue: "ContainerStackView")
        containerStackView.setClippingResistancePriority(.init(751), for: .horizontal)
        containerStackView.setClippingResistancePriority(.defaultLow, for: .vertical)
        containerStackView.setHuggingPriority(.required, for: .vertical)        
        containerStackView.setContentHuggingPriority(.required, for: .vertical)
        containerStackView.alignment = .top
        containerStackView.spacing = 12
                
        setAsOnlySubviewAndFill(subview: containerStackView)        
        
        avatarStackView = NSStackView()
        avatarStackView.orientation = .vertical
        avatarStackView.distribution = .gravityAreas
        avatarStackView.setHuggingPriority(.init(751), for: .horizontal)
        avatarStackView.setHuggingPriority(.init(249), for: .vertical)
        
        topLineStackView = NSStackView()
        topLineStackView.orientation = .horizontal
        topLineStackView.distribution = .gravityAreas
        topLineStackView.setHuggingPriority(.init(751), for: .vertical)
        
        vStackView = NSStackView()
        vStackView.wantsLayer = true
        vStackView.orientation = .vertical
        vStackView.distribution = .gravityAreas
        vStackView.alignment = .leading
        vStackView.setHuggingPriority(.defaultHigh, for: .vertical)
        vStackView.setContentCompressionResistancePriority(.init(751), for: .vertical)
        vStackView.spacing = 4
        
        avatarView = UTAvatarView()
        
        titleLabel = UTLabel(fontType: .bodyPrimary, style: .primary)
        titleLabel.setContentHuggingPriority(.init(751), for: .horizontal)
        titleLabel.setContentHuggingPriority(.init(752), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)

        dateLabel = UTLabel(fontType: .bodyCompact, style: .secondary)
        dateLabel.setContentHuggingPriority(.init(752), for: .horizontal)
        titleLabel.setContentHuggingPriority(.init(752), for: .vertical)
        
        topLineStackView.addView(titleLabel, in: .leading)
        topLineStackView.addView(NSView(), in: .center)
        topLineStackView.addView(dateLabel, in: .trailing)
        
        messageLabel = UTLabel(fontType: .bodySecondary, style: .secondary, lineBreakMode: .byWordWrapping)
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        messageLabel.setContentHuggingPriority(.init(752), for: .vertical)
        messageLabel.maximumNumberOfLines = 4
        
        vStackView.addView(topLineStackView, in: .top)
        vStackView.addView(messageLabel, in: .top)
        
        messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: vStackView.trailingAnchor, constant: -46).isActive = true
        
        //Add components to container
        avatarStackView.addView(avatarView, in: .top)
        containerStackView.addView(avatarStackView, in: .leading)
        containerStackView.addView(vStackView, in: .leading)
        
        super.initialise()
    }
    
    override public func setThemeColors() {
        
        self.titleLabel.setThemeColors()
        self.dateLabel.setThemeColors()
        self.messageLabel.setThemeColors()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func updateData(data:TestMessageListData, isSelected: Bool, sizeInfo:TableSizeInfo){
        
        self.size = sizeInfo
        self.isSelected = isSelected
        self.data = data

        self.titleLabel.stringValue   = data.senderName
        self.dateLabel.stringValue    = Date.stringFromDate(data.messageSendTime)
        self.messageLabel.setAttributedString(stringPropertiesList: data.messageWithSenderAndHitPositions)
        
        if let image = data.avatarImage {
            self.avatarView.dataSource = AvatarImageViewDataSource(size: size.rowSize == .large ? .small : .extraSmall, avatar: image)
        }
        else {
            self.avatarView.dataSource = AvatarImageViewDataSource(size: size.rowSize == .large ? .small : .extraSmall, name: data.senderName, bgColor: data.avatarColor)
        }
        
        setThemeColors()
    }
   
    override func mouseInRowUpdated(mouseInside: Bool) {}
}
