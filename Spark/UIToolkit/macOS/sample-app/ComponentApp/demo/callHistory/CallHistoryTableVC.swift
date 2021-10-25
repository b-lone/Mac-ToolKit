//
//  CallHistoryTableVC.swift
//  ComponentApp
//
//  Created by James Nestor on 15/06/2021.
//

import Cocoa
import UIToolkit

protocol CallHistoryTableVCDelegate: AnyObject{
    func callHistoryItemSelected(items:[TestCallHistoryTableData])
}

class CallHistoryTableVC: UTBaseViewController {
    
    private var tableView: UTTableView!
    
    private var fullDataSource:[TestCallHistoryTableData] = []
    private var dataSource:[TestCallHistoryTableData] = []
    weak var delegate:CallHistoryTableVCDelegate?
    
    private var size: TableSizeInfo = TableSizeInfo(rowSize: .large)
    var tableMenu: NSMenu = NSMenu(title: "TableMenu")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UTTableView.makeStandardTable(in: view)
        
        tableView.delegate            = self
        tableView.utTableViewDelegate = self
        tableView.dataSource          = self
        tableView.action              = #selector(onTableAction)
        tableView.doubleAction        = #selector(onTableDoubleAction)
        tableView.target              = self
        
        tableView.menu = tableMenu
        tableMenu.delegate = self
        
        tableView.delegate = self
        buildCallHistoryDataSource()        
    }
    
    override func setThemeColors() {
        super.setThemeColors()        
        tableView.setThemeColors()
    }
    
    private func buildCallHistoryDataSource(){        
        fullDataSource.append(contentsOf: TestCallHistoryTableData.buildTestData(count: 500))
    }
    
    public func showAllCalls(){
        dataSource = fullDataSource
        tableView.reloadData()
    }
    
    public func showMissedCalls(){
        dataSource = fullDataSource.filter({ $0.isMissed })
        tableView.reloadData()
    }
    
    @IBAction func tableMenuItemAction(_ sender: Any){
        let alert = NSAlert()
        alert.messageText = "menu item action"
        alert.runModal()
    }
    
    @objc func onTableAction(_ sender: AnyObject) {
        NSLog("row clicked on table: \(String(describing: sender.description)) at row: \(tableView.clickedRow)")
        guard let item = dataSource.getItemAtIndex(tableView.clickedRow)  else { return }

        delegate?.callHistoryItemSelected(items:[item])
    }
    
    @objc func onTableDoubleAction(_ sender: AnyObject){
        NSLog("row double clicked on table: \(String(describing: sender.description)) at row: \(tableView.clickedRow)")
        guard let item = dataSource.getItemAtIndex(tableView.clickedRow) else { return }

        let alert = NSAlert()
        alert.messageText = "Calling:[\(item.displayName)] on number:[\(item.number)] for row double click"
        alert.runModal()
    }
}

//MARK: - CallHistoryTableCellViewDelegate
extension CallHistoryTableVC : CallHistoryTableCellViewDelegate{
    func chatButtonAction(_ sender:Any) {
        guard let button = sender as? UTButton else { return }
        let row = tableView.row(for: button)
        NSLog("Chat button actioned at row: \(row)")

        guard let item = dataSource.getItemAtIndex(row) else { return }

        let alert = NSAlert()
        alert.messageText = "chat button action for :[\(item.displayName)] on number:[\(item.number)]"
        alert.runModal()
    }
    
    func audioCallAction(_ sender:Any) {
        guard let button = sender as? UTButton else { return }
        let row = tableView.row(for: button)
        NSLog("audio button actioned at row: \(row)")

        guard let item = dataSource.getItemAtIndex(row) else { return }

        let alert = NSAlert()
        alert.messageText = "audio call button action for :[\(item.displayName)] on number:[\(item.number)]"
        alert.runModal()
    }
    
    func videoCallAction(_ sender:Any) {
        guard let button = sender as? UTButton else { return }
        let row = tableView.row(for: button)
        NSLog("video button actioned at row: \(row)")

        guard let item = dataSource.getItemAtIndex(row) else { return }

        let alert = NSAlert()
        alert.messageText = "video call button action for :[\(item.displayName)] on number:[\(item.number)]"
        alert.runModal()
    }
}

//MARK: - NSTableViewDataSource
extension CallHistoryTableVC : NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dataSource.count
    }
}

//MARK: - NSTableViewDelegate
extension CallHistoryTableVC : NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        return self.size.getRowHeight()
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return UTTableRowView.makeWithIdentifier(tableView, rowIdentifier: "UTRoundedTableRowView", owner: self, style: .pill)
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            
        if let data = dataSource.getItemAtIndex(row){
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CallHistoryTableCellView"), owner: self) as? CallHistoryTableCellView ?? CallHistoryTableCellView(frame: NSZeroRect)
            cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: "CallHistoryTableCellView")
            cellView.updateData(data: data, isSelected: tableView.selectedRow == row)
            cellView.delegate = self
            return cellView
        }
        
        return nil
    }
    
}

//MARK: - UTTableViewDelegete extension
extension CallHistoryTableVC : UTTableViewDelegate {
    func firstResponderStatusChanged(sender: UTTableView, isFirstResponder:Bool){
        if isFirstResponder && sender.selectedRow == -1 {
            sender.selectFirstRow()
        }
    }
    
    func invokeActionForSelectedRow(sender:UTTableView){
        NSLog("invoke action for selected row on table: \(sender.description) at row: \(tableView.selectedRow))")
        guard let item = dataSource.getItemAtIndex(tableView.selectedRow) else { return }

        delegate?.callHistoryItemSelected(items:[item])
    }
}

//MARK: - NSMenuDelegate extension
extension CallHistoryTableVC : NSMenuDelegate {
    
    public func menuWillOpen(_ menu: NSMenu) {
        if menu == tableMenu {
            menu.addItem(NSMenuItem(title: "Menu Item row: " + String(tableView.clickedRow), action: #selector(tableMenuItemAction), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Menu Item row: " + String(tableView.clickedRow), action: #selector(tableMenuItemAction), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Menu Item row: " + String(tableView.clickedRow), action: #selector(tableMenuItemAction), keyEquivalent: ""))
            menu.addItem(NSMenuItem(title: "Menu Item row: " + String(tableView.clickedRow), action: #selector(tableMenuItemAction), keyEquivalent: ""))
        }
    }
    
    public func menuDidClose(_ menu: NSMenu) {
        if menu == tableMenu{
            tableMenu.removeAllItems()
        }
    }
}

protocol CallHistoryTableCellViewDelegate: AnyObject {
    func chatButtonAction(_ sender:Any)
    func audioCallAction(_ sender:Any)
    func videoCallAction(_ sender:Any)
}

class CallHistoryTableCellView : UTTableCellView {
    
    //Container stack view
    private var containerStackView:NSStackView!
    
    //Avatar
    private var avatarView: UTAvatarView!
    
    //Title stack view
    private var titleStackView: NSStackView!
    private var titleLabel:UTLabel!
    private var titleSecondLinelabel:UTLabel!
    
    //Sub title
    private var subtitleStackView:NSStackView!
    private var subTitleLabel:UTLabel!
    private var subtitleSecondLineStackView:NSStackView!
    private var subTitleSecondLineLabel:UTLabel!
    
    private var subTitleIcons:[UTIcon] = []
    
    //Hover and selection buttons
    private var chatButton:UTRoundButton!
    private var audioCallButton:UTRoundButton!
    private var videoCallButton:UTRoundButton!
    
    private var outgoingCallIcon:UTIndicatorBadge!
    private var infoCircle:UTIcon!
    private var privateIcon:UTIcon!
    private var secureIcon:UTIcon!
    
    private var isSelected:Bool = false
    private var uniqueId:String = ""
    
    private var data:TestCallHistoryTableData?
    weak var delegate:CallHistoryTableCellViewDelegate?
    
    override internal func initialise(){
        
        //Configure container stack view
        containerStackView              = NSStackView()
        containerStackView.wantsLayer   = true
        containerStackView.orientation  = .horizontal
        containerStackView.edgeInsets   = NSEdgeInsets(top: 0, left: 24, bottom: 0, right: 8)
        containerStackView.distribution = .fillProportionally
        containerStackView.identifier   = NSUserInterfaceItemIdentifier(rawValue: "ContainerStackView")
        containerStackView.setClippingResistancePriority(.init(751), for: .horizontal)
                
        setAsOnlySubviewAndFill(subview: containerStackView)
        
        outgoingCallIcon           = UTIndicatorBadge()
        outgoingCallIcon.badgeType = .outgoingCall
        
        avatarView = UTAvatarView()
                
        //Title section
        titleStackView              = NSStackView()
        titleStackView.wantsLayer   = true
        titleStackView.distribution = .fillProportionally
        titleStackView.orientation  = .vertical
        titleStackView.alignment    = .leading
        titleStackView.spacing      = 0
        titleStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleStackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        titleStackView.identifier = NSUserInterfaceItemIdentifier(rawValue: "TitleStackView")
        
        titleLabel = UTLabel(fontType: .bodyPrimary)
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleSecondLinelabel = UTLabel(fontType: .bodyCompact, style: .secondary)
        titleSecondLinelabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleSecondLinelabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(titleSecondLinelabel)

        //Subtitle section
        subtitleStackView                = NSStackView()
        subtitleStackView.wantsLayer     = true
        subtitleStackView.orientation    = .vertical
        subtitleStackView.alignment      = .right
        subtitleStackView.edgeInsets.top = 4
        subtitleStackView.spacing        = 2
        subtitleStackView.setHuggingPriority(.required, for: .vertical)
        subtitleStackView.identifier = NSUserInterfaceItemIdentifier(rawValue: "SubtitleStackView")
                
        subTitleLabel = UTLabel(fontType: .bodyCompact, style: .secondary)
        subTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        subTitleLabel.identifier = NSUserInterfaceItemIdentifier(rawValue: "SubTitleLabel")
        
        subtitleStackView.addArrangedSubview(subTitleLabel)
        
        //Subtitle second line stack view
        subtitleSecondLineStackView              = NSStackView()
        subtitleSecondLineStackView.wantsLayer   = true
        subtitleSecondLineStackView.orientation  = .horizontal
        subtitleSecondLineStackView.alignment    = .centerY
        subtitleSecondLineStackView.distribution = .fillProportionally
        subtitleSecondLineStackView.identifier   = NSUserInterfaceItemIdentifier(rawValue: "SubtitleSecondLineStackView")
        subtitleSecondLineStackView.spacing      = 6
        subtitleSecondLineStackView.setHuggingPriority(.required, for: .vertical)
                
        subTitleSecondLineLabel = UTLabel(fontType: .bodyCompact, style: .secondary)
        subTitleSecondLineLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subTitleSecondLineLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        subTitleSecondLineLabel.identifier = NSUserInterfaceItemIdentifier(rawValue: "SubTitleSecondLineLabel")
        
        infoCircle = UTIcon(iconType: .infoCircleBold, style: .error)
        privateIcon = UTIcon(iconType: .privateBold,   style: .secondary)
        secureIcon = UTIcon(iconType: .secureLockBold, style: .secondary)
        
        subtitleSecondLineStackView.addArrangedSubview(infoCircle)
        subtitleSecondLineStackView.addArrangedSubview(secureIcon)
        subtitleSecondLineStackView.addArrangedSubview(privateIcon)                
        subtitleSecondLineStackView.addArrangedSubview(subTitleSecondLineLabel)
        subtitleSecondLineStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        subtitleStackView.addArrangedSubview(subtitleSecondLineStackView)
        subtitleSecondLineStackView.addArrangedSubview(subTitleSecondLineLabel)
        
        chatButton              = UTRoundButton()
        chatButton.buttonHeight = .small
        chatButton.fontIcon     = .chatRegular
        chatButton.style        = .message
        chatButton.action       = #selector(chatButtonAction)
        chatButton.target       = self

        audioCallButton              = UTRoundButton()
        audioCallButton.buttonHeight = .small
        audioCallButton.fontIcon     = .handsetRegular
        audioCallButton.style        = .join
        audioCallButton.action       = #selector(audioCallButtonAction)
        audioCallButton.target       = self

        videoCallButton              = UTRoundButton()
        videoCallButton.buttonHeight = .small
        videoCallButton.fontIcon     = .videoRegular
        videoCallButton.style        = .join
        videoCallButton.action       = #selector(videoCallButtonAction)
        videoCallButton.target       = self
        
        containerStackView.addArrangedSubview(outgoingCallIcon)
        containerStackView.addArrangedSubview(avatarView)
        containerStackView.addArrangedSubview(titleStackView)
        containerStackView.addArrangedSubview(subtitleStackView)
        
        containerStackView.addArrangedSubview(chatButton)
        containerStackView.addArrangedSubview(audioCallButton)
        containerStackView.addArrangedSubview(videoCallButton)
        
        containerStackView.setCustomSpacing(6, after: outgoingCallIcon)
        
        updateButtonVisibility(bShow: false)
        
        super.initialise()
    }
    
    override public func setThemeColors() {
        
        avatarView.setThemeColors()
        titleLabel.setThemeColors()
        titleSecondLinelabel.setThemeColors()
        
        subTitleLabel.setThemeColors()
        subTitleSecondLineLabel.setThemeColors()
                
        for icon in subTitleIcons {
            icon.setThemeColors()
        }

        containerStackView.setThemeableViewColors()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func updateData(data:TestCallHistoryTableData, isSelected: Bool){
        self.data = data
        avatarView.dataSource = AvatarImageViewDataSource(size: .small, name: data.displayName, bgColor: .gray)
        
        self.titleLabel.stringValue = data.displayName
        
        if data.isMissed {
            titleLabel.style = .error
        }
        else {
            titleLabel.style = .primary
        }
        
        if data.isOutGoing {
            containerStackView.edgeInsets.left = 6
            outgoingCallIcon.isHidden = false
        }
        else {
            containerStackView.edgeInsets.left = 24
            outgoingCallIcon.isHidden = true
        }
        
        self.titleSecondLinelabel.stringValue = data.number
        self.titleSecondLinelabel.isHidden = data.number.isEmpty

        self.subTitleLabel.stringValue = data.dateCallString
        self.subTitleLabel.isHidden = subTitleLabel.stringValue.isEmpty
        
        self.subTitleSecondLineLabel.stringValue = data.timeCallString
        self.subTitleSecondLineLabel.isHidden = subTitleSecondLineLabel.stringValue.isEmpty == true
        
        secureIcon.isHidden  = !data.isSecure
        privateIcon.isHidden = !data.isPrivate
        infoCircle.isHidden  = !data.hasInfo
        
        self.updateButtonVisibility(bShow: isSelected || isMouseInVisibleRect)
        setThemeColors()
    }
       
    private func updateButtonVisibility(bShow:Bool){
        
        if bShow,
           let data = data{
            chatButton.isHidden      = !data.canMessage
            audioCallButton.isHidden = !data.canCall
            videoCallButton.isHidden = !data.canCall
        }
        else {
            chatButton.isHidden      = true
            audioCallButton.isHidden = true
            videoCallButton.isHidden = true
        }
        
        subtitleStackView.isHidden = bShow
    }
    
    override func mouseInRowUpdated(mouseInside: Bool) {
        updateButtonVisibility(bShow: mouseInside || isSelected)
    }
    
    @IBAction func chatButtonAction(_ sender: Any){
        delegate?.chatButtonAction(sender)
    }

    @IBAction func audioCallButtonAction(_ sender: Any){
        delegate?.audioCallAction(sender)
    }

    @IBAction func videoCallButtonAction(_ sender: Any){
        delegate?.videoCallAction(sender)
    }
}
