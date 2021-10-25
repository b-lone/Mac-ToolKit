//
//  FontWindow.swift
//  ComponentApp
//
//  Created by James Nestor on 28/06/2021.
//

import Cocoa
import UIToolkit

class FontWindow: NSWindowController, ThemeableProtocol, FontProtocol {

    override var windowNibName: NSNib.Name? { "FontWindow" }
    
    @IBOutlet var tablePlaceholder: NSView!
    var tableView:UTTableView!
    
    @IBOutlet var tableTitle: UTLabel!
    var dataSource:[UTFontType] = []
    
    @IBOutlet var sampleLabel: UTLabel!
    @IBOutlet var fontSizeTextField: UTLabel!
    @IBOutlet var weightTextField: UTLabel!
    @IBOutlet var scaleFactor: UTTextField!
    @IBOutlet var applyScaleButton: UTPillButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.window?.contentView?.wantsLayer = true
        
        tableView = UTTableView.makeStandardTable(in: tablePlaceholder)
        tableView.delegate   = self
        tableView.dataSource = self
        
        if #available(OSX 10.13, *) {
            tableView.usesAutomaticRowHeights = true
        } 
        
        tableTitle.fontType = .title
        tableTitle.style    = .primary
        
        dataSource = UTFontType.allCases
        tableView.reloadData()
        
        setThemeColors()
        sampleLabel.fontType = .bodyPrimary
        sampleLabel.style    = .primary
        
        applyScaleButton.buttonHeight = .small
        applyScaleButton.title = "Apply"
        
        fontSizeTextField.style    = .primary
        fontSizeTextField.fontType = .bodyCompact
        
        weightTextField.style     = .primary
        weightTextField.fontType  = .bodyCompact
        
        
        UIToolkit.shared.themeableProtocolManager.subscribe(listener: self)
        UIToolkit.shared.fontManager.subscribe(listener: self)
    }
    
    func setThemeColors() {
        self.window?.contentView?.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-primary").normal.cgColor
        
        if UIToolkit.shared.getThemeManager().isDarkTheme() {
            if #available(OSX 10.14, *) {
                self.window?.appearance = NSAppearance.init(named: .darkAqua)
            } else {
                self.window?.appearance = NSAppearance.init(named: .vibrantDark)
            }
        }
        else {
            self.window?.appearance = NSAppearance.init(named: .aqua)
        }
        
        sampleLabel.setThemeColors()
        tableTitle.setThemeColors()
        fontSizeTextField.setThemeColors()
        weightTextField.setThemeColors()
        applyScaleButton.setThemeColors()
        tableView.setThemeColors()
        scaleFactor.setThemeColors()
    }
    
    func updateFont() {
        sampleLabel.updateFont()
        tableTitle.updateFont()
        fontSizeTextField.updateFont()
        weightTextField.updateFont()
        applyScaleButton.title = "Apply"
        applyScaleButton.invalidateIntrinsicContentSize()
        tableView.reloadData()
    }
    
    func onLanguageChanged() {
     
    }
    
    @IBAction func applyScaleAction(_ sender: Any) {
        if let scale = NumberFormatter().number(from: scaleFactor.stringValue) {
            UIToolkit.shared.fontManager.scaleFactor = CGFloat(truncating: scale)
            UIToolkit.shared.fontManager.notifyListenersOnFontUpdated()
        }
    }
    
    @IBAction func comboBoxAction(_ sender: Any) {        

        if let item = sender as? NSComboBox {
            if item.indexOfSelectedItem == 0 {
                UserDefaults.standard.setValue("en", forKey: "UserLangauge")
            }
            else if item.indexOfSelectedItem == 1 {
                UserDefaults.standard.setValue("fr", forKey: "UserLangauge")
            }
        }
        
        UIToolkit.shared.localizationManager.notifyListenersOnLanguageUpdated()
    }
    
}

extension FontWindow : NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
}

extension FontWindow :  NSTableViewDelegate{
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        if let data = dataSource.getItemAtIndex(tableView.selectedRow){
            fontSizeTextField.stringValue = "Point size: " + data.sizeString
            weightTextField.stringValue   = "Weight: " + data.weightString
            sampleLabel.fontType          = data
        }
        
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
                
        return UTTableRowView.makeWithIdentifier(tableView, rowIdentifier: "UTRoundedTableRowView", owner: self, style: .rounded)
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        tableColumn?.width = tableView.bounds.width
        
        if let data = dataSource.getItemAtIndex(row) {
            
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FontTableCellView"), owner: self) as? FontTableCellView ?? FontTableCellView(frame: NSZeroRect)
            cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: "FontTableCellView")
            cellView.updateData(data: data)
            return cellView
            
        }
        
        return nil
    }
}

class FontTableCellView : UTTableCellView {
    
    var containerStackView:NSStackView!
    var fontTokenName: UTLabel!
    
    override func initialise() {
        super.initialise()
        
        containerStackView = NSStackView()
        containerStackView.wantsLayer = true
        containerStackView.distribution = .fillProportionally
        containerStackView.edgeInsets = NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        containerStackView.setHuggingPriority(.defaultLow, for: .horizontal)
        
        self.setAsOnlySubviewAndFill(subview: containerStackView)
        fontTokenName = UTLabel(fontType: .bodySecondary, style: .primary)
        
        
        containerStackView.addArrangedSubview(fontTokenName)        
    }
    
    func updateData(data: UTFontType) {
        
        fontTokenName.updateFont()
        fontTokenName.setThemeColors()
        fontTokenName.stringValue = data.tokenName
    }
    
}
