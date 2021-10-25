//
//  UTBaseButton.swift
//  UIToolkit
//
//  Created by James Nestor on 23/09/2021.
//

import Cocoa

open class UTBaseButton: NSButton, CALayerDelegate, ThemeableProtocol {
    
    open weak var buttonDelegate: UTButtonDelegate?
    
    enum UTType {
        case round
        case pill
        case square
        case rounded
    }
    
    var oriantation: NSUserInterfaceLayoutOrientation = .horizontal
    
    //override to set color tokens
    internal func setTokensFromStyle() {}
    
    var startAtLeadingPadding = false
    
    struct ElementSize {
         var imageWidth:CGFloat = 14
         var elementPadding:CGFloat = 8
         var arrowIconSize:CGFloat = 16
         var indicator:CGFloat = 12
         var minIntrinsicWidth:CGFloat = 24
    }
    
    var elementSize: ElementSize = ElementSize() {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    public var fontIcon : MomentumRebrandIconType! {
        didSet {
            addUIElement(element: .FontIcon(fontIcon))
            setupTextAndFonts()
        }
    }
    


    var trailingPadding:CGFloat {
        return 10
    }
    
    var leadingPadding:CGFloat {
        return 10
    }
           
    public var representedObject: Any?
    
    public var buttonHeight: ButtonHeight = .medium {
        didSet{
            onButtonHeightUpdated()
        }
    }
    
    public func addUTToolTip(toolTip:UTTooltipType) {
        
        switch toolTip {
        case .plain(let toolTipString):
            super.toolTip = toolTipString
        case .rich(_):
            super.toolTip = ""
        }
        tooltipType = toolTip
    }
    
    func updateLabelFontSize() {
        
        switch self.buttonHeight {
        case .extralarge, .large, .medium:
            self.labelFont = .subheaderPrimary
        case .small:
            self.labelFont = .subheaderSecondary
        case .extrasmall:
            self.labelFont = .labelCompact
        case .unknown:
            assert(false, "no size known font size")
        }
    }
    
    //subclass should override this method to change icon size if required.
    func  updateIconSize() {
        
    }
    
    public var heightFloat: CGFloat {
        return toCGFloat(height: buttonHeight)
    }
    
    public override var toolTip: String? {
        didSet{
           // assert(false, "Do not call this property directly, instead call addToolTip()")
            if let toolTip  = toolTip {
                addUTToolTip(toolTip: .plain(toolTip))
            }
        }
    }
    public var shouldExcludeTooltipsInShare: Bool = false
    public var shouldHigherCustomTooltipsWindowLevel: Bool = false
    
    internal var labelFont: UTFontType = .labelCompact
    
    //MARK: internal api
    internal var buttonType: UTType = .pill

    internal var preventFirstResponder = false
    internal var passThroughMouseEvent = false
    internal var fontIconSize: CGFloat = 18.0
    
    internal var backgroundTokenName:String = ""
    internal var fontTokenName:String = ""
    internal var borderTokenName:String = "" {
        didSet{
            updateBorderWidth()
            animateColor(state == .on)
        }
    }
    internal func updateBorderWidth() {
        if borderTokenName.isEmpty {
            layer?.borderWidth = 0
        }
        else {
            layer?.borderWidth = 1
        }
    }
    public var iconTokenName: String?
    
    private var activeBorderColor: CCColor = CCColor.white
    private var containerLayer = CALayer()
    private var tooltipType: UTTooltipType = .plain("")
    private var arrowShouldChangeIndependently: Bool = false
    private var independentArrowState: Bool = false
    
    private var trackingArea: NSTrackingArea?
    
    func toCGFloat(height: ButtonHeight) -> CGFloat {
        fatalError("This method must be overridden")
    }
    
    var backgroundColors:UTColorStates{
        return UIToolkit.shared.getThemeManager().getColors(tokenName: backgroundTokenName)
    }
    
    var textColors:UTColorStates{
        return UIToolkit.shared.getThemeManager().getColors(tokenName: fontTokenName)
    }
    
    var borderColors:UTColorStates{
        return UIToolkit.shared.getThemeManager().getColors(tokenName: borderTokenName)
    }
    
    var iconColors: UTColorStates {
        if let iconTokenName = iconTokenName {
            return UIToolkit.shared.getThemeManager().getColors(tokenName: iconTokenName)
        }
        return textColors
    }
    
    var textColor:CCColor {
        return textColors.getColorForState(isEnabled: isEnabled, isMouseDown: mouseDown, isHovered: isHovered, isOn: state == .on)
    }
    
    var backgroundColor:CCColor {
        return backgroundColors.getColorForState(isEnabled: isEnabled, isMouseDown: mouseDown, isHovered: isHovered, isOn: state == .on)
    }
    
    var borderColor:CCColor {
        return borderColors.getColorForState(isEnabled: isEnabled, isMouseDown: mouseDown, isHovered: isHovered, isOn: state == .on)
    }
    
    var iconColor: CCColor {
        return iconColors.getColorForState(isEnabled: isEnabled, isMouseDown: mouseDown, isHovered: isHovered, isOn: state == .on)
    }
    
    internal var mouseDown = Bool()
    @IBInspectable public var momentary: Bool = true {
        didSet {
            animateColor(state == .on)
        }
    }

    
    //MARK: Priavte API
    private var onAnimationDuration: Double = 0
    private var offAnimationDuration: Double = 0.1
    private var isHovered = false
    internal var buttonElements:[(ButtonElement,Any)] = []
    private var popover:UTPopover!
    
    var activeIconColor: NSColor = NSColor.black {
        didSet {
            animateColor(state == .on)
        }
    }

    override open var title: String {
        didSet {
            if title.isEmpty {
                removeUIElement(element: .Label(title))
            }
            else{
                addUIElement(element: .Label(title))
            }
            
            setupTextAndFonts()
        }
    }
    
    override open var font: NSFont? {
        didSet {
            setupTextAndFonts()
        }
    }
    override open var frame: NSRect {
        didSet {
            setupTextAndFonts()
            positionTitleAndImage()
            updateCorners()
        }
    }

    override open var isEnabled: Bool {
        didSet {
            setThemeColors()
        }
    }
    
    override open var acceptsFirstResponder: Bool {
        return super.acceptsFirstResponder && !preventFirstResponder
    }
    
    open override var canBecomeKeyView: Bool {
        return super.acceptsFirstResponder && !preventFirstResponder && isEnabled && !isHidden
    }
    
    // MARK: Setup & Initialization
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        super.title = ""
        initialise()
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
        super.title = ""
        initialise()
    }
    
    deinit {
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }
    }
    
    internal func initialise() {
        wantsLayer = true
        layer?.masksToBounds = true
        containerLayer.masksToBounds = false
        updateCorners()
        layer?.borderWidth = 0
        layer?.delegate = self
        self.isBordered = false
        //self.fontIconLayer.borderColor = .black
        self.focusRingType = .default
        
        setThemeColors()
                
        containerLayer.shadowOffset = NSSize.zero
        containerLayer.shadowColor = NSColor.clear.cgColor
        containerLayer.frame = NSMakeRect(0, 0, bounds.width, bounds.height)
    
        layer?.addSublayer(containerLayer)
        setupTextAndFonts()
        animateColor(state == .on)
        updateTrackingAreas()
    }
    
    public func updateCorners() {
        switch oriantation {
        case .horizontal:
            if buttonType == .square {
                layer?.cornerRadius = 0
            }
            else if buttonType == .rounded {
                layer?.cornerRadius =  4
            }
            else {
                layer?.cornerRadius =  self.heightFloat/2
            }
        case .vertical:
            layer?.cornerRadius = self.bounds.width / 2
        @unknown default:
            layer?.cornerRadius = 0
        }
    }
    
    
    internal func roundLHSCorner() {
        if #available(OSX 10.13, *) {
            layer?.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        }
    }
    
    internal func roundTopCorner() {
        if #available(OSX 10.13, *) {
            layer?.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    
    internal func roundRHSCorner() {
        if #available(OSX 10.13, *) {
           layer?.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
    
    internal func roundBottomCorner() {
        if #available(OSX 10.13, *) {
            layer?.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }
    }

    internal var attributes:[NSAttributedString.Key:Any]{
        let theFont = labelFont.font()
        
        return [NSAttributedString.Key.font : theFont,
                NSAttributedString.Key.foregroundColor : textColor]
    }
    
    
    //base classes should override to get different order
    internal func sortIndex(buttonElement: ButtonElement) -> Int {
        switch buttonElement {
        case .UnreadPill:
            return 0
        case .Badge:
            return 1
        case .Image:
            return 2
        case .FontIcon(_):
            return 3
        case .Label:
            return 4
        case .ArrowIcon:
            return 5
        }
    }
    
    internal func addUIElement(element: ButtonElement) {
            
        switch element {
        case .ArrowIcon, .FontIcon, .Label(_):
            let textLayer = CATextLayer()
            configLayer(textLayer)
            addOrUpdate(buttonElement: element, backingObject: textLayer)
        case .Badge(let count):
            let badge = UTBadge()
            badge.count = count
            self.addSubview(badge)
            addOrUpdate(buttonElement: element, backingObject: badge)
        case .Image(let image):
            let shapeLayer = setupImage(image)
            addOrUpdate(buttonElement: element, backingObject: shapeLayer)
        case .UnreadPill:
            let indictor = UTIndicatorBadge()
            indictor.badgeType = .unread
            self.addSubview(indictor)
            addOrUpdate(buttonElement: element, backingObject: indictor)
        }
    }
        
    internal func removeUIElement(element: ButtonElement) {
        
        if let match = buttonElements.first(where: {element == $0.0}) {
            
            if let sublayer = match.1 as? CALayer {
                self.containerLayer.sublayers?.removeAll(where: {$0 == sublayer})
                buttonElements.removeAll(where: {$0.0 == match.0})
            }
        }
    }
    
    internal func containsElement(element: ButtonElement) -> Bool {
        return buttonElements.contains(where: { $0.0 == element })
    }
    
    internal func updateBadgeCount(count:Int){
        if let badge = self.subviews.first(where: { $0 is UTBadge } ) as? UTBadge {
            badge.count = count
        }
        else {
            NSLog("No badge to update")
        }
    }
    
    open override func drawFocusRingMask() {
        
        var clipPath:NSBezierPath?
        switch buttonType {
        case .round:
            clipPath = NSBezierPath(ovalIn: self.bounds.getAdjustedRect(adjust: 1.0))
        case .pill, .rounded:
            if let radius = self.layer?.cornerRadius {
                clipPath = NSBezierPath(roundedRect: self.bounds, xRadius: radius, yRadius: radius)
            }
        case .square:
            clipPath = NSBezierPath(rect: bounds)
        }
        
        clipPath?.fill()
    }
    
    public override var intrinsicContentSize: NSSize{
    
        switch buttonType {
        case .pill, .square, .rounded:
            let widthFromElements = calulateWidthFromElements()
            var width = widthFromElements + leadingPadding + trailingPadding
            width = width < elementSize.minIntrinsicWidth ? elementSize.minIntrinsicWidth : width
            return NSMakeSize(width, self.heightFloat)
        case .round:
            return NSMakeSize( self.heightFloat, self.heightFloat)
        }
    }
    
    internal func setupTextAndFonts() {
        guard let font = font else {
            return
        }
        
        for elementPair in buttonElements {
            
            switch elementPair.0 {
            case .ArrowIcon:
                if let arrowLayer = elementPair.1 as? CATextLayer {
                    var arrowState = state == .on
                    if arrowShouldChangeIndependently {
                        arrowState = independentArrowState
                    }
                    let fontIconName = arrowState ? MomentumRebrandIconType.arrowUpFilled.ligature : MomentumRebrandIconType.arrowDownFilled.ligature
                    let fontIconAttString = NSMutableAttributedString.getIcon(fontName: fontIconName, size: elementSize.arrowIconSize, color: textColor)
                    arrowLayer.string = fontIconAttString
                    arrowLayer.fontSize = elementSize.arrowIconSize
                }
                case .FontIcon(let iconFont):
                    if let textLayer = elementPair.1 as? CATextLayer {
                        let fontIconAttString = NSMutableAttributedString.getIcon(fontName: iconFont.ligature, size: fontIconSize, color: iconColor)
                        textLayer.string = fontIconAttString
                        textLayer.fontSize = font.pointSize
                        textLayer.alignmentMode = .center
                    }
                case .Label(let label):
                    if let titleLayer =  elementPair.1 as? CATextLayer {
                        let titleFont = labelFont.font()
                        
                        titleLayer.font = titleFont
                        titleLayer.fontSize = titleFont.pointSize
                        titleLayer.truncationMode = .middle
                        titleLayer.foregroundColor = textColor.cgColor
                        titleLayer.string = label
                    }
                case .UnreadPill, .Image(_), .Badge(_) : break
            }
        }
    
        positionTitleAndImage()
    }
    
    
    func positionTitleAndImage() {

        var currentPositionOnXAxis = leadingPadding
        let widthOfAllElements = calulateWidthFromElements()
                
        if !startAtLeadingPadding {
            if buttonType == .pill || buttonType == .rounded {
                currentPositionOnXAxis = max(leadingPadding, round((bounds.width - widthOfAllElements)/2))
            }
            else {
                currentPositionOnXAxis = round((bounds.width - widthOfAllElements)/2)
            }
        }

        let sortedButtonElements = buttonElements.sorted(by: { sortIndex(buttonElement: $0.0) < sortIndex(buttonElement: $1.0) } )
     
        for (index,element) in sortedButtonElements.enumerated() {
        
            let thePadding:CGFloat =  index == 0 ? 0 : elementSize.elementPadding
            var elementRect = NSMakeRect(0, 0, 0, 0)
            switch element.0 {
            case .FontIcon(let icon):
                if let shapeLayer = element.1 as? CALayer {
                    let iconWidth = calculateFontIconSize(icon: icon).width
                    elementRect = NSMakeRect(0, 0, iconWidth, iconWidth)
                    elementRect.origin.y = round((bounds.height - elementRect.height)/2)
                    elementRect.origin.x = thePadding + currentPositionOnXAxis
                    shapeLayer.frame = elementRect
                }
    
            case .ArrowIcon:
                if let shapeLayer = element.1 as? CATextLayer {
                    elementRect = NSMakeRect(0, 0, 16, 16)
                    elementRect.origin.y = round((bounds.height - elementRect.height)/2)
                    elementRect.origin.x = thePadding + currentPositionOnXAxis - 2
                    shapeLayer.frame = elementRect
                }
            case .Badge(_), .UnreadPill:
                if let view = element.1 as? NSView {
                    elementRect = NSRect(x: 0, y: 0, width: view.intrinsicContentSize.width, height: view.intrinsicContentSize.height)
                    elementRect.origin.y = round((bounds.height - elementRect.height)/2)
                    elementRect.origin.x = currentPositionOnXAxis + thePadding
                    view.frame = elementRect
                }
            case .Image(_):
                if let imageLayer = element.1 as? CALayer {
                    elementRect = imageLayer.frame
                    elementRect.origin.y = round((bounds.height - elementRect.height)/2)
                    elementRect.origin.x = currentPositionOnXAxis + thePadding
                    imageLayer.frame = elementRect
                }
            
            case .Label(let label):
                if let titleLayer = element.1 as? CALayer {
                    let titleSize = calculateLabelSize(title: label)
                    let roundingBuffer:CGFloat = 2
                    
                    var width = titleSize.width + roundingBuffer
                    let widthOfAllElementsAndPadding = widthOfAllElements + trailingPadding + leadingPadding
                    if widthOfAllElementsAndPadding > self.bounds.width + roundingBuffer {
                        let excessWidth = widthOfAllElements - self.bounds.width
                        width = max(0,width - (excessWidth + trailingPadding + leadingPadding))
                    }
                    
                    elementRect = NSMakeRect(0, 0, round(width), round(titleSize.height))
                    elementRect.origin.y = round((bounds.height - elementRect.height)/2)
                    elementRect.origin.x = currentPositionOnXAxis + thePadding
                    titleLayer.frame = elementRect
                }
            }
            
            //move the starting pos forward for the next element.
            currentPositionOnXAxis = round(elementRect.origin.x  + elementRect.width)
        }
    }
    
    
    internal func setupImage(_ image: NSImage) -> CALayer  {
        let layerImage = image.cgImage
        let layer = CALayer()
        layer.frame = image.alignmentRect
        layer.contents = layerImage
        configLayer(layer)
        return layer;
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        updateCorners()
    }
    
    open override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }
        
        trackingArea = NSTrackingArea(rect: NSZeroRect,
                                      options: [NSTrackingArea.Options.inVisibleRect,
                                                NSTrackingArea.Options.activeAlways,
                                                NSTrackingArea.Options.mouseEnteredAndExited,
                                                NSTrackingArea.Options.enabledDuringMouseDrag],
                                      owner: self,
                                      userInfo: nil)
        
        if let trackingArea = trackingArea {
            if !self.trackingAreas.contains(trackingArea){
                self.addTrackingArea(trackingArea)
            }
        }
        
        //When tracking area updates check if the mouse enter
        //state matches the is hover and update if it doesn't
        //When scrolling in tables this sometimes will not match
        if isMouseInVisibleRect && !isHovered {
            updateForMouseEntered()
        }
        else if !isMouseInVisibleRect && isHovered {
            updateForMouseExited()
        }
    }
    
    // MARK: Animations
    
    internal func removeAnimations() {
        layer?.removeAllAnimations()
        if layer?.sublayers != nil {
            for subLayer in (layer?.sublayers)! {
                subLayer.removeAllAnimations()
            }
        }
    }
    
    public func animateColor(_ isOn: Bool) {
        removeAnimations()
        let duration = isOn ? onAnimationDuration : offAnimationDuration
        
        let bgColor:NSColor = backgroundColor
        let titleColor = textColor
        
        layer?.animate(color: bgColor.cgColor, keyPath: "backgroundColor", duration: duration)
        layer?.animate(color: borderColor.cgColor, keyPath: "borderColor", duration: duration)

        for element in buttonElements {
            if case .Label(_) = element.0 {
                if let titleLayer = element.1 as? CATextLayer {
                    titleLayer.foregroundColor = titleColor.cgColor
                }
            }
        }
    }
    
    // MARK: Interaction
    public func setOn(_ isOn: Bool) {
        state = isOn ? NSControl.StateValue.on : NSControl.StateValue.off
        setThemeColors()
        animateColor(state == .on)
        setupTextAndFonts()
    }
    
    public func setArrowState(_ isOn: Bool) {
        arrowShouldChangeIndependently = true
        independentArrowState = isOn
        setupTextAndFonts()
    }
        
    override open func hitTest(_ point: NSPoint) -> NSView? {
        return passThroughMouseEvent ? nil : super.hitTest(point)
    }
    
    override open func mouseDown(with event: NSEvent) {
        if isEnabled {
            mouseDown = true
            
            animateColor(state == .on)
            setupTextAndFonts()
            popover?.close()
        }
    }
    
    override open func mouseEntered(with event: NSEvent) {
        updateForMouseEntered()
    }
    
    override open func mouseExited(with event: NSEvent) {
        updateForMouseExited()
    }
    
    override open func mouseUp(with event: NSEvent) {
        if mouseDown {
            mouseDown = false
          
            if isHovered {
                if !momentary {
                    state = state == .on ? .off : .on
                }
                
                _ = target?.perform(action, with: self)
            }
            
            //Wait until after actioned performed as
            //The state of the button might be updated
            animateColor(state == .on)
            setupTextAndFonts()
        }
    }
    
    private func updateForMouseEntered() {
        isHovered = true
        
        animateColor(state == .on)
        setupTextAndFonts()
        
        if case .rich(let details) = tooltipType, details.attTooltipString.length > 0 {
            popover?.close()
            
            let toolTipVC = RichToolTipViewController(tooltip:details.attTooltipString, size:details.size)
            popover = UTPopover(contentViewController: toolTipVC, sender: self, bounds: self.bounds,  preferredEdge: details.preferredEdge, behavior: .semitransient, style: .toolTip)
            if let window = popover?.contentViewController?.view.window {
                if shouldExcludeTooltipsInShare {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "OnShareShouldExcludeWindow"), object: self, userInfo: ["windowNumber": window.windowNumber])
                }
                if shouldHigherCustomTooltipsWindowLevel {
                    window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.popUpMenuWindow)) + 2)
                }
            }
        }
    }
    
    private func updateForMouseExited() {
        isHovered = false
        popover?.close()
        popover = nil
        animateColor(state == .on)
        setupTextAndFonts()
    }
    
    // MARK: Drawing
    override open func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        if let scale = window?.backingScaleFactor {
            layer?.contentsScale = scale
            for item in buttonElements {
                if let layer = item.1 as? CALayer  {
                    layer.contentsScale = scale
                }
            }
        }
    }
    

    override open func draw(_ dirtyRect: NSRect) {
        
    }
    
    override open func layout() {
        super.layout()
        positionTitleAndImage()
    }
    
    override open func updateLayer() {
        super.updateLayer()
    }
    
    private func addOrUpdate(buttonElement: ButtonElement, backingObject: Any) {
        
        var replaceIndex = -1
        for (index,e) in buttonElements.enumerated() {
            if buttonElement == e.0 {
                replaceIndex = index
            }
        }

        let entry = (buttonElement,backingObject)
        if replaceIndex > -1 {
            //we have new value for the backing store, save a new value but keep the underlying backing elememnt (usally for the updated label case)
            let oldEntry = buttonElements[replaceIndex]
            let entry = (buttonElement,oldEntry.1)
            buttonElements[replaceIndex] = entry
        } else {
            buttonElements.append(entry)
        }
    }
    
    private func configLayer(_ layer: CALayer) {

        layer.delegate = self
        if let scale = window?.backingScaleFactor {
            layer.contentsScale = scale
        }
        //useful for debugging
        //layer.borderWidth = 1
        layer.masksToBounds = true
        containerLayer.addSublayer(layer)
    }
    
    private func calculateFontIconSize(icon: MomentumRebrandIconType) -> CGSize {
        let icon = NSMutableAttributedString.getIcon(fontName: icon.ligature, size: fontIconSize, color: .white)
        return icon.size()
    }
    
    private func calculateLabelSize(title: String) -> CGSize{
        let titleAttrString = NSMutableAttributedString(string: title, attributes: attributes)
        return titleAttrString.size()
    }
    
    internal func calulateWidthFromElements() -> CGFloat {
        var width:CGFloat = 0
    
        for item in buttonElements {
            switch item.0 {
            case .ArrowIcon:
                width = width + elementSize.arrowIconSize
            case .Badge(_), .UnreadPill:
                if let view =  item.1 as? NSView {
                    width = width + view.frame.width
                }
            case .FontIcon(let icon):
                width = width + calculateFontIconSize(icon: icon).width
            case .Image(let image):
                width = width + image.size.width
            case .Label(let titleString):
                width  = width + calculateLabelSize(title: titleString).width
            }
        }
        
    
        let additionalPaddingCount = buttonElements.count - 1
        let currentPaddingWidth = additionalPaddingCount * Int(elementSize.elementPadding)
        
        if currentPaddingWidth > 0 {
            width = width + CGFloat(currentPaddingWidth)
        }
        
        return round(width)
    }
    
    internal func onButtonHeightUpdated() {
        updateCorners()
        updateIconSize()
        updateLabelFontSize()
        setupTextAndFonts()
        invalidateIntrinsicContentSize()
    }
    
    public func setThemeColors() {
        setTokensFromStyle()
        animateColor(self.state == .on)
        setupTextAndFonts()
    }
    
}

extension UTBaseButton: NSViewLayerContentScaleDelegate {
    public func layer(_ layer: CALayer, shouldInheritContentsScale newScale: CGFloat, from window: NSWindow) -> Bool { true }
}
