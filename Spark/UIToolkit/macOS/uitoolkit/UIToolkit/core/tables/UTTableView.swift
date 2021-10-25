//
//  UTTableView.swift
//  UIToolkit
//
//  Created by James Nestor on 19/05/2021.
//

import Cocoa
import Carbon.HIToolbox

public protocol UTTableViewDelegate : AnyObject{
    func firstResponderStatusChanged(sender: UTTableView, isFirstResponder:Bool)
    func invokeActionForSelectedRow(sender:UTTableView)
    func hasRowSubMenu(sender:UTTableView, row: Int) -> Bool
}

extension UTTableViewDelegate{
    func firstResponderStatusChanged(sender: UTTableView, isFirstResponder:Bool){}
    func invokeActionForSelectedRow(sender:UTTableView){}
    public func hasRowSubMenu(sender:UTTableView, row: Int) -> Bool { return false }
}

public class UTTableView: NSTableView, ThemeableProtocol {
    
    public weak var utTableViewDelegate:UTTableViewDelegate?
    
    private var clipViewHeightInsets: CGFloat{
        guard let clipView = superview as? NSClipView else{
            return 0
        }
        
        return clipView.contentInsets.bottom + clipView.contentInsets.top
    }
    
    public var clipViewWidthInsets: CGFloat {
        guard let clipView = superview as? NSClipView else{
            return 0
        }
        
        return clipView.contentInsets.left + clipView.contentInsets.right
    }
    
    public var totalTableHeight: CGFloat{
                
        var size:CGFloat = clipViewHeightInsets
        guard let d = delegate else { return (rowHeight * CGFloat(numberOfRows)) + size }
                        
        for index in 0 ..< numberOfRows {
            
            if hiddenRowIndexes.contains(index) == false {
                size += intercellSpacing.height
                size += d.tableView?(self, heightOfRow: index) ?? 0
            }
        }
        
        return size
    }
    
    
    public class func makeStandardTable(in view:NSView) -> UTTableView {
        let scrollView = UTScrollView(frame: view.bounds)
        scrollView.hasVerticalScroller = true
        let tableView = UTTableView(frame: view.bounds)
        scrollView.documentView = tableView
        scrollView.legacyStyle = .customBackground
        tableView.setContentInsets(NSEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        view.setAsOnlySubviewAndFill(subview: scrollView)
        tableView.backgroundColor = .clear
        
        tableView.columnAutoresizingStyle = .lastColumnOnlyAutoresizingStyle
        let column = NSTableColumn()
        column.resizingMask = .autoresizingMask
        tableView.addTableColumn(column)
        
        return tableView
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    func initialise() {
        if #available(OSX 11.0, *) {
            self.style = .plain
        }
        
        self.selectionHighlightStyle = .none
        self.intercellSpacing = NSMakeSize(0, 0)
        self.headerView = nil
    }
       
    public override var frame: NSRect {
        didSet{
            if self.frame.width != oldValue.width {
                sizeLastColumnToFit()
            }
        }
    }
    
    public override func becomeFirstResponder() -> Bool {
        let isBecomingFirstResponder = super.becomeFirstResponder()
        
        if isBecomingFirstResponder{
            utTableViewDelegate?.firstResponderStatusChanged(sender:self, isFirstResponder:true)
        }
        
        return isBecomingFirstResponder
    }
    
    public override func resignFirstResponder() -> Bool{
        let isResigningFirstResponder = super.resignFirstResponder()
        
        if isResigningFirstResponder{
            utTableViewDelegate?.firstResponderStatusChanged(sender:self, isFirstResponder:false)
        }
        
        return isResigningFirstResponder
    }
    
    public func setContentInsets(_ insets:NSEdgeInsets) {
        if let clipView = superview as? NSClipView {
            clipView.automaticallyAdjustsContentInsets = false
            clipView.contentInsets = insets
        }
    }
    
    public override var numberOfColumns:Int{
        return 1
    }
    
    public func reloadDataForSelectionChanged(prevSelRow:Int, newSelRow:Int) {
        
        if isRowSelectable(row: newSelRow) {
            
            let indexSet = NSMutableIndexSet(index: newSelRow)
            
            if prevSelRow != -1 {
                indexSet.add(prevSelRow)
            }
            
            reloadData(forRowIndexes: indexSet as IndexSet, columnIndexes: NSIndexSet(index: 0) as IndexSet)
        }
    }
        
    public func setThemeColors() {
        //TODO : - Should we reload data or just update all visible cells
        reloadData()
        (self.enclosingScrollView as? ThemeableProtocol)?.setThemeColors()
    }
    
    @objc public func drawContextMenuHighlight(forRow row:Int){
        //Private API that causes blue border to be drawn on right click
        //Overriding to prevent blue border showing on right click
    }
    
    public override func selectRowIndexes(_ indexes: IndexSet, byExtendingSelection extend: Bool) {
        let previousRow = selectedRow
        super.selectRowIndexes(indexes, byExtendingSelection: extend)
        reloadDataForSelectionChanged(prevSelRow: previousRow, newSelRow: selectedRow)
    }
    
    @discardableResult
    public func selectAndScrollRow(_ row:Int) -> Bool {
        
        if self.delegate?.tableView?(self, shouldSelectRow: row) ?? true{
            selectRowIndexes(IndexSet(integer: row), byExtendingSelection: false)
            scrollRowToVisible(row)
            return true
        }
        
        return false
    }
    
    public override func reloadData() {
        let selRow = selectedRow
        
        super.reloadData()
        
        if selRow != -1 {
            selectRowIndexes(IndexSet(integer: selRow), byExtendingSelection: false)
        }
    }
    
    public func deselectRow() {
        let rowIndexes = selectedRowIndexes
        deselectAll(nil)
        reloadData(forRowIndexes: rowIndexes, columnIndexes: IndexSet(integer: 0))
    }
    
    public func selectFirstRow() {
        deselectRow()
        
        let row = getFirstSelectableRow()
        guard row >= 0 else { return }
    
        let rowIndexSet = IndexSet(integer:row)
        selectRowIndexes(rowIndexSet, byExtendingSelection: false)
        reloadData(forRowIndexes: rowIndexSet, columnIndexes: IndexSet(integer: 0))
    }
    
    private func getFirstSelectableRow() -> Int{
        
        guard numberOfRows > 0 else { return -1 }
        
        for i in 0..<numberOfRows{
            
            if isRowSelectable(row: i){
                return i
            }
        }
        
        return -1
    }
    public override func keyDown(with event: NSEvent) {
        guard let characters = event.charactersIgnoringModifiers,
                  characters.unicodeScalars.count == 1,
                let key = characters.unicodeScalars.first?.value else{
            
            return super.keyDown(with: event)
        }
     
        //Check if the key pressed is a character we need to do special processing on
        let keyCode = Int(key)
        
        if isActionKeyCode(keyCode: keyCode){
            utTableViewDelegate?.invokeActionForSelectedRow(sender: self)
            return
        }
        else if keyCode == NSEvent.SpecialKey.tab.rawValue{
            if let nextValidKeyView = self.nextValidKeyView{
                self.window?.makeFirstResponder(nextValidKeyView)
                return
            }
        }
        else if keyCode == NSEvent.SpecialKey.backTab.rawValue{
            if let previousValidKeyView = self.previousValidKeyView{
                self.window?.makeFirstResponder(previousValidKeyView)
                return
            }
        }
        else if keyCode == NSEvent.SpecialKey.rightArrow.rawValue {
            
            if utTableViewDelegate?.hasRowSubMenu(sender: self, row: selectedRow) == true {
                utTableViewDelegate?.invokeActionForSelectedRow(sender: self)
                return
            }
            
        }
        else if keyCode == NSEvent.SpecialKey.leftArrow.rawValue{
            
            //TODO: check is sub menu and close if it is
            
        }
                
        return super.keyDown(with: event)
    }
    
    private func isActionKeyCode(keyCode:Int) -> Bool{
        return keyCode == NSEvent.SpecialKey.enter.rawValue ||
                keyCode == NSEvent.SpecialKey.newline.rawValue ||
                keyCode == NSEvent.SpecialKey.carriageReturn.rawValue
    }
    
    private func isRowSelectable(row:Int) -> Bool {
        return self.delegate?.tableView?(self, shouldSelectRow: row) ?? true
    }
}
