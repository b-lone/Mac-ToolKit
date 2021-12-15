//
//  LoadingSpinnerView.swift
//  UIToolkit
//
//  Created by James Nestor on 20/08/2021.
//

import Cocoa

///Rotating spinner for showing loading state
public class UTSpinnerView: NSView, ThemeableProtocol {
    
    ///Size enum for spinners of different predefined sizes
    public enum Size {
        case extraSmall
        case small
        case medium
        case large
        
        var asSize:NSSize {
            switch self{
            case .extraSmall:
                return NSMakeSize(12, 12)
            case .small:
                return NSMakeSize(16, 16)
            case .medium:
                return NSMakeSize(32, 32)
            case .large:
                return NSMakeSize(48, 48)
            }
        }
    }
    
    ///Style enum for the different supported colours
    ///Default style is loading
    public enum Style {
        case progress
        case loading
        
        var trackToken:String {
            switch self {
            case .progress:
                return "spinner-progress-track"
            case .loading:
                return "spinner-loading-track"
            }
        }
        
        var cursorToken:String{
            switch self {
            case .progress:
                return "spinner-progress-cursor"
            case .loading:
                return "spinner-loading-cursor"
            }
        }
    }
       
    
    //MARK: - Public variables
    public var size:Size = .small {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
        
    public var style:Style = .loading {
        didSet{
            setThemeColors()
        }
    }
    
    override public var intrinsicContentSize: NSSize {
        return self.size.asSize
    }
    
    //MARK: - Private variables
    
    private let rotationAnimationKey = "rotation"
    private var trackLayer:CAShapeLayer?
    private var cursorLayer:CAShapeLayer?
    
    private var trackColor:CCColor {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: style.trackToken).normal
    }
    
    private var cursorColor:CCColor {
        return UIToolkit.shared.getThemeManager().getColors(tokenName: style.cursorToken).normal
    }
    
    //MARK: - Lifecycle
    public init(size:UTSpinnerView.Size, style:UTSpinnerView.Style = .loading){
        let s = size.asSize
        super.init(frame: NSMakeRect(0, 0, s.width, s.height))
        self.size = size
        self.style = style
        initialise()
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    internal func initialise() {
        self.wantsLayer = true
        layer?.updateCentrePoint()
        
        let spinnerRect = self.bounds.getAdjustedRect(adjust: 2)
        
        //Outline track
        let trackLayer = CAShapeLayer()
        trackLayer.position    = CGPoint(x: 0, y: 0)
        trackLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        trackLayer.lineCap     = CAShapeLayerLineCap.round
        trackLayer.lineJoin    = .round
        trackLayer.lineWidth   = 2
        trackLayer.allowsEdgeAntialiasing = true
        trackLayer.fillColor   = CCColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        
        trackLayer.path = NSBezierPath(ovalIn: spinnerRect).cgPath
        self.trackLayer = trackLayer
        
        self.layer?.addSublayer(trackLayer)

        //Solid spinner
        let cursorLayer = CAShapeLayer()
        cursorLayer.position = CGPoint(x: 0, y: 0)
        cursorLayer.lineCap  = .round
        cursorLayer.lineJoin = .round
        cursorLayer.allowsEdgeAntialiasing = true
        cursorLayer.lineWidth   = 2
        cursorLayer.fillColor   = CCColor.clear.cgColor
        cursorLayer.strokeColor = cursorColor.cgColor
        cursorLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        cursorLayer.strokeEnd   = 0.25
        
        let bezierPath = NSBezierPath()
        bezierPath.appendArc(withCenter: bounds.centre(), radius: spinnerRect.width / 2, startAngle: 90, endAngle:  180, clockwise: true)
        cursorLayer.path = bezierPath.cgPath
        self.cursorLayer = cursorLayer
        
        self.layer?.insertSublayer(cursorLayer, above: trackLayer)
    }
    
    //MARK: - Public API
    public func setThemeColors() {
        trackLayer?.strokeColor = trackColor.cgColor
        cursorLayer?.strokeColor = cursorColor.cgColor
    }
    
    public override var isOpaque: Bool{
        return false
    }
    
    public func startSpinner() {
        guard let layer = self.layer else { return }
        
        if self.isHidden { return }
        
        if layer.animation(forKey: rotationAnimationKey) == nil {
            addRotationAnimation()
        }
    }
    
    public func stopSpinner() {
        guard let layer = self.layer else { return }
        
        if layer.animation(forKey: rotationAnimationKey) != nil {
            layer.removeAnimation(forKey: rotationAnimationKey)
        }
    }
    
    //Centre point gets reset at certain points which ruins the rotation animation
    //as it starts rotating around bottom left instead of centre.
    //To fix this the centre point needs to be reset
    override public func setFrameOrigin(_ newOrigin: NSPoint) {
        super.setFrameOrigin(newOrigin)
        layer?.updateCentrePoint()
    }
    
    override public func layout() {
        super.layout()
        layer?.updateCentrePoint()
    }
    
    public override func draw(_ dirtyRect: NSRect) {
        layer?.updateCentrePoint()
    }
    
    public override func viewDidUnhide() {
        super.viewDidUnhide()
        startSpinner()
    }
    
    public override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        
        if window != nil && !isHiddenOrHasHiddenAncestor {
            startSpinner()
        }
    }
    
    public override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        
        if window != nil && !isHiddenOrHasHiddenAncestor {
            startSpinner()
        }
    }
    
    override open func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        
        guard let scale = window?.backingScaleFactor,
              let layer = self.layer else {
            return
        }
        
        layer.contentsScale        = scale
        trackLayer?.contentsScale  = scale
        cursorLayer?.contentsScale = scale
    }
    
    //MARK: - Private API
    
    private func addRotationAnimation() {
        let animation = createRotationAnimation()
        layer?.add(animation, forKey: rotationAnimationKey)
    }
    
    private func createRotationAnimation(speed: Double = 1.33, clockWise: Bool = true) -> CABasicAnimation {
        
        let angle = clockWise ? -(Double.pi * 2.0): (Double.pi * 2.0)
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = angle
        animation.duration = (1/speed)
        animation.repeatCount = .infinity
        
        return animation
    }
    
}

extension UTSpinnerView: NSViewLayerContentScaleDelegate {
    public func layer(_ layer: CALayer, shouldInheritContentsScale newScale: CGFloat, from window: NSWindow) -> Bool { true }
}
