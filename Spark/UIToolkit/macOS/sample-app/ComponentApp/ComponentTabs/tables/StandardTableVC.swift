//
//  StandardTableVC.swift
//  ComponentApp
//
//  Created by James Nestor on 17/06/2021.
//

import Cocoa
import UIToolkit

class StandardTableVC: UTBaseViewController {

    @IBOutlet var tableView: UTStandardTableView!
    private var callDurationTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        buildCallHistoryDataSource()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        startCallTimer()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        stopTimer()
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        tableView.setThemeColors()
    }
    
    @IBAction func tableMenuItemAction(_ sender: Any){
        let alert = NSAlert()
        alert.messageText = "menu item action"
        alert.runModal()
    }
    
    @IBAction func chatButtonAction(_ sender: Any){
        guard let button = sender as? UTButton else { return }
        let row = tableView.rowViewFor(view: button)
        NSLog("Chat button actioned at row: \(row)")
    }
    
    @IBAction func audioCallButtonAction(_ sender: Any){
        guard let button = sender as? UTButton else { return }
        let row = tableView.rowViewFor(view: button)
        NSLog("audio button actioned at row: \(row)")
    }
    
    @IBAction func videoCallButtonAction(_ sender: Any){
        guard let button = sender as? UTButton else { return }
        let row = tableView.rowViewFor(view: button)
        NSLog("video button actioned at row: \(row)")
    }
    
    private func buildCallHistoryDataSource(){
        var dataSource = TestCallHistoryTableData.buildTestActiveCallData(count: 2)
        dataSource.append(contentsOf: TestCallHistoryTableData.buildTestData(count: 500))
        tableView.setDataSource(dataSource: dataSource)
    }
    
    private func startCallTimer() {

        if callDurationTimer == nil {
            callDurationTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(StandardTableVC.updateCallTimer), userInfo: nil, repeats: true)            
        }
        callDurationTimer.fire()
    }
    
    private func stopTimer(){
        callDurationTimer.invalidate()
        callDurationTimer = nil
        
    }
    
    @objc private func updateCallTimer(timer: Timer) {
        
        let datasource = tableView.dataSource
        for i in 0..<datasource.count{
            if let record = datasource[i] as? TestCallHistoryTableData{
                if record.uniqueId.contains("CallBricklet"){
                    let callDurationString = String.formatCallDurationSinceDate(record.callStartDate)
                    tableView.updateCallButtonText(text: callDurationString, row: i)
                }
            }
        }
    }
    
}

extension StandardTableVC: UTStandardTableViewDelegate{
   
    func rowClicked(sender: UTTableView, row: Int) {
        NSLog("row clicked on table: \(sender.description) at row: \(row)")
    }
    
    func rowDoubleClicked(sender: UTTableView, row: Int) {
        NSLog("row double clicked on table: \(sender.description) at row: \(row)")
    }
    
    func invokeActionForSelectedRow(sender: UTTableView, row: Int) {
        NSLog("invoke action for selected row on table: \(sender.description) at row: \(row)")
    }
        
    func rightClickMenu(sender:UTTableView, row: Int, parentMenu:NSMenu) {
        
        parentMenu.addItem(NSMenuItem(title: "Menu Item row: " + String(row), action: #selector(StandardTableVC.tableMenuItemAction), keyEquivalent: ""))
        parentMenu.addItem(NSMenuItem(title: "Menu Item row: " + String(row), action: #selector(StandardTableVC.tableMenuItemAction), keyEquivalent: ""))
        parentMenu.addItem(NSMenuItem(title: "Menu Item row: " + String(row), action: #selector(StandardTableVC.tableMenuItemAction), keyEquivalent: ""))
        parentMenu.addItem(NSMenuItem(title: "Menu Item row: " + String(row), action: #selector(StandardTableVC.tableMenuItemAction), keyEquivalent: ""))
    }
    
    func getUTStandardTableCellViewData(sender: UTTableView, data:Any) -> UTStandardTableCellViewData {
        
        var uniqueId = ""
        var primaryTitleLabel = NSMutableAttributedString(string:"Title")
        var primaryTitleSecondLineLabel = "Second line"
        var subTitleLabel = "Subtitle"
        var subTitleSecondLine = "Second line"
        
        var hoverButtons:[UTButton] = []
        var icons:[UTIcon] = []
        var indicatorBadges:[UTIndicatorBadge] = []
        var callButton:UTPillButton?
        
        if let data = data as? TestCallHistoryTableData{
            
            uniqueId = data.uniqueId
            primaryTitleLabel = NSMutableAttributedString(string:data.displayName)
            primaryTitleSecondLineLabel = data.number
            
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .short
            subTitleLabel = dateformatter.string(from: data.callStartDate)
            
            let timeformatter = DateFormatter()
            timeformatter.dateFormat = "HH:mm"
            subTitleSecondLine = timeformatter.string(from: data.callStartDate)
            
            if data.hasActiveCall {
                callButton = UTPillButton()
                callButton?.buttonHeight = .small
                callButton?.style = .join
                callButton?.title = String.formatCallDurationSinceDate(data.callStartDate)
            }
            
            if data.canMessage {
                let chatButton      = UTRoundButton()
                chatButton.buttonHeight = .small
                chatButton.fontIcon = .chatRegular
                chatButton.style = .message
                chatButton.action = #selector(chatButtonAction)
                chatButton.target = self
                
                hoverButtons.append(chatButton)
            }
            
            if data.canCall {
                let audioCallButton      = UTRoundButton()
                audioCallButton.buttonHeight = .small
                audioCallButton.fontIcon = .handsetRegular
                audioCallButton.style    = .join
                audioCallButton.action   = #selector(audioCallButtonAction)
                audioCallButton.target   = self

                let videoCallButton      = UTRoundButton()
                videoCallButton.buttonHeight = .small
                videoCallButton.fontIcon = .videoRegular
                videoCallButton.style    = .join
                videoCallButton.action   = #selector(videoCallButtonAction)
                videoCallButton.target   = self
                
                hoverButtons.append(contentsOf: [audioCallButton, videoCallButton])
            }
            
            if data.isOutGoing {
                let indicatorBadge = UTIndicatorBadge()
                indicatorBadge.badgeType = .outgoingCall
                
                indicatorBadges.append(indicatorBadge)
            }
            
            if data.isUnread {
                let indicatorBadge = UTIndicatorBadge()
                indicatorBadge.badgeType = .unread
                
                indicatorBadges.append(indicatorBadge)
            }
            
            if data.isSecure {
                icons.append(UTIcon(iconType: .secureLockBold, style: .secondary))
            }
            
            if data.isPrivate {
                icons.append(UTIcon(iconType: .privateBold, style: .secondary))
            }
            
            if data.hasInfo {
                icons.append(UTIcon(iconType: .infoCircleBold, style: .error))
            }
            
        }
        
        return UTStandardTableCellViewData(uniqueId: uniqueId,
                                           primaryTitleLabel: primaryTitleLabel,
                                           primaryTitleSecondLineLabel: primaryTitleSecondLineLabel,
                                           subTitleLabel: subTitleLabel,
                                           subTitleSecondLineLabel: subTitleSecondLine,
                                           subtitleIcons: icons,
                                           indicatorBadges: indicatorBadges,
                                           hoverButtons: hoverButtons,
                                           callButton: callButton)
        
    }
}
