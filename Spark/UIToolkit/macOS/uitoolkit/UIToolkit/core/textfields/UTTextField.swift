//
//  UTTextField.swift
//  UIToolkit
//
//  Created by James Nestor on 12/05/2021.
//

import Cocoa

public protocol UTTextFieldDelegate : AnyObject{
    func onFocusStateChanged(_ textField: UTTextField, hasFocus: Bool)
}

public class UTTextField: NSTextField, ThemeableProtocol {
    
    enum Style  {
        //Mose text input in the app have the same style and should use this
        case textInput
        
        //Global header needs its own style as legacy is different and co branding
        case globalSearch
        
        var backgroundToken: String {
            switch self{
            case .textInput:
                return UTColorTokens.textinputBackground.rawValue
            case .globalSearch:
                return UTColorTokens.globalHeaderTextfieldBackground.rawValue
            }
        }
        
        var textToken:String {
            switch self{
            case .textInput:
                return UTColorTokens.textinputText.rawValue
            case .globalSearch:
                return UTColorTokens.globalHeaderTextfieldText.rawValue
            }
        }
        
        var borderToken:String {
            switch self{
            case .textInput:
                return UTColorTokens.textinputBorder.rawValue
            case .globalSearch:
                return UTColorTokens.globalHeaderTextfieldBorder.rawValue
            }
        }
        
        var placeholderStringToken:String {
            switch self{
            case .textInput:
                return UTColorTokens.textinputPlaceholderText.rawValue
            case .globalSearch:
                return UTColorTokens.globalHeaderTextfieldPlaceholderTextText.rawValue
            }
        }
        
        var backgroundColorStates:UTColorStates {
            return UIToolkit.shared.getThemeManager().getColors(tokenName: backgroundToken)
        }
        
        var textColorStates:UTColorStates {
            return UIToolkit.shared.getThemeManager().getColors(tokenName: textToken)
        }
        
        var borderColorStates:UTColorStates {
            return UIToolkit.shared.getThemeManager().getColors(tokenName: borderToken)
        }
        
        var placeholderTextColorStates: UTColorStates {
            return UIToolkit.shared.getThemeManager().getColors(tokenName: placeholderStringToken)
        }
    }
    
    private var trackingArea:NSTrackingArea!
    public weak var utTextFieldDelegate: UTTextFieldDelegate?
    
    var clearIcon:UTCancelIconButton?
    var fontType:UTFontType = .bodyPrimary
    var hasLeadingIconPadding = false
    
    var wantsClearIcon:Bool = true{
        didSet{
            updateClearIconVisibility()
            updateTrailingCellPadding()
        }
    }
    
    public var size: UTTextFieldSize = .large {
        didSet {
            setFont()
            clearIcon?.fontIconSize = getClearIconSize()
            invalidateIntrinsicContentSize()
        }
    }
    
    public var validationState:UTTextFieldValidationState = .noError{
        didSet{
            setThemeColors()
        }
    }
    
    public override var intrinsicContentSize: NSSize{
        let intrinsicSize = super.intrinsicContentSize
        return NSMakeSize(intrinsicSize.width, size.height)
    }
    
    var style:Style = .textInput {
        didSet {
            if oldValue != style {
                onStyleUpdated()
            }
        }
    }
    
    var isFocused: Bool = false {
        didSet{
            focusStateChanged(isFocused: isFocused)
        }
    }
    
    var backgroundColors:UTColorStates {
        if validationState == .error {
            return UIToolkit.shared.getThemeManager().getColors(token: .textinputErrorBackground)
        }
        
        return style.backgroundColorStates
    }
    
    var textColors:UTColorStates {
        if validationState == .error {
            return UIToolkit.shared.getThemeManager().getColors(token: .textinputErrorText)
        }
        
        return style.textColorStates
    }
    
    var borderColors:UTColorStates {
        if validationState == .error {
            return UIToolkit.shared.getThemeManager().getColors(token: .textinputErrorBorder)
        }
        
        return style.borderColorStates
    }
    
    var placeholderStringColors:UTColorStates {
        return style.placeholderTextColorStates
    }
    
    public override var isEnabled: Bool{
        didSet{
            setThemeColors()
            clearIcon?.isEnabled = isEnabled
        }
    }
        
    public override var placeholderString: String?{
        set{
            setPlaceholderString(placeholderStr: newValue)
        }
        get{
            return self.placeholderAttributedString?.string
        }
    }
    
    public override var stringValue: String{
        didSet{
            updateClearIconVisibility()
            updateTrailingCellPadding()
        }
    }
    
    public override var isEditable: Bool {
        didSet {
            setThemeColors()
            updateClearIconVisibility()
        }
    }
    
    fileprivate var isMouseEntered: Bool = false{
        didSet{
            if oldValue != isMouseEntered{
                updateStateColors()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.placeholderString = super.placeholderString
        initialise()
    }
    
    override init(frame frameRect: NSRect) {        
        super.init(frame: frameRect)
        initialise()
    }
    
    init(size: UTTextFieldSize, frame:NSRect = NSZeroRect) {
        super.init(frame: frame)
        self.size = size
        initialise()
    }
    
    deinit{
        if let _ = trackingArea{
            self.removeTrackingArea(trackingArea)
        }
    }
    
    func initialise(){
        initCell()
        
        self.wantsLayer = true
        self.drawsBackground = false
        self.isBordered = false
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = 8
        self.maximumNumberOfLines = 1
        
        setupClearIcon()
        setThemeColors()
        setFont()
    }
    
    internal func initCell(){
        self.cell = UTTextFieldCell(with: self)
    }
    
    private func setupClearIcon(){
        
        clearIcon           = UTCancelIconButton()
        clearIcon?.target   = self
        clearIcon?.action   = #selector(UTTextField.clearSearchAction)
        clearIcon?.isHidden = true
        clearIcon?.preventFirstResponder = true
        clearIcon?.translatesAutoresizingMaskIntoConstraints = false
        clearIcon?.fontIconSize = getClearIconSize()
        
        if let clearIcon = clearIcon{
            self.addSubview(clearIcon)
        
            let wConstraint             = NSLayoutConstraint.createWidthConstraint(firstItem: clearIcon, constant: clearIcon.heightFloat)
            let hConstraint             = NSLayoutConstraint.createHeightConstraint(firstItem: clearIcon, constant: clearIcon.heightFloat)
            let verticalConstraint      = NSLayoutConstraint(item: clearIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
            let clearTrailingConstraint = NSLayoutConstraint(item: clearIcon, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -6)

            NSLayoutConstraint.activate([wConstraint, hConstraint, verticalConstraint, clearTrailingConstraint])
            updateTrailingCellPadding()
        }
    }
    
    public func setThemeColors(){
        clearIcon?.setThemeColors()
        updatePlaceholderStringStyle()
        
        updateStateColors()
        
        updateCursorColor()
        self.needsDisplay = true
    }
    
    ///Will be called by text field editor when it recieves paste
    ///return false to allow default handling
    func onPasteAction(_ sender:Any?) -> Bool {
        return false
    }
    
    func setFont(){
        self.font = size.font
        updatePlaceholderStringStyle()
    }
    
    public override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if trackingArea == nil{
            trackingArea = NSTrackingArea(rect: NSZeroRect,
                                          options: [.inVisibleRect,
                                                    .activeAlways,
                                                    .mouseEnteredAndExited],
                                          owner: self,
                                          userInfo: nil)
        }
        
        if !self.trackingAreas.contains(trackingArea){
            self.addTrackingArea(trackingArea)
        }
        
        isMouseEntered = isMouseInView
    }
    
    public override func resetCursorRects() {
        discardCursorRects()
                
        if clearIcon?.isHidden == false {
            addCursorRect(NSMakeRect(self.bounds.maxX - UTTextFieldCellTrailingIconPadding, self.bounds.minY, UTTextFieldCellTrailingIconPadding, self.bounds.height), cursor: .arrow)
            addCursorRect(NSMakeRect(self.bounds.minX, self.bounds.minY, self.bounds.width - UTTextFieldCellTrailingIconPadding, self.bounds.height), cursor: .iBeam)
        }
        else{
            addCursorRect(self.bounds, cursor: .iBeam)
        }
    }
    
    public override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        isMouseEntered = true
    }
    
    public override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        isMouseEntered = false
    }
    
    public func setFocusWithCursorAtEnd(){
        if self.currentEditor() == nil{
            self.window?.makeFirstResponder(self)
        }
        
        self.currentEditor()?.moveToEndOfLine(nil)
    }
    
    public func setFocus(){
        self.window?.makeFirstResponder(self)
    }
    
    public override func textDidChange(_ notification: Notification) {
        updateClearIconVisibility()
        super.textDidChange(notification)
    }
    
    @IBAction public func clearSearchAction(_ sender: AnyObject) {
        if self.isEditable{
            self.stringValue = ""
            
            setFocusWithCursorAtEnd()
            self.needsDisplay = true
            
            //When text changes the field editor sends a text did change notification to the control. Mimic this event on clear button action
            self.textDidChange(Notification(name: NSText.didChangeNotification, object: currentEditor()))
        }
    }
    
    internal func focusStateChanged(isFocused:Bool){
        setThemeColors()
        utTextFieldDelegate?.onFocusStateChanged(self, hasFocus: isFocused)
    }
    
    internal func updateStateColors() {
        guard let layer = self.layer else { return }
        
        if !isEnabled{
            layer.backgroundColor = backgroundColors.disabled.cgColor
            layer.borderColor     = borderColors.disabled.cgColor
            textColor             = textColors.disabled
        }
        else if !isEditable{
            layer.backgroundColor = backgroundColors.normal.cgColor
            layer.borderColor     = borderColors.normal.cgColor
            textColor             = textColors.normal
        }
        else if isFocused{
            layer.backgroundColor = backgroundColors.focused.cgColor
            layer.borderColor     = borderColors.focused.cgColor
            textColor             = textColors.focused
        }
        else if isMouseEntered{
            layer.backgroundColor = backgroundColors.hover.cgColor
            layer.borderColor     = borderColors.hover.cgColor
            textColor             = textColors.hover
        }
        else{
            layer.backgroundColor = backgroundColors.normal.cgColor
            layer.borderColor     = borderColors.normal.cgColor
            textColor             = textColors.normal
        }
    }
    
    private func setPlaceholderString(placeholderStr:String?) {
        guard let placeholderStr = placeholderStr else {
            self.placeholderAttributedString = nil
            return
        }
        
        let placeholderFont = self.font ?? self.fontType.font()
        self.placeholderAttributedString = NSAttributedString(string: placeholderStr, attributes: [NSAttributedString.Key.foregroundColor: placeholderStringColors.normal,
                                                                                                   NSAttributedString.Key.font: placeholderFont])

    }
    
    func updatePlaceholderStringStyle(){
        
        guard let placeholderStr = self.placeholderAttributedString?.string else { return }
        
        let font = self.font ?? self.fontType.font()
        let attsDictionary = [NSAttributedString.Key.foregroundColor: placeholderStringColors.normal,
                              NSAttributedString.Key.font: font]
        self.placeholderAttributedString = NSAttributedString(string: placeholderStr, attributes: attsDictionary)
    }
    
    private func updateCursorColor(){
        guard let fieldEditor = self.window?.fieldEditor(true, for: self) as? NSTextView else { return }
        
        fieldEditor.insertionPointColor = textColors.normal
    }
    
    internal func updateClearIconVisibility(){
        
        guard let clearIcon = clearIcon else { return }
        var stateChanged = false
        
        if self.wantsClearIcon && !self.stringValue.isEmpty && self.isEditable {
            stateChanged = clearIcon.isHidden == true
            clearIcon.isHidden = false
        }
        else{
            stateChanged = clearIcon.isHidden == false
            clearIcon.isHidden = true
        }
        
        if stateChanged{
            self.window?.invalidateCursorRects(for: self)
        }
    }

    internal func updateTrailingCellPadding(){
        if let cell = self.cell as? UTBaseTextFieldCellProtocol{
            if wantsClearIcon{
                cell.updateTrailingPadding(value: UTTextFieldCellTrailingIconPadding)
            }
            else{
                cell.updateTrailingPadding(value: UTTextFieldCellDefaultTrailingPadding)
            }
        }
    }
    
    internal func updateLeadingCellPadding(addLeadingIconPadding:Bool) {
        guard hasLeadingIconPadding != addLeadingIconPadding else { return }
        
        hasLeadingIconPadding = addLeadingIconPadding
        if let cell = self.cell as? UTBaseTextFieldCellProtocol {
            
            if hasLeadingIconPadding {
                let padding = self.size == .large ? UTTextFieldCellLargeIconLeadingPadding : UTTextFieldCellSmallIconLeadingPadding
                cell.updateLeadingPadding(value:  padding)
            }
            else{
                cell.updateLeadingPadding(value: UTTextFieldCellDefaultLeadingPadding)
            }
        }
    }
    
    internal func getClearIconSize() -> CGFloat {
        if style == .globalSearch {
            return UTTextFieldSize.getClearIconSize(size: .extraLarge)
        }
        
        return size.clearIconSize
    }
    
    internal func onStyleUpdated() {
        clearIcon?.icon = getClearButtonIcon()
        setThemeColors()
    }
    
    private func getClearButtonIcon() -> UTIconButton.Icon{
        return style == .globalSearch ? .globalHeaderCancel : .cancel
    }
    
    internal func isLayoutDirectionRightToLeft() -> Bool {
        return NSApp.userInterfaceLayoutDirection == .rightToLeft
    }
}
