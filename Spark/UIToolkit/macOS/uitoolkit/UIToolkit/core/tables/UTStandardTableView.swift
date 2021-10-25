//
//  UTStandardTableView.swift
//  UIToolkit
//
//  Created by James Nestor on 10/06/2021.
//

import Cocoa

public protocol UTStandardTableViewDelegate : NSObject {
    
    func getUTStandardTableCellViewData(sender: UTTableView, data:Any) -> UTStandardTableCellViewData
    
    func rightClickMenu(sender: UTTableView, row: Int, parentMenu:NSMenu)
    func rowClicked(sender: UTTableView, row:Int)
    func rowDoubleClicked(sender: UTTableView, row:Int)
    func invokeActionForSelectedRow(sender: UTTableView, row: Int)
    
}

public class UTStandardTableView : UTView {
    
    var scrollView: UTScrollView!
    var tableView:UTTableView!
    var tableMenu: NSMenu = NSMenu(title: "TableMenu")
    
    public weak var delegate:UTStandardTableViewDelegate?
    public var sizeInfo:TableSizeInfo = TableSizeInfo(rowSize: .large)
    
    public private (set) var dataSource:[Any] = []
    
    public func updateCallButtonText(text:String, row:Int){
        if let cellView = tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? UTStandardTableCellView {
            cellView.updateCallButtonText(text: text)
        }
    }
    
    override internal func initialise(){
        self.scrollView = UTScrollView(frame: self.bounds)
        self.scrollView.hasVerticalScroller = true
        self.tableView = UTTableView(frame: self.bounds)
        self.scrollView.documentView = self.tableView
        self.scrollView.legacyStyle = .customBackground
        self.tableView.setContentInsets(NSEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        setAsOnlySubviewAndFill(subview: scrollView)
        self.tableView.backgroundColor = .clear
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.utTableViewDelegate = self
        self.tableView.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        let column = NSTableColumn()
        column.resizingMask = .autoresizingMask
        self.tableView.addTableColumn(column)
        
        self.tableView.menu = tableMenu
        self.tableMenu.delegate = self
        
        self.tableView.action = #selector(onTableAction)
        self.tableView.doubleAction = #selector(onTableDoubleAction)
        self.tableView.target = self
        
        super.initialise()
    }
    
    public func reloadData() {
        tableView.reloadData()
    }
    
    public func setDataSource(dataSource:[Any]){
        self.dataSource = dataSource
        reloadData()
    }
    
    public func rowViewFor(view: NSView) -> Int{
        return tableView.row(for: view)
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
        scrollView.setThemeColors()
        tableView.setThemeColors()
    }
    
    @objc func onTableAction(_ sender: AnyObject) {
        delegate?.rowClicked(sender: tableView, row: tableView.clickedRow)
    }
    
    @objc func onTableDoubleAction(_ sender: AnyObject){
        delegate?.rowDoubleClicked(sender: tableView, row: tableView.clickedRow)
    }
    
}

//MARK: - NSTableViewDelegate, NSTableViewDataSource
extension UTStandardTableView : NSTableViewDelegate, NSTableViewDataSource{
    
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return sizeInfo.getRowHeight()
    }
    
    public func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return UTTableRowView.makeWithIdentifier(tableView, rowIdentifier: "UTTableRowView", owner: self, style: .pill)
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        tableColumn?.width = tableView.bounds.width
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UTStandardTableCellView"), owner: self) as? UTStandardTableCellView ?? UTStandardTableCellView(frame: NSZeroRect)
        cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: "UTStandardTableCellView")
        
        if let data = dataSource.getItemAtIndex(row),
           let cellData = delegate?.getUTStandardTableCellViewData(sender: self.tableView, data: data){
            
            cellView.updateData(data: cellData, isSelected: tableView.selectedRow == row)
        }
            
        return cellView
    }
    
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
}

//MARK: - UTTableViewDelegete extension
extension UTStandardTableView : UTTableViewDelegate {
    public func firstResponderStatusChanged(sender: UTTableView, isFirstResponder:Bool){
        if isFirstResponder && sender.selectedRow == -1 {
            sender.selectFirstRow()
        }
    }
    
    public func invokeActionForSelectedRow(sender:UTTableView){
        delegate?.invokeActionForSelectedRow(sender: tableView, row: tableView.selectedRow)
    }
}

//MARK: - NSMenuDelegate extension
extension UTStandardTableView : NSMenuDelegate {
    
    public func menuWillOpen(_ menu: NSMenu) {
        if menu == tableMenu {
            delegate?.rightClickMenu(sender: tableView, row: tableView.clickedRow, parentMenu: tableMenu)
        }
    }
    
    public func menuDidClose(_ menu: NSMenu) {
        if menu == tableMenu{
            tableMenu.removeAllItems()
        }
    }
}

public class UTStandardTableCellViewData {
    
    //var avatarView:UTAvatarView
    
    var uniqueId:String
    var primaryTitleLabel:NSAttributedString
    var primaryTitleSecondLineLabel:String?
    var subTitleLabel:String?
    var subTitleSecondLineLabel:String?
    
    var subtitleIcons:[UTIcon]
    var indicatorBadges:[UTIndicatorBadge]
    var hoverButtons:[UTButton]
    var callButton:UTButton?
    
    public init(uniqueId:String,
                primaryTitleLabel:NSAttributedString,
                primaryTitleSecondLineLabel:String? = nil,
                subTitleLabel:String? = nil,
                subTitleSecondLineLabel:String? = nil,
                subtitleIcons:[UTIcon] = [],
                indicatorBadges:[UTIndicatorBadge],
                hoverButtons: [UTButton] = [],
                callButton:UTButton? = nil) {
        
        self.uniqueId                    = uniqueId
        self.primaryTitleLabel           = primaryTitleLabel
        self.primaryTitleSecondLineLabel = primaryTitleSecondLineLabel
        self.subTitleLabel               = subTitleLabel
        self.subTitleSecondLineLabel     = subTitleSecondLineLabel
        self.subtitleIcons               = subtitleIcons
        self.indicatorBadges             = indicatorBadges
        self.hoverButtons                = hoverButtons
        self.callButton                  = callButton
    }
        
}
