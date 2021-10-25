//
//  UTPopoverListTableVC.swift
//  UIToolkit
//
//  Created by James Nestor on 31/05/2021.
//

import Cocoa

//MARK: - UTListItem
public class UTListItem : NSObject{
    
    var section:UInt
    public var tag:Any? = nil
    public init(section:UInt = 0, tag:Any? = nil) {
        self.section = section
        self.tag     = tag
    }
}

//MARK: - UTListItemHeader
public class UTListItemHeader : UTListItem {
    
    var title:String
    var tooltip:String
    var hasSeparator:Bool = false
    var isCollapsed:Bool = false
    var isCollapsable:Bool = false
    
    public init(title:String, tooltip:String = "", hasSeparator:Bool = false) {
        self.title = title
        self.tooltip = tooltip
        self.hasSeparator = hasSeparator
    }
}

//MARK: - UTListItemData
public class UTListItemData : UTListItem{
    
    var icon:MomentumRebrandIconType?
    var image:NSImage?
    
    var title:String
    var tooltip:String
    fileprivate (set) public var isChecked:Bool
    var isEnabled: Bool
    var iconLabelStyle:UTIconLabelStyle
    var iconColorToken:UTColorTokens?
    
    public init(icon:MomentumRebrandIconType? = nil, image:NSImage? = nil, title:String, isChecked:Bool = false, isEnabled:Bool = true, tag:Any? = nil, style:UTIconLabelStyle = .primary, tooltip:String = "", iconColorToken:UTColorTokens? = nil){
        self.icon      = icon
        self.image     = image
        self.title     = title
        self.isChecked = isChecked
        self.isEnabled = isEnabled
        self.iconLabelStyle = style
        self.iconColorToken = iconColorToken
        self.tooltip = tooltip
        super.init(section: 0, tag: tag)
    }
}

//MARK: - UTListItemSeparator
public class UTListItemSeparator : UTListItem { }


@objc public protocol UTPopoverListTableVCDelegate : AnyObject {
    func invokeActionForListItem(listItem:UTListItemData, index:Int)
    @objc optional func rightClickMenu(sender: UTTableView, listItem: UTListItem, row: Int, parentMenu:NSMenu)
}

//MARK: - UTPopoverListTableVC
public class UTPopoverListTableVC: UTBaseViewController {
    
    @IBOutlet var tableView: UTTableView!
    @IBOutlet var tableHeightConstraint: NSLayoutConstraint!
    var dataSource:[UTListItem] = []
    
    public var rowStyle: UTTableRowViewStyle = .rounded
    public var sizeInfo:TableSizeInfo = TableSizeInfo(rowSize: .medium)
    public weak var delegate:UTPopoverListTableVCDelegate?
    
    private let defaultWidth:CGFloat = 150
    private var minimumWidth:CGFloat = 100
    private var maximumWidth:CGFloat = 400
    private var widthToFit:CGFloat = 150
    
    private var tableMenu: NSMenu = NSMenu(title: "PopoverListContextMenu")

    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "UTPopoverListTableVC", bundle: Bundle.getUIToolKitBundle())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var totalTableHeight : CGFloat {
        return tableView.totalTableHeight
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.utTableViewDelegate = self
        
        tableView.action = #selector(onTableAction)
        tableView.target = self
        tableView.backgroundColor = .clear
        
        (tableView?.enclosingScrollView as? UTScrollView)?.legacyStyle = .customBackground
        tableView.setContentInsets(NSEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        self.tableView.menu = tableMenu
        self.tableMenu.delegate = self
                
        tableView.reloadData()
    }
    
    public func setDataSource(data:[UTListItem]){
        //When reloading the table data we should reset the
        //width needed to fit as it may have changed
        setDefaultWidthToFit()
        dataSource = data
        
        if isViewLoaded{
            tableView.reloadData()
            tableHeightConstraint?.constant = tableView.totalTableHeight
        }
    }
    
    @discardableResult
    public func updateListItem(listItem:UTListItem, index:Int) -> Bool {
        if dataSource.hasIndex(index){
            dataSource[index] = listItem
            
            if isViewLoaded {
                let indexSet = NSMutableIndexSet(index: index)
                tableView.reloadData(forRowIndexes: indexSet as IndexSet, columnIndexes: NSIndexSet(index: 0) as IndexSet)
            }
            
            return true
        }
        
        return false
    }
    
    @discardableResult
    public func updateListItemChecked(isChecked:Bool, index:Int) -> Bool {
        if let listItem = dataSource.getItemAtIndex(index) as? UTListItemData {
            
            listItem.isChecked = isChecked
            if isViewLoaded {
                let indexSet = NSMutableIndexSet(index: index)
                tableView.reloadData(forRowIndexes: indexSet as IndexSet, columnIndexes: NSIndexSet(index: 0) as IndexSet)
            }
            
            return true
        }
        
        return false
    }
    
    public func updateMaxWidth(maxWidth:CGFloat) {
        if widthToFit > maxWidth {
            widthToFit = maxWidth
            updatePreferredContentWidth(width: widthToFit)
        }
    }
    
    public func updateMinimumWidth(minWidth:CGFloat) {
        if widthToFit < minWidth {
            widthToFit = minWidth
            updatePreferredContentWidth(width: widthToFit)
        }
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
        tableView.reloadData()
    }
    
    public func deselectRow() {
        tableView?.deselectRow()
    }
    
    func isSelectable(row:Int) -> Bool {
        if let item = dataSource.getItemAtIndex(row) as? UTListItemData {
            return item.isEnabled
        }
        
        return false
    }
    
    @objc func onTableAction(_ sender: AnyObject) {
        doRowAction(row: tableView.clickedRow)
    }
    
    private func doRowAction(row:Int) {
        
        if let data = dataSource.getItemAtIndex(row) as? UTListItemData {
            delegate?.invokeActionForListItem(listItem: data, index: row)
        }
    }
        
    private func getIndicesInSection(section: Int) -> IndexSet {
        
        var rows:[Int] = []
        
        for i in 0..<dataSource.count {
            
            if let listItem = dataSource.getItemAtIndex(i){
                
                if listItem is UTListItemHeader{
                    // Mark collapsed state
                }
                else{
                    
                    rows.append(i)
                }
            }
        }
        
        return IndexSet(rows)
    }
    
    private func updateWidthToFit(width:CGFloat) {
        let widthAndPadding = width + tableView.clipViewWidthInsets
        if widthAndPadding > widthToFit {
            widthToFit = min(widthAndPadding, maximumWidth)
            updatePreferredContentWidth(width: widthToFit)
        }
    }
    
    private func updatePreferredContentWidth(width:CGFloat) {
        
        guard isViewLoaded else { return }
        guard let preferredWidth = self.view.window?.contentViewController?.preferredContentSize.width else { return }
        
        if preferredWidth != width {
            self.view.window?.contentViewController?.preferredContentSize.width = width
        }
    }
    
    private func setDefaultWidthToFit() {
        widthToFit = defaultWidth
        if widthToFit < minimumWidth {
            widthToFit = minimumWidth
        }
        else if widthToFit > maximumWidth {
            widthToFit = maximumWidth
        }
    }
}

//MARK: - NSMenuDelegate extension
extension UTPopoverListTableVC : NSMenuDelegate {
    
    public func menuWillOpen(_ menu: NSMenu) {
        if menu == tableMenu {
            guard dataSource.hasIndex(tableView.clickedRow) else { return }
 
            delegate?.rightClickMenu?(sender: tableView, listItem: dataSource[tableView.clickedRow], row: tableView.clickedRow, parentMenu: tableMenu)
        }
    }
    
    public func menuDidClose(_ menu: NSMenu) {
        if menu == tableMenu{
            tableMenu.removeAllItems()
        }
    }
}

//MARK: - UTTableViewDelegate Extension
extension UTPopoverListTableVC: UTTableViewDelegate {
    public func firstResponderStatusChanged(sender: UTTableView, isFirstResponder: Bool) {
        
    }
    
    public func invokeActionForSelectedRow(sender: UTTableView) {
        doRowAction(row: tableView.selectedRow)
    }
}

//MARK: - NSTableViewDataSource Extension
extension UTPopoverListTableVC : NSTableViewDataSource{
    public func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
}

//MARK: - NSTableViewDelegate Extension
extension UTPopoverListTableVC : NSTableViewDelegate{
    
    public func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if dataSource.getItemAtIndex(row) is UTListItemSeparator {
            return sizeInfo.getSeparartorRowHeight()
        }
        else if dataSource.getItemAtIndex(row) is UTListItemHeader {
            return sizeInfo.getHeaderRowHeight()
        }
        
        return sizeInfo.getRowHeight()
    }
    
    public func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        if let item = dataSource.getItemAtIndex(row) as? UTListItemData,
               item.isEnabled {
            return UTTableRowView.makeWithIdentifier(tableView, rowIdentifier: "UTTableRowView", owner: self, style: rowStyle)
        }
        
        return UTPlainTableRowView.makeWithIdentifier(tableView, rowIdentifier: "UTPlainTableRowView", owner: self)
    }
    
    public func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let data = dataSource.getItemAtIndex(row) as? UTListItemData{
        
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UTListTableCellView"), owner: self)
            
            if let cellView = cellView as? UTListTableCellView {
                cellView.updateData(data: data)
                updateWidthToFit(width: cellView.fittingSize.width)
            }
            
            return cellView
        }
        else if dataSource.getItemAtIndex(row) is UTListItemSeparator{
            return UTSeparatorCellView.makeWithIdentifier(tableView, cellIdentifier: "UTListTableSeparatorCellView", owner: self)
        }
        else if let data = dataSource.getItemAtIndex(row) as? UTListItemHeader {
            
            if let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UTListTableHeaderCellView"), owner: self) as? UTListTableHeaderCellView {
                
                cellView.updateData(header: data)
                updateWidthToFit(width: cellView.fittingSize.width)
                return cellView
            }
        }
        
        return nil
    }
    
    public func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return isSelectable(row: row)
    }
}

//MARK: - UTListTableCellView
class UTListTableCellView : UTTableCellView {
    
    @IBOutlet var itemImageView:NSImageView?
    @IBOutlet var icon:UTIcon?
    @IBOutlet var title:UTLabel?
    @IBOutlet var rhsIcon:UTIcon?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        icon?.configure(iconType: .placeholderBold, style: .primary, size: .mediumSmall)
        
        title?.style    = .primary
        title?.fontType = .bodyPrimary
        
        rhsIcon?.configure(iconType: .checkBold, style: .hyperlink, size: .mediumSmall)
    }
    
    func updateData(data:UTListItemData){
        
        if let image = data.image {
            itemImageView?.image = image
            itemImageView?.isHidden = false
        }
        else {
            itemImageView?.isHidden = true
        }
        
        if let iconType = data.icon {
            if let iconColorToken = data.iconColorToken {
                icon?.configure(iconType: iconType, colorToken: iconColorToken)
            }
            else{
                icon?.configure(iconType: iconType, style: data.iconLabelStyle, size: .mediumSmall)
            }
            
            icon?.isHidden = false
        }
        else {
            icon?.isHidden = true
        }
        
        title?.style = data.iconLabelStyle
        title?.stringValue = data.title
        rhsIcon?.isHidden = !data.isChecked
        toolTip = data.tooltip
        
        rhsIcon?.setThemeColors()
    }
}

//MARK: - UTListTableHeaderCellView
class UTListTableHeaderCellView : UTTableCellView {
    
    @IBOutlet var title:UTLabel!
    @IBOutlet var separatorLine:UTSeparatorView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title?.style = .secondary
        title?.fontType = .bodySecondary
    }
    
    func updateData(header:UTListItemHeader){
        
        separatorLine?.isHidden = !header.hasSeparator
        separatorLine?.setThemeColors()
        title?.setThemeColors()
        title?.stringValue = header.title
        toolTip = header.tooltip
    }
    
}
