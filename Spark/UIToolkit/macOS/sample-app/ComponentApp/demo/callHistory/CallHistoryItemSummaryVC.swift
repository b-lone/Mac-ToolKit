//
//  CallHistoryItemSummaryVC.swift
//  ComponentApp
//
//  Created by James Nestor on 16/06/2021.
//

import Cocoa
import UIToolkit

class CallHistoryItemSummaryVC: UTBaseViewController {
    
    @IBOutlet var fakeAvatar: UTRoundButton!
    @IBOutlet var callTitle: NSTextField!
    @IBOutlet var number: NSTextField!
    var callHistoryItems:[TestCallHistoryTableData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
        fakeAvatar.buttonHeight = .large
        fakeAvatar.fontIcon     = .peopleBold
    }
    
    override func setThemeColors() {
        super.setThemeColors()
    }
    
    func setData(items: [TestCallHistoryTableData]){
        _ = self.view
        callHistoryItems = items
        
        guard let item = items.first else { return }
        setData(item: item)
    }
    
    private func setData(item: TestCallHistoryTableData){
        
        callTitle.stringValue = item.displayName
        number.stringValue = item.number
    }
    
}
