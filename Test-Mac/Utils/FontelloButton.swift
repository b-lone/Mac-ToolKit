//
//  SparkFontelloButton.swift
//  SparkMacDesktop
//
//  Created by James Nestor on 19/10/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

class CenteredTextLayer : CATextLayer{
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(layer: aDecoder)
    }
    
    func drawTextLayerInContext(_ ctx: CGContext, xOffset: CGFloat = 0, yOffset: CGFloat = 0){
        let height = self.bounds.size.height
        
        let fontSize = self.fontSize
        let yDiff = ((height - fontSize) / 2) - yOffset
        
        ctx.saveGState()
        ctx.translateBy(x: xOffset, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
    
    override func draw(in ctx: CGContext) {
        //Prevent the layer being drawn from the default context
        //instead we will use our own draw function that we control
        //from the drawRect of the button class
    }
}


protocol FontelloButtonDelegate: AnyObject {
    func mouseInFontelloButton(_ identifier:NSUserInterfaceItemIdentifier?)
    func mouseOutFontelloButton(_ identifier:NSUserInterfaceItemIdentifier?)
}

//enum IconSet {
//
//    case atlanticIconSet
//    case atlanticIllustrationSet
//    case momentumIconSet
//
//    var name: String {
//        switch self {
//        case .atlanticIconSet:
//            return Constants.atlanticFont
//        case .atlanticIllustrationSet:
//            return Constants.atlanticIllustrations
//        case .momentumIconSet:
//            return Constants.momentumIconFont
//        }
//    }
//}

protocol ThemeableProtocol: AnyObject {
    func setThemeColors()
}

/*
 Prefer this over FontelloButton if there is no mouse hover/click functionality. Especially for lists, this will draw more efficiently since
 buttons inherently are more expensive to draw than a our `CenteredTextLayer` class. This was especially an issue with the list of conversatiosn
 because more and more FontelloButtons were getting added which added to the layout time of each table cell view. This was one cause of sluggish scrolling
 */
class FontelloIcon: NSView, ThemeableProtocol {
    @IBInspectable var fontColor: NSColor = .black {
        didSet {
            updateTextLayer()
        }
    }
    @IBInspectable var iconName: String = " " {
        didSet {
            updateTextLayer()
        }
    }
    @IBInspectable var iconSize: CGFloat = 12 {
        didSet{
            textLayer.fontSize = iconSize
            updateTextLayer()
        }
    }
    
    @IBInspectable var xOffset: CGFloat = 0
    @IBInspectable var yOffset: CGFloat = 0

//    var iconSet: IconSet = .momentumIconSet

    private var textLayer: CenteredTextLayer!

    //MARK: Initialization
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.initialise()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialise()
    }

    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        textLayer.bounds = self.bounds
    }

    override func draw(_ dirtyRect: NSRect) {
        NSGraphicsContext.saveGraphicsState()

        let currentContext = NSGraphicsContext.current
        if let gc = currentContext{
            textLayer.drawTextLayerInContext(gc.cgContext, xOffset: xOffset, yOffset: yOffset)
        }

        NSGraphicsContext.restoreGraphicsState()
    }
    
    override var acceptsFirstResponder: Bool {
        return false
    }
    
    func initialise() {
        wantsLayer = true

        textLayer = CenteredTextLayer()
        textLayer.bounds = self.bounds
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
//        textLayer.contentsScale = NSScreen.mainScreenScaleFactor()

        layer?.addSublayer(textLayer)
    }
    
    func setThemeColors() {        
    }

    private func updateTextLayer() {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

//        let attrsDictionary: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.paragraphStyle: style,
//                                                                NSAttributedString.Key.font : NSFont(name: iconSet.name, size: textLayer.fontSize) as Any ]
        let attrsDictionary: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.paragraphStyle: style,
                                                               NSAttributedString.Key.font : NSFont.systemFont(ofSize: textLayer.fontSize) as Any ]

        let attrString = NSMutableAttributedString.init(string: iconName, attributes: attrsDictionary)
        let iconNameRange = getRangeForIcon(iconName)

        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: iconNameRange)
        textLayer.string = attrString
        needsDisplay = true
    }

    private func getRangeForIcon(_ iconName: String?) -> NSRange {
        let iconNameLength = iconName?.count ?? 1
        return NSMakeRange(0, iconNameLength)
    }
}

//class FontelloButton: SparkButton {
//    
//    //MARK: IBInspectables
//    @IBInspectable var xOffset: CGFloat = 0
//    @IBInspectable var yOffset: CGFloat = 0
//    @IBInspectable var iconName:String!
//    @IBInspectable var iconPressedName:String!
//    @IBInspectable var iconOnName:String!
//    @IBInspectable var passThroughMouseEvent:Bool = false
//
//    @IBInspectable var rotateDegrees:CGFloat = 180
//    @IBInspectable var animateRotation:Bool = true
//    @IBInspectable var animateBackgroundOpacity:Bool = false
//
//    @IBInspectable var isCircular: Bool = true
//
//    @IBInspectable var rotateWhenTurnedOn:Bool = false {
//        didSet{
//            if rotateWhenTurnedOn {
//                self.layer?.autoresizingMask = [CAAutoresizingMask.layerWidthSizable, CAAutoresizingMask.layerHeightSizable]
//            }
//        }
//    }
//
//    @IBInspectable var rotateAlways:Bool = false {
//        didSet{
//            if rotateAlways {
//                self.layer?.autoresizingMask = [CAAutoresizingMask.layerWidthSizable, CAAutoresizingMask.layerHeightSizable]
//            }
//        }
//    }
//
//    @IBInspectable var iconSize: CGFloat = 12{
//        didSet{
//            if let _ = textLayer{
//                textLayer.fontSize = iconSize
//            }
//        }
//    }
//
//    //MARK: Public members
//    var textLayer : CenteredTextLayer!
//    weak var fontelloButtonDelegate:FontelloButtonDelegate?
//    var iconSet: IconSet = .momentumIconSet
//
//    //MARK: Private members
//    fileprivate var opacityAnimationApplied:Bool = false
//
//    //MARK: Initialization
//    override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//        self.initialise()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        self.initialise()
//    }
//
//    deinit{
//        if let area = trackingArea {
//            removeTrackingArea(area)
//        }
//    }
//
//    override func mouseEntered(with theEvent: NSEvent) {
//        super.mouseEntered(with: theEvent)
//        fontelloButtonDelegate?.mouseInFontelloButton(self.identifier)
//    }
//
//    override func mouseExited(with theEvent: NSEvent) {
//        super.mouseExited(with: theEvent)
//        fontelloButtonDelegate?.mouseOutFontelloButton(self.identifier)
//    }
//
//    override func setFrameSize(_ newSize: NSSize) {
//        super.setFrameSize(newSize)
//        textLayer.bounds = self.bounds
//    }
//
//    override func initialise(){
//        super.initialise()
//
//        textLayer = CenteredTextLayer()
//        textLayer.bounds = self.bounds
//        textLayer.alignmentMode = CATextLayerAlignmentMode.center
//        textLayer.contentsScale = NSScreen.mainScreenScaleFactor()
//
//        self.title = ""
//        self.layer?.addSublayer(textLayer)
//        self.isUsingCustomBorder = true
//
//        self.applyTooltip()
//    }
//
//    override func draw(_ dirtyRect: NSRect) {
//
//        if self.animateBackgroundOpacity && !self.isHidden {
//            // do not start opacity animation if we are not visible
//            animateBackgroundColorOpacity()
//        }
//
//        var setBackground = false
//
//        if self.isEnabled {
//
//            if !isMouseDown {
//
//                if isMouseEntered  {
//
//                    if(!isOn){
//                        setBackground = setBackgroundColorFill(buttonHoverColor)
//                        setTextLayerFontColor(fontHoverColor ?? fontColor)
//                    }
//                    else{
//                        setBackground = setBackgroundColorFill(buttonOnHoverColor)
//
//                        if fontOnHoverColor != nil{
//                            setTextLayerFontColor(fontOnHoverColor)
//                        }
//                        else{
//                            setTextLayerFontColor(fontHoverColor ?? fontColor)
//                        }
//                    }
//
//                }
//                else {
//
//                    if(!isOn){
//                        setBackground = setBackgroundColorFill(buttonColor)
//                    }
//                    else{
//                        setBackground = setBackgroundColorFill(buttonOnColor)
//                    }
//
//                    setTextLayerFontColor(fontColor)
//                }
//            }
//            else {
//
//                if isMouseEntered {
//
//                    if !isOn {
//                        setBackground = setBackgroundColorFill(buttonPressedBackgroundColor)
//                        setTextLayerFontColor(fontMouseDownColor, mouseDownIcon: true)
//                    }
//                    else {
//                        setBackground = setBackgroundColorFill(buttonOnPressedBackgroundColor ?? buttonPressedBackgroundColor)
//                        setTextLayerFontColor(fontOnMouseDownColor ?? fontMouseDownColor, mouseDownIcon: true)
//                    }
//                }
//                else {
//
//                    if !isOn{
//                        setBackground = setBackgroundColorFill(buttonHoverColor)
//                    }
//                    else{
//                        setBackground = setBackgroundColorFill(buttonOnColor)
//                    }
//
//                    setTextLayerFontColor(fontColor)
//                }
//            }
//        }
//        else{
//
//            if let _ = fontDisabledColor {
//                setTextLayerFontColor(fontDisabledColor)
//            }
//            else{
//                setTextLayerFontColor(ThemeManager.disabledTextForButtonColor())
//            }
//
//            setBackground = setBackgroundColorFill(buttonDisabledColor)
//        }
//
//
//        NSGraphicsContext.saveGraphicsState()
//
//        let adjustedRect = self.bounds.getAdjustedRect(adjust: 1.0)
//
//        if setBackground {
//            var clipPath: NSBezierPath!
//            if isCircular {
//                clipPath = NSBezierPath(ovalIn: adjustedRect)
//            } else {
//                clipPath = getBezierPathWithSomeRoundedCorners()
//            }
//
//            clipPath.addClip()
//            clipPath.fill()
//
//            setBorder(clipPath: clipPath)
//        }
//        else if borderWidth > 0{
//            var clipPath: NSBezierPath!
//            if isCircular {
//                clipPath = NSBezierPath(ovalIn: adjustedRect)
//            } else {
//                clipPath = getBezierPathWithSomeRoundedCorners()
//            }
//
//            setBorder(clipPath: clipPath)
//        }
//
//        let currentContext = NSGraphicsContext.current
//        if let gc = currentContext{
//            textLayer.drawTextLayerInContext(gc.cgContext, xOffset:xOffset, yOffset:yOffset)
//        }
//        NSGraphicsContext.restoreGraphicsState()
//
//    }
//
//    //MARK: Public methods
//    func updateFrame(_ rect: NSRect)
//    {
//        self.frame = rect
//        textLayer?.frame = self.frame
//    }
//
//    //MARK: Private methods
//    fileprivate func rotateByDegrees(_ degrees: CGFloat){
//
//        //Layers anchor point is by default 0.0 but we want to rotate around
//        //the layers center point so translate to centre
//        if let l = layer{
//            let f = l.frame
//            let c = CGPoint(x: f.midX, y: f.midY)
//            l.position = c
//            l.anchorPoint = CGPoint(x: 0.5,y: 0.5)
//        }
//
//        if animateRotation {
//            let ani = CABasicAnimation()
//            ani.duration = 0.25
//            self.layer?.add(ani, forKey: "transform")
//        }
//        var radians:CGFloat = 0
//        if degrees > 0 {
//            radians = degreesToRadians(degrees)
//        }
//        self.layer?.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, -1.0)
//    }
//
//    func updateMouseInsideIfNeeded(){
//
//        let isMouseInView = self.isMouseInView()
//        if isMouseInView != isMouseEntered{
//            isMouseEntered = isMouseInView
//            self.needsDisplay = true
//        }
//    }
//
//    fileprivate func animateBackgroundColorOpacity() {
//
//        if !opacityAnimationApplied {
//
//            opacityAnimationApplied = true
//            let colorAnimation = CABasicAnimation(keyPath: "opacity")
//            colorAnimation.duration = 0.35
//            colorAnimation.fromValue = 0
//            colorAnimation.toValue = 1
//            colorAnimation.repeatCount = 0
//            self.layer?.add(colorAnimation, forKey: "animateOpacity")
//        }
//    }
//
//    fileprivate func degreesToRadians(_ degrees:CGFloat) -> CGFloat{
//        return (CGFloat(Float.pi) * degrees) /  180
//    }
//
//    fileprivate func setTextLayerFontColor(_ theColor: NSColor?, mouseDownIcon: Bool = false){
//        if let _ = textLayer{
//            if let _ = theColor{
//                let style = NSMutableParagraphStyle()
//                style.alignment = NSTextAlignment.center
//
//                var fontelloName: String
//
//                switch iconSet {
//                case .atlanticIconSet:
//                    fontelloName = Constants.atlanticFont
//                case .atlanticIllustrationSet:
//                    fontelloName = Constants.atlanticIllustrations
//                case .momentumIconSet:
//                    fontelloName = Constants.momentumIconFont
//                }
//
//
//                let attrsDictionary: [NSAttributedString.Key : Any] = [ NSAttributedString.Key.paragraphStyle : style,
//                                                                       NSAttributedString.Key.font : NSFont(name : fontelloName,
//                                                                                                           size : textLayer.fontSize) as Any ]
//                let iconToSet:String?
//                let iconColor:NSColor?
//
//                if(isOn){
//
//                    if rotateWhenTurnedOn || rotateAlways {
//                        rotateByDegrees(rotateDegrees)
//                        iconToSet = iconName
//                    }
//                    else{
//                        iconToSet = iconOnName ?? iconName
//                    }
//
//                    if(theColor == fontColor){
//                        if !isEnabled && fontDisabledColor != nil{
//                            iconColor = theColor
//                        }
//                        else{
//                            iconColor = fontOnColor ?? fontColor
//                        }
//                    }
//                    else{
//                        iconColor = theColor
//                    }
//
//                }
//                else{
//
//                    if rotateAlways {
//                        rotateByDegrees(rotateDegrees)
//                    } else if(rotateWhenTurnedOn){
//                        rotateByDegrees(0)
//                    }
//
//                    if let mdIcon = iconPressedName, mouseDownIcon == true{
//                        iconToSet = mdIcon
//                    }
//                    else{
//                     iconToSet = iconName
//                    }
//
//                    iconColor = theColor
//                }
//                let attrString = NSMutableAttributedString.init(string: iconToSet ?? " ", attributes: attrsDictionary)
//
//                let iconNameRange = getRangeForIcon(iconToSet)
//
//                attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: iconColor!, range: iconNameRange)
//                textLayer.string = attrString
//            }
//        }
//    }
//
//    fileprivate func getRangeForIcon(_ iconName: String?) -> NSRange {
//        let iconNameLength:Int
//
//        if let _ = iconName {
//            iconNameLength = iconName!.count
//        } else {
//            iconNameLength = 1
//        }
//        return NSMakeRange(0, iconNameLength)
//    }
//
//
//
//
//    fileprivate func setBorder(clipPath: NSBezierPath) {
//        let theBorderWidth = isEnabled ? borderWidth : borderDisabledWidth
//
//       if theBorderWidth > 0{
//            var color = borderColor
//            if let borderSelectedColor = borderSelectedColor , isOn == true {
//                color = borderSelectedColor
//            }
//            if let c = color{
//                clipPath.lineWidth = theBorderWidth
//                c.setStroke()
//                clipPath.stroke()
//            }
//       }
//    }
//
//
//    fileprivate func setBackgroundColorFill(_ theColor: NSColor?) -> Bool{
//        if let _ = theColor{
//            theColor?.setFill()
//            return true
//        }
//        return false
//    }
//
//    override func drawFocusRingMask() {
//
//        if isCircular {
//            let clipPath = NSBezierPath(ovalIn: self.bounds.getAdjustedRect(adjust: 1.0))
//            clipPath.fill()
//        }
//        else if cornerRadius == 0{
//            self.bounds.fill()
//        }
//        else if shouldRoundTopLeftWhenRounding && shouldRoundTopRightWhenRounding &&
//                shouldRoundBottomLeftWhenRounding && shouldRoundBottomRightWhenRounding{
//
//            let clipPath = NSBezierPath(roundedRect: self.bounds, xRadius: cornerRadius, yRadius: cornerRadius)
//            clipPath.fill()
//        }
//        else{
//            let clipPath = getBezierPathWithSomeRoundedCorners()
//            clipPath.fill()
//        }
//    }
//
//    override var focusRingMaskBounds: NSRect{
//        return self.bounds
//    }
//
//    override func hitTest(_ point: NSPoint) -> NSView? {
//        if passThroughMouseEvent{
//            return nil
//        }
//
//        return super.hitTest(point)
//    }
//
//    override func keyDown(with event: NSEvent) {
//        let keyCode : Int = Int(event.keyCode)
//        if keyCode == kVK_Space {
//            self.performClick(self)
//        }
//        else {
//            super.keyDown(with: event)
//        }
//    }
//}
//
//extension FontelloButton {
//    func setupWith(iconSize: CGFloat, iconName: String, colorState: ColorStates, toolTip: String?, fontColorState: ColorStates = ThemeManager.activityIconColorState(), isTwoState: Bool = false, isEnabled: Bool = true, notifySuperMouseEnterExit: Bool = false){
//        initialise()
//        iconSet  = .momentumIconSet
//        self.iconSize = iconSize
//        self.iconName = iconName
//        
//        buttonColor                  = colorState.normal
//        buttonHoverColor             = colorState.hover
//        buttonPressedBackgroundColor = colorState.pressed
//        buttonDisabledColor          = colorState.disabled
//        
//        fontColor          = fontColorState.normal
//        fontHoverColor     = fontColorState.hover
//        fontMouseDownColor = fontColorState.pressed
//        fontDisabledColor  = fontColorState.disabled
//        
//        self.isTwoState = isTwoState
//        self.isEnabled  = isEnabled
//        self.needsDisplay = true
//        
//        self.toolTip = toolTip
//        setAccessibilityTitle(toolTip)
//        self.notifySuperMouseEnterExit = notifySuperMouseEnterExit
//    }
//}
