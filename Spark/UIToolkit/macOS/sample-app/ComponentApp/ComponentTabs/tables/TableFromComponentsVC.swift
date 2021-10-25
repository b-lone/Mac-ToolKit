//
//  TableFromComponentsVC.swift
//  ComponentApp
//
//  Created by James Nestor on 17/06/2021.
//

import Cocoa
import UIToolkit

class TableFromComponentsVC: UTBaseViewController {

    var tableView: UTTableView!
    var dataSource: [TestSpaceListDataBase] = []
    var size:TableSizeInfo = TableSizeInfo(rowSize: .large)
        
    private var callDurationTimer: Timer!
    
    var isLegacyStyle:Bool = false
    var isCompact:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView = UTTableView.makeStandardTable(in: self.view)
                
        tableView.delegate            = self
        tableView.utTableViewDelegate = self
        tableView.dataSource          = self
        tableView.action       = #selector(onTableAction)
        tableView.doubleAction = #selector(onTableDoubleAction)
        tableView.target       = self
                
        buildDataSource()
        
        //self.tableView.menu = tableMenu
        //self.tableMenu.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        startCallTimer()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        stopTimer()
    }
    
    @objc func onTableAction(_ sender: AnyObject) {
        NSLog("row clicked on table: \(String(describing: sender.description)) at row: \(tableView.clickedRow)")
    }
    
    @objc func onTableDoubleAction(_ sender: AnyObject){
        NSLog("row double clicked on table: \(String(describing: sender.description)) at row: \(tableView.clickedRow)")
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        tableView.reloadData()
    }
    
    //Configure table for test
    func showLegacyStyle(isLegacy:Bool){
        
        self.isLegacyStyle = isLegacy
        
        if isViewLoaded {
        
            if isLegacyStyle {
                tableView.setContentInsets(NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            }
            else {
                tableView.setContentInsets(NSEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
            }
            
            tableView.reloadData()
        }
    }
    
    func setCompactMode(isCompact:Bool){
        
        self.isCompact = isCompact
        self.size.rowSize =  isCompact ? .small : .large
        
        if isViewLoaded {
            tableView.reloadData()
        }
    }
    
    func selectRowWithId(rowId:String){
        if let index = dataSource.firstIndex(where: {
            if let data = $0 as? TestSpaceListData {
                return data.uniqueId == rowId
            }
            
            return false
        }) {
            
            tableView.selectAndScrollRow(index)
        }
    }
    
    func reloadTableData(){
        tableView?.reloadData()
    }
    
    
    //Timer functions for demo to simulate CallControlManager posting notifications for calls
    private func startCallTimer() {

        if callDurationTimer == nil {
            callDurationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(TableFromComponentsVC.updateCallTimer), userInfo: nil, repeats: true)
        }
        
        callDurationTimer.fire()
    }
    
    private func stopTimer(){
        callDurationTimer.invalidate()
        callDurationTimer = nil
    }
    
    private func buildDataSource() {
        dataSource.append(TestSpaceHeader(expanded: true, group: .call))
        dataSource.append(TestSpaceHeader(expanded: true, group: .favourite))
        dataSource.append(TestSpaceHeader(expanded: true, group: .normal))
        dataSource.append(contentsOf: TestSpaceListData.buildTestSpaceWithCallData(count: 3))
        dataSource.append(contentsOf: TestSpaceListData.buildTestData(count: 500))
        tableView.reloadData()
        sortDataSource()
    }
    
    private func sortDataSource(){
        
        dataSource.sort(by: { 
            
            if $0.group == $1.group {
                return $0 is TestSpaceHeader
            }
            else {
                return $0.group.rawValue < $1.group.rawValue
            }
        })
        
    }
    
    
    @objc private func updateCallTimer(timer: Timer) {
        
        for i in 0..<dataSource.count{
            if let record = dataSource.getItemAtIndex(i) as? TestSpaceListData {
                if record.uniqueId.contains("Call"){
                    let callDurationString = String.formatCallDurationSinceDate(record.callStartTime)
                    updateCallButtonText(text: callDurationString, row: i)
                }
            }
        }
    }
    
    @objc func expandButtonAction(_ sender:Any){
        
        guard let v = sender as? NSView else { return }
        
         let row = tableView.row(for: v)
        
        if let header = dataSource.getItemAtIndex(row) as? TestSpaceHeader {
            
            let indices = getIndicesInGroup(group: header.group)
            
            
            if header.isExpanded{
                self.tableView.hideRows(at: indices, withAnimation: [.slideUp, .effectFade])
            }
            else{
                self.tableView.unhideRows(at: indices, withAnimation: [.slideDown, .effectFade])
            }
            
            header.isExpanded = !header.isExpanded
        }
    }
    
    private func updateCallButtonText(text:String, row:Int){
        if let cellView = tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as? UTTestSpaceCallTableCellView {
            cellView.updateCallButtonText(text: text)
        }
    }
    
    private func getIndicesInGroup(group: TestSpaceGroup) -> IndexSet {
        
        var rows:[Int] = []
        
        for i in 0..<dataSource.count {
            
            if let listItem = dataSource.getItemAtIndex(i){
                
                if listItem is TestSpaceHeader{
                    // Mark collapsed state
                }
                else if listItem.group == group{
                    
                    rows.append(i)
                }
            }
        }
        
        return IndexSet(rows)
    }
}

//MARK: - UTTestSpaceCallTableCellViewDelegate
extension TableFromComponentsVC : UTTestSpaceCallTableCellViewDelegate {
    func participantButtonHoverChanged(sender:UTView, isHovered: Bool) {
        NSLog("Hover changed for participant button. Row:[\(tableView.row(for: sender))] hover state:[\(isHovered)]")
    }
    
    func callButtonAction(sender:Any) {
        guard let button = sender as? UTButton else { return }
        NSLog("Call button action. Row:[\(tableView.row(for: button))] text:[\(button.title)]")
    }
}

//MARK: - NSTableViewDataSource
extension TableFromComponentsVC : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
}

//MARK: - NSTableViewDelegate
extension TableFromComponentsVC : NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if dataSource.getItemAtIndex(row) is TestSpaceHeader {
            return self.size.getHeaderRowHeight()
        }
        
        return self.size.getRowHeight()
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        
        if dataSource.getItemAtIndex(row) is TestSpaceHeader {
            return UTPlainTableRowView.makeWithIdentifier(tableView, rowIdentifier: "UTPlainTableRowView", owner: self)
        }
        
        if isLegacyStyle {
            return UTTableRowView.makeWithIdentifier(tableView, rowIdentifier: "UTRectangleTableRowView", owner: self, style: .rectangle)
        }
        
        return UTTableRowView.makeWithIdentifier(tableView, rowIdentifier: "UTRoundedTableRowView", owner: self, style: .pill)
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return dataSource.getItemAtIndex(row) is TestSpaceListData
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        tableColumn?.width = tableView.bounds.width
        
        if let data = dataSource.getItemAtIndex(row) as? TestSpaceListData{
            
            if isCompact && !data.hasActiveCall{
                let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UTTestCompactSpaceTableCellView"), owner: self) as? UTTestCompactSpaceTableCellView ?? UTTestCompactSpaceTableCellView(frame: NSZeroRect)
                cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: "UTTestCompactSpaceTableCellView")
                cellView.updateData(data: data, isSelected: tableView.selectedRow == row)
                return cellView
            }
            else if data.hasActiveCall {
                let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "UTTestSpaceCallTableCellView"), owner: self) as? UTTestSpaceCallTableCellView ?? UTTestSpaceCallTableCellView(frame: NSZeroRect)
                cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: "UTTestSpaceCallTableCellView")
                cellView.updateData(data: data, isSelected: tableView.selectedRow == row)
                cellView.delegate = self
                return cellView
            }
            else {
                let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TestTableCellView"), owner: self) as? UTTestSpaceTableCellView ?? UTTestSpaceTableCellView(frame: NSZeroRect)
                cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: "TestTableCellView")
                cellView.updateData(data: data, isSelected: tableView.selectedRow == row)
                return cellView
            }
        }
        else if let data = dataSource.getItemAtIndex(row) as? TestSpaceHeader {
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TestTableHeaderCellView"), owner: self) as? UTTestSpaceHeaderTableCellView ?? UTTestSpaceHeaderTableCellView(frame: NSZeroRect)
            cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: "TestTableHeaderCellView")
            cellView.updateData(data: data, isSelected: tableView.selectedRow == row)
            cellView.setButtonAction(sel: #selector(expandButtonAction), target: self)
            return cellView
        }
        
        return nil
    }
    
}

//MARK: - UTTableViewDelegete extension
extension TableFromComponentsVC : UTTableViewDelegate {
    func firstResponderStatusChanged(sender: UTTableView, isFirstResponder:Bool){
        if isFirstResponder && sender.selectedRow == -1 {
            sender.selectFirstRow()
        }
    }
    
    func invokeActionForSelectedRow(sender:UTTableView){
        
    }
}

//MARK: - NSMenuDelegate extension
extension TableFromComponentsVC : NSMenuDelegate {
    
}
