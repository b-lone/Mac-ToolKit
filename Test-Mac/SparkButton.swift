//
//  GreenNSButton.swift
//  SparkMacDesktop
//
//  Created by jimmcoyn on 30/08/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//

import Cocoa

class SparkButtonCell: NSButtonCell {

    var disabledButtonTextColor: NSColor?

    override func drawTitle(_ title: NSAttributedString, withFrame frame: NSRect, in controlView: NSView) -> NSRect {
        var title = title
        if !isEnabled {
            let attrString = NSMutableAttributedString.init(attributedString: attributedTitle)
//            let titleRange = NSRange(location: 0, length: attributedTitle.length)
//            attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: disabledButtonTextColor ?? NSColor.getDisabledButtonTextColor(), range: titleRange)
            title = attrString
        }
        return super.drawTitle(title, withFrame: frame, in: controlView)
    }
}

class VerticalSparkButtonCell: SparkButtonCell {

    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var topTextPadding: CGFloat = 0

    override func titleRect(forBounds theRect: NSRect) -> NSRect {
        var newRect = super.drawingRect(forBounds: theRect)

        let textSize = attributedStringValue.size()

        let heightDelta = newRect.size.height - textSize.height
        if heightDelta > 0 {
            newRect.size.height = textSize.height
            let halfHeightDelta = CGFloat(heightDelta / 2)
            newRect.origin.y = halfHeightDelta - topTextPadding
        }

        newRect.origin.x += leftPadding
        newRect = NSRect(x: newRect.origin.x, y: newRect.origin.y, width: newRect.width - leftPadding * 2, height: newRect.height)

        return newRect
    }

    override func draw(withFrame cellFrame: NSRect, in controlView: NSView) {
        super.draw(withFrame: drawingRect(forBounds: cellFrame), in: controlView)
    }
}

protocol SparkButtonDelegate: AnyObject {
    func actionPerformed()
    func mouseEntered(button: SparkButton)
    func mouseExited(button: SparkButton)
    func mouseDown(button: SparkButton)
}

class SparkButton: NSButton {

    // MARK: IBInspectables
    @IBInspectable var isTwoState: Bool = false

    @IBInspectable var fontColor: NSColor!
    @IBInspectable var fontHoverColor: NSColor!
    @IBInspectable var fontOnHoverColor: NSColor!
    @IBInspectable var fontMouseDownColor: NSColor!
    @IBInspectable var fontDisabledColor: NSColor!
    @IBInspectable var fontOnColor: NSColor!
    @IBInspectable var fontOnMouseDownColor: NSColor!
    @IBInspectable var fontTabFocusedColor: NSColor!
    @IBInspectable var fontOnTabFocusedColor: NSColor!

    @IBInspectable var buttonColor: NSColor!
    @IBInspectable var buttonPressedBackgroundColor: NSColor!
    @IBInspectable var buttonHoverColor: NSColor!
    @IBInspectable var buttonDisabledColor: NSColor!

    @IBInspectable var buttonOnColor: NSColor!
    @IBInspectable var buttonOnPressedBackgroundColor: NSColor!
    @IBInspectable var buttonOnHoverColor: NSColor!

    @IBInspectable var isUsingCustomBorder: Bool = false
    @IBInspectable var borderHoverColor: NSColor!
    @IBInspectable var borderSelectedColor: NSColor!
    @IBInspectable var borderDisabledColor: NSColor!
    @IBInspectable var borderDisabledWidth: CGFloat = 0
    @IBInspectable var toggleStateOnClick: Bool = true
    @IBInspectable var isTabFocused: Bool = false

    @IBInspectable var customTooltip = "" {
        didSet {
            if customTooltip.isEmpty {
                applyTooltip()
            } else {
                toolTip = nil
            }
        }
    }
    @IBInspectable var customTooltipOn = "" {
        didSet {
            if customTooltipOn.isEmpty {
                applyTooltip()
            } else {
                toolTip = nil
            }
        }
    }
    private var toastPopover: NSPopover?
//    private var customTooltipsController: CallViewCustomTooltipsViewController?
    var shouldHigherCustomTooltipsWindowLevel = false
    var shouldExcludeTooltipsInShare = false
    var suppressCustomTooltip: Bool = false {
        didSet {
            hideTooltip()
        }
    }

    var preferredEdge: NSRectEdge?

    @IBInspectable var notifySuperMouseEnterExit: Bool = true
    @IBInspectable var shouldIgnoreTransparentTheme: Bool = true {
        didSet {
            setThemeColors()
        }
    }

    var representedObject: Any? // to store any required backing data that this button represents (the model data provided from CH

    private var trackingOptions: NSTrackingArea.Options = [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways, NSTrackingArea.Options.enabledDuringMouseDrag]

    // if any of these shouldRound*WhenRounding is false, the layer cornerRadius should be returned to 0 since that layer interferes with the custom
    // NSBezierPath that we draw
    @IBInspectable var shouldRoundTopRightWhenRounding = true {
        didSet {
            if !shouldRoundTopRightWhenRounding {
                layer?.cornerRadius = 0
            }
        }
    }
    @IBInspectable var shouldRoundTopLeftWhenRounding = true {
        didSet {
            if !shouldRoundTopLeftWhenRounding {
                layer?.cornerRadius = 0
            }
        }
    }
    @IBInspectable var shouldRoundBottomRightWhenRounding = true {
        didSet {
            if !shouldRoundBottomRightWhenRounding {
                layer?.cornerRadius = 0
            }
        }
    }
    @IBInspectable var shouldRoundBottomLeftWhenRounding = true {
        didSet {
            if !shouldRoundBottomLeftWhenRounding {
                layer?.cornerRadius = 0
            }
        }
    }
    @IBInspectable var hasLayerCornerRadius = true {
        didSet {
            if !hasLayerCornerRadius {
                layer?.cornerRadius = 0
            }
        }
    }

    @IBInspectable var borderColor: NSColor! {
        didSet {
            updateBorderColor(borderColor)
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            if !isUsingCustomBorder {
                layer?.borderWidth = borderWidth
                if borderColor != nil {
                    layer?.borderColor = borderColor.cgColor
                }
            }
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            // if custom rouding is specified, don't round the layer as it overlaps the bezier curve that gets created and hides some of the border
            if shouldRoundBottomLeftWhenRounding && shouldRoundTopLeftWhenRounding &&
                shouldRoundTopRightWhenRounding && shouldRoundBottomRightWhenRounding {

                layer?.cornerRadius = cornerRadius
            }
        }
    }

    @IBInspectable var useHandCursor: Bool = false {
        didSet {
            cursor = NSCursor.pointingHand
            trackingOptions = [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways, NSTrackingArea.Options.enabledDuringMouseDrag]
        }
    }

    @IBInspectable var horizontalPadding: CGFloat = 0

//    private var weakSparkButtonDelegates = [WeakWrapper]()

    // MARK: Public members
    var cursor: NSCursor?

    var mouseTrackingEnabled: Bool = true {
        didSet {
            updateTrackingAreas()
        }
    }
    var trackingArea: NSTrackingArea!
    var isMouseDown: Bool = false
    var widthForTooltip: CGFloat = 0.0
    var isMouseEntered: Bool = false {
        didSet {
            guard oldValue != isMouseEntered else { return }
            needsDisplay = true
            if isMouseEntered {
                let tooltips = getCustomTooltips()
                if !tooltips.isEmpty, !suppressCustomTooltip {
                    showTooltip(with: tooltips)
                }

//                for weakDelegate in weakSparkButtonDelegates {
//                    let sparkButtonDelegate =  weakDelegate.value as? SparkButtonDelegate
//                    sparkButtonDelegate?.mouseEntered(button: self)
//                }
            } else {
                hideTooltip()

//                for weakDelegate in weakSparkButtonDelegates {
//                    let sparkButtonDelegate =  weakDelegate.value as? SparkButtonDelegate
//                    sparkButtonDelegate?.mouseExited(button: self)
//                }
            }
        }
    }

    var tooltipOffOrDefault: String!
    var tooltipOn: String!
    var tooltipForDisabled: String?
    var isTooltipForDisabledSet: Bool = false

    var isOn: Bool = false {
        didSet {
            applyTooltip()
            needsDisplay = true
        }
    }

//    var buttonState: PresentButtonState = PresentButtonState.Off {
//        didSet {
//            switch buttonState {
//            case .On :
//                isEnabled = true
//                isOn = true
//            case .Off :
//                isEnabled = true
//                isOn = false
//            case .Disabled :
//                isEnabled = false
//            }
//        }
//    }
//
//    var buttonColorStates: ColorStates! {
//        didSet {
//            guard let colors = buttonColorStates else { return }
//            buttonColor = colors.normal
//            buttonHoverColor = colors.hover
//            buttonPressedBackgroundColor = colors.pressed
//            buttonDisabledColor = colors.disabled
//
//            buttonOnColor = colors.on
//            buttonOnHoverColor = colors.onHover
//
//            setNeedsDisplay()
//        }
//    }
//
//    var fontColorStates: ColorStates! {
//        didSet {
//            guard let colors = fontColorStates else { return }
//            fontColor = colors.normal
//            fontHoverColor = colors.hover
//            fontMouseDownColor = colors.pressed
//            fontDisabledColor = colors.disabled
//
//            if let cell = cell as? SparkButtonCell {
//                cell.disabledButtonTextColor = colors.disabled
//            }
//
//            fontOnColor = colors.on
//            fontOnHoverColor = colors.onHover
//
//            setNeedsDisplay()
//        }
//    }
//
//    var borderColorStates: ColorStates? {
//        didSet {
//            guard let colors = borderColorStates else { return }
//            borderColor = colors.normal
//            borderHoverColor = colors.hover
//            borderSelectedColor = colors.pressed
//            borderDisabledColor = colors.disabled
//
//            setNeedsDisplay()
//        }
//    }

    // MARK: Private members
    fileprivate var displayedFontColor: NSColor! {
        didSet {
            if let color = displayedFontColor {
                let attrString = NSMutableAttributedString.init(attributedString: attributedTitle)
                let titleRange = NSRange(location: 0, length: attributedTitle.length)
                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: titleRange)
                attributedTitle = attrString
            }
        }
    }

    // MARK: - Initialization
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }

    func setThemeColors() {
        if !isHidden {
            needsDisplay = true
        }
    }

    func addSparkButtonDelegate(delegate: SparkButtonDelegate) {
//        weakSparkButtonDelegates.append(WeakWrapper(value: delegate))
    }

    override func resetCursorRects() {
        super.resetCursorRects()

        if let cursor = cursor {
            addCursorRect(bounds, cursor: cursor)
        }
    }

    func initialise() {
        wantsLayer = true

        updateTrackingAreas()
        applyTooltip()
    }

    deinit {
        if let area = trackingArea {
            removeTrackingArea(area)
        }
    }

    override func updateTrackingAreas() {
        if let _ = trackingArea {
            removeTrackingArea(trackingArea!)
        }

        if mouseTrackingEnabled {
            trackingArea = NSTrackingArea(rect: bounds,
                options: trackingOptions,
                owner: self,
                userInfo: nil)

            addTrackingArea(trackingArea!)

            if let mouseLocation = window?.mouseLocationOutsideOfEventStream {
                let pt = convert(mouseLocation, from: nil)
                if bounds.contains(pt) {
                    isMouseEntered = true
                } else {
                    isMouseEntered = false
                }
            }
        }

        super.updateTrackingAreas()
    }

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        updateTrackingAreas()
    }

    override func draw(_ dirtyRect: NSRect) {
        // font color has to be set before we draw the parent
        if !isEnabled {
//            displayedFontColor = fontDisabledColor ?? NSColor.getDisabledButtonColor()
        } else if isTabFocused {
            if isOn {
                displayedFontColor = fontOnTabFocusedColor ?? fontOnColor
            } else {
                displayedFontColor = fontTabFocusedColor ?? fontHoverColor
            }
        } else if isMouseDown {

            if isOn {
                if isMouseEntered {
                    displayedFontColor = fontOnMouseDownColor ?? fontMouseDownColor ?? fontOnHoverColor
                } else {
                    displayedFontColor = fontOnColor ?? fontColor
                }
            } else {
                if isMouseEntered {
                    displayedFontColor = fontMouseDownColor ?? fontHoverColor
                } else {
                    displayedFontColor = fontColor
                }
            }
        } else if isOn {
            if isMouseEntered {
                displayedFontColor = fontOnHoverColor ?? fontOnColor
            } else {
                displayedFontColor = fontOnColor ?? fontColor
            }
        } else {
            if isMouseEntered {
                displayedFontColor = fontHoverColor ?? fontColor
            } else {
                displayedFontColor = fontColor
            }
        }

        if !shouldRoundTopLeftWhenRounding || !shouldRoundTopRightWhenRounding || !shouldRoundBottomLeftWhenRounding || !shouldRoundBottomRightWhenRounding {
//            let maskPath = getBezierPathWithSomeRoundedCorners()
            let shape = CAShapeLayer()
//            shape.path = maskPath.cgPath
            layer?.mask = shape
        }

        super.draw(dirtyRect)

        if isEnabled {

            if !isMouseDown {

                if isMouseEntered && buttonHoverColor != nil {

                    if !isOn {
                        updateBackgroundColor(buttonHoverColor)
                    } else {
                        updateBackgroundColor(buttonOnHoverColor ?? buttonHoverColor)
                    }
                    updateBorderColor(borderHoverColor)
                } else {

                    if !isOn {
                        updateBackgroundColor(buttonColor)
                        updateBorderColor(borderColor)
                    } else {
                        updateBackgroundColor(buttonOnColor ?? buttonColor)
                        updateBorderColor(borderSelectedColor ?? borderColor)
                    }
                }
            } else {

                if isMouseEntered && buttonPressedBackgroundColor != nil {
                    updateBackgroundColor(buttonPressedBackgroundColor)
                } else if isMouseEntered && buttonHoverColor != nil {
                    updateBackgroundColor(buttonHoverColor)
                } else {
                    updateBackgroundColor(buttonColor)
                }
            }
        } else {

            if buttonDisabledColor != nil {
                updateBackgroundColor(buttonDisabledColor)
            }

            if borderDisabledColor != nil {
                updateBorderColor(borderDisabledColor)
            }
        }
    }

    override func mouseDown(with theEvent: NSEvent) {
        isMouseDown = true
        needsDisplay = true
        hideTooltip()

//        for weakDelegate in weakSparkButtonDelegates {
//            let sparkButtonDelegate =  weakDelegate.value as? SparkButtonDelegate
//            sparkButtonDelegate?.mouseDown(button: self)
//        }
    }

    private func performAction() {
        if action != nil && target != nil {
            if toggleStateOnClick {
                toggleOnState()
            }

            sendAction(action, to: target)

//            for weakDelegate in weakSparkButtonDelegates {
//                let sparkButtonDelegate =  weakDelegate.value as? SparkButtonDelegate
//                sparkButtonDelegate?.actionPerformed()
//            }

        }
    }

    override func performClick(_ sender: Any?) {
        performAction()
    }

    override func mouseUp(with theEvent: NSEvent) {
        isMouseDown = false

        if isEnabled {
            if isMouseEntered {
                if action != nil && target != nil {

                    performAction()

                    // After sending the action to the button the button could have moved
                    // (as in the case of expanding a split view). In this case the mouse
                    // exit event is not being triggered so we do a hit test to make sure
                    // that the mouse is still within the bounds of the button
                    if let superView = superview {
                        let pt = superView.convert(theEvent.locationInWindow, from: nil)
                        if !NSMouseInRect(pt, frame, false) {
                            isMouseEntered = false
                            needsDisplay = true
                        }
                    }
                } else {
//                    SPARK_LOG_ERROR("Either target or action is nil")
                }
            } else {
                needsDisplay = true
            }
        }
    }

    override func mouseEntered(with theEvent: NSEvent) {
        if notifySuperMouseEnterExit {
            super.mouseEntered(with: theEvent)
        }
        isMouseEntered = true
    }

    override func mouseExited(with theEvent: NSEvent) {
        if notifySuperMouseEnterExit {
            super.mouseExited(with: theEvent)
        }
        isMouseEntered = false
    }

    override func mouseDragged(with event: NSEvent) {
    }

    // MARK: Public methods
    func setTargetAction(_ target: AnyObject?, action: Selector) {
        self.target = target
        self.action = action
    }

    func setTitleKeepingStyle(_ title: String) {
//        let theColor: NSColor
        if fontColor == nil {
//            theColor = ThemeManager.backgroundColor()
        } else {
//            theColor = fontColor
        }

//        setTitle(title, withColor: theColor)
    }

    func toggleOnState() {

        needsDisplay = true

        if isTwoState {
            isOn = !isOn
        }
    }

    func applyTooltip() {
        guard customTooltip.isEmpty else {
            return
        }

        if isOn {
            if let tooltip = isOn ? tooltipOn : tooltipOffOrDefault {
                if isEnabled {
                    self.toolTip = tooltip
                } else {
                    if isTooltipForDisabledSet {
                        self.toolTip = self.tooltipForDisabled
                    } else {
                        self.toolTip = tooltip
                    }
                }
            }
        } else if let tooltip = tooltipOffOrDefault {
            if isEnabled {
                self.toolTip = tooltip
            } else {
                if isTooltipForDisabledSet {
                    self.toolTip = tooltipForDisabled
                } else {
                    self.toolTip = tooltip
                }
            }
        }
    }

    func setTooltipValues(_ offOrDefault: String?, on: String?) {
        tooltipOffOrDefault = offOrDefault
        tooltipOn = on
        applyTooltip()
    }

    func setTooltipValuesForDisabled(_ tooltipForEnable: String?) {
        // Set this set of tooltip doesn't support refresh
        tooltipForDisabled = tooltipForEnable
        isTooltipForDisabledSet = true
    }

    func updateButtonEnabled(bEnabled: Bool) {
        if isEnabled != bEnabled {
            isEnabled = bEnabled

        }
    }

    func updateButtonIsOn(bIsOn: Bool) {
        if isOn != bIsOn {
            isOn = bIsOn
        }
    }

    // MARK: Internal methods
    // for use with subclasses as well if needed in the draw(_:) method
    // Method will round separate corners given from the member variables (like shouldRoundTopRightWhenRounding)
    // potentially only some should be rounded
    internal func getBezierPathWithSomeRoundedCorners() -> NSBezierPath {
        // manually draw bezier path with only the specified corners rounded
        let clipPath = NSBezierPath()

        // Start drawing from upper left corner
        let topLeftCorner = NSPoint(x: bounds.minX, y: bounds.maxY)
        if shouldRoundTopLeftWhenRounding {
            clipPath.move(to: NSPoint(x: bounds.minX + cornerRadius, y: bounds.maxY))
        } else {
            clipPath.move(to: topLeftCorner)
        }

        // draw top right corner
        let topRightCorner = NSPoint(x: bounds.maxX, y: bounds.maxY)
        if shouldRoundTopRightWhenRounding {
            clipPath.line(to: NSPoint(x: bounds.maxX - cornerRadius, y: bounds.maxY))
            clipPath.appendArc(withCenter: NSPoint(x: bounds.maxX - cornerRadius, y: bounds.maxY - cornerRadius), radius: cornerRadius, startAngle: 90, endAngle: 0, clockwise: true)
        } else {
            clipPath.line(to: topRightCorner)
        }

        // draw bottom right corner
        let bottomRightCorner = NSPoint(x: bounds.maxX, y: bounds.minY)
        if shouldRoundBottomRightWhenRounding {
            clipPath.line(to: NSPoint(x: bounds.maxX, y: bounds.minY + cornerRadius))
            clipPath.appendArc(withCenter: NSPoint(x: bounds.maxX - cornerRadius, y: bounds.minY + cornerRadius), radius: cornerRadius, startAngle: 360, endAngle: 270, clockwise: true)
        } else {
            clipPath.line(to: bottomRightCorner)
        }

        // draw bottom left corner
        let bottomLeftCorner = NSPoint(x: bounds.minX, y: bounds.minY)
        if shouldRoundBottomLeftWhenRounding {
            clipPath.line(to: NSPoint(x: bounds.minX + cornerRadius, y: bounds.minY))
            clipPath.appendArc(withCenter: NSPoint(x: bounds.minX + cornerRadius, y: bounds.minY + cornerRadius), radius: cornerRadius, startAngle: 270, endAngle: 180, clockwise: true)
        } else {
            clipPath.line(to: bottomLeftCorner)
        }

        // connect back to top left corner
        if shouldRoundTopLeftWhenRounding {
            clipPath.line(to: NSPoint(x: bounds.minX, y: bounds.maxY - cornerRadius))
            clipPath.appendArc(withCenter: NSPoint(x: bounds.minX + cornerRadius, y: bounds.maxY - cornerRadius), radius: cornerRadius, startAngle: 180, endAngle: 90, clockwise: true)
        } else {
            clipPath.line(to: topLeftCorner)
        }

        return clipPath
    }

    func updateFont(theFont: NSFont) {
        font = theFont
        setTitleKeepingStyle(attributedTitle.string)
    }

    // MARK: Private methods
    private func getCustomTooltips() -> String {
        if isOn && !customTooltipOn.isEmpty {
            return customTooltipOn
        }
        return customTooltip
    }

    fileprivate func setTitle(_ title: String, withColor color: NSColor) {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        style.lineBreakMode = lineBreakMode

        let attsDictionary: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color,
                                                           NSAttributedString.Key.paragraphStyle: style,
                                                           NSAttributedString.Key.font: font!]

        let attrString = NSMutableAttributedString.init(string: title, attributes: attsDictionary)
        attributedTitle = attrString
    }

    fileprivate func updateBackgroundColor(_ color: NSColor?) {
        layer?.backgroundColor = color?.cgColor ?? nil
    }

    fileprivate func updateBorderColor(_ color: NSColor?) {
        if let color = color, !isUsingCustomBorder {
            layer?.borderColor = color.cgColor
        }
    }

    override func drawFocusRingMask() {

        if cornerRadius == 0 {
            bounds.fill()
        } else if shouldRoundTopLeftWhenRounding && shouldRoundTopRightWhenRounding &&
                shouldRoundBottomLeftWhenRounding && shouldRoundBottomRightWhenRounding {

            let clipPath = NSBezierPath(roundedRect: bounds, xRadius: cornerRadius, yRadius: cornerRadius)
            clipPath.fill()
        } else {
            let clipPath = getBezierPathWithSomeRoundedCorners()
            clipPath.fill()
        }
    }

    override var focusRingMaskBounds: NSRect {
        return bounds
    }

    override var intrinsicContentSize: NSSize {
        var size = super.intrinsicContentSize
        size.width += horizontalPadding
        return size
    }

    func hideTooltip() {
        if let toastPopover = toastPopover, toastPopover.isShown {
            toastPopover.close()
        }
    }

    func showTooltip(with message: String) {
//        hideTooltip()
//        customTooltipsController = CallViewCustomTooltipsViewController(tooltip: message)
//        if widthForTooltip > 0 {
//            customTooltipsController?.setFixedWidth(width: widthForTooltip)
//        }
//        _  = customTooltipsController?.view
//        if let customTooltipsController = customTooltipsController {
//            toastPopover = SparkPopoverBuilder().createInCallTooltipPopover(contentViewController: customTooltipsController, sender: self, bounds: bounds, preferredEdge: preferredEdge ?? .minY)
//            if let window = toastPopover?.contentViewController?.view.window {
//                if shouldExcludeTooltipsInShare {
//                    NotificationCenter.default.post(name: Notification.Name(rawValue: OnShareShouldExcludeWindow), object: self, userInfo: ["windowNumber": window.windowNumber])
//                }
//                if shouldHigherCustomTooltipsWindowLevel {
//                    window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.popUpMenuWindow)) + 2)
//                }
//            }
//        }
    }
}
