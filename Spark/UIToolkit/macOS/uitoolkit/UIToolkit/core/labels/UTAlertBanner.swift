//
//  UTAlertBanner.swift
//  UIToolkit
//
//  Created by James Nestor on 17/06/2021.
//

import Cocoa

public protocol UTAlertBannerDelegate : AnyObject {
    func alertBannerCloseAction(sender:Any)
}

public class UTAlertBanner: UTTokenWrappingLabel {
    
    //MARK: - UTAlertBannerCancelButton class

    ///Private class for the alert banners cancel button
    ///The button will match the text validation state
    class UTAlertBannerCancelButton: UTButton {
        
        public var validationState:UTAlertBanner.UTAlertValidationState = .general {
            didSet{
                self.fontTokenName = validationState.textToken
                setThemeColors()
            }
        }
        
        override func initialise() {
            super.initialise()
            self.fontIcon = .cancelBold
            self.fontIconSize = 14
            self.fontTokenName = validationState.textToken
            self.buttonType = .round
            self.setContentHuggingPriority(.required, for: .horizontal)
            self.setContentHuggingPriority(.required, for: .vertical)
        }
        
        override func toCGFloat(height: ButtonHeight) -> CGFloat {
            switch height {
            default: return 14
            }
        }
    }
    
    //MARK: - UTAlertValidationState enum
    
    ///Enum for the different validation states of the alert banner
    ///Providees variables that return the correct token depending on its validation state
    public enum UTAlertValidationState: UInt{
        case success
        case warning
        case error
        case general
        case transient
        
        var textToken:String {
            switch self{
            case .success:
                return UIToolkit.shared.isUsingLegacyTokens ? "alertText-success" : UTColorTokens.bannerSuccessText.rawValue
            case .warning:
                return UIToolkit.shared.isUsingLegacyTokens ? "alertText-warning" : UTColorTokens.bannerIssueText.rawValue
            case .error:
                return UIToolkit.shared.isUsingLegacyTokens ? "alertText-error" : UTColorTokens.bannerErrorText.rawValue
            case .general:
                return UIToolkit.shared.isUsingLegacyTokens ? "alertText-default" : UTColorTokens.bannerAnnouncementText.rawValue
            case .transient:
                return UIToolkit.shared.isUsingLegacyTokens ? "text-primary" : UTColorTokens.bannerTransientText.rawValue
            }
        }
        
        var backgroundToken:String {
            switch self{
            case .success:
                return UIToolkit.shared.isUsingLegacyTokens ? "alertBackground-success" : UTColorTokens.bannerSuccessBackground.rawValue
            case .warning:
                return UIToolkit.shared.isUsingLegacyTokens ? "alertBackground-warning" : UTColorTokens.bannerIssueBackground.rawValue
            case .error:
                return UIToolkit.shared.isUsingLegacyTokens ? "alertBackground-error" : UTColorTokens.bannerErrorBackground.rawValue
            case .general:
                return UIToolkit.shared.isUsingLegacyTokens ? "alertBackground-default" : UTColorTokens.bannerAnnouncementBackground.rawValue
            case .transient:
                return UIToolkit.shared.isUsingLegacyTokens ? "button-secondary" : UTColorTokens.bannerTransientBackground.rawValue
            }
        }
    }
    
    //MARK: - Style enum
    
    ///Enum for the background style of the banner.
    ///Determines if the banner have a pill shape or rounded corners
    public enum Style {
        case pill
        case rounded
    }
    
    //MARK: - Public variables
    
    public var validationState:UTAlertValidationState = .general {
        didSet{
            onValidationStateUpdated()
        }
    }
    
    public weak var delegate:UTAlertBannerDelegate?
    
    //MARK: - Internal variables
    
    internal var bannerStyle:UTAlertBanner.Style = .rounded{
        didSet{
            if oldValue != bannerStyle {
                updateCornerRadius()
            }
        }
    }
    
    internal var isCentred:Bool = false{
        didSet {
            if oldValue != isCentred {
                layoutViews()
            }
        }
    }
    
    //MARK: - Private variables
    
    private var validationIcon:MomentumRebrandIconType{
        switch validationState{
        case .success:
            return .checkCircleFilled
        case .warning:
            return .warningFilled
        case .error:
            return .errorLegacyFilled
        case .general:
            return .infoCircleFilled
        case .transient:
            //transient shows spinner
            //using .spinnerFilled will give a solid circle
            return ._invalid
        }
    }
    
    private var cancelButtonStackView:NSStackView!
    private var cancelButton:UTAlertBannerCancelButton!
    private var wantsCloseButton = false
    private var spinnerView:UTSpinnerView?
    
    //MARK: - Lifecycle
    
    public init(stringValue:String, validationState:UTAlertValidationState, wantsCloseButton:Bool = false, isCentred:Bool = false, style:UTAlertBanner.Style = .rounded){
        super.init(frame: NSZeroRect)
        
        configure(stringValue: stringValue, validationState: validationState, wantsCloseButton: wantsCloseButton, isCentred: isCentred, style: style)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func initialise() {
        super.initialise()
        
        self.iconSize  = .mediumSmall
        self.fontType  = .bodyPrimary
        
        //override base class content hugging priority.
        //Allow contiainer to grow to fill parent
        label.setContentHuggingPriority(.init(251),       for: .horizontal)
        containerStackView.setHuggingPriority(.init(251), for: .horizontal)
        labelStackView.setHuggingPriority(.init(249),     for: .horizontal)
    }
    
    //MARK: - Public API
    
    ///If the alert banner is created in a .xib file configure should be called to set the style of the banner
    public func configure(stringValue:String, validationState:UTAlertValidationState, wantsCloseButton:Bool = false, isCentred:Bool = false, style:UTAlertBanner.Style = .rounded) {
                
        spinnerView = UTSpinnerView(size: .small)
        iconStackView.addArrangedSubview(spinnerView!)
        
        self.labelString = stringValue
        
        self.labelStackView.edgeInsets.bottom = 8
        self.containerStackView.setContentCompressionResistancePriority(.required, for: .vertical)
        self.containerStackView.edgeInsets.right = 8
        self.containerStackView.spacing = 8
        
        self.iconStackView.alignment    = .centerX
        self.iconStackView.distribution = .fillProportionally
        self.iconStackView.setHuggingPriority(.defaultLow, for: .vertical)
        self.iconStackView.edgeInsets = NSEdgeInsets(top: 2, left: 0, bottom: 0, right: 0)
        
        self.validationState  = validationState
        self.bannerStyle      = style
        self.isCentred        = isCentred
        self.wantsCloseButton = wantsCloseButton
        
        if wantsCloseButton {
            cancelButtonStackView = NSStackView()
            cancelButtonStackView.wantsLayer = true
            cancelButtonStackView.distribution = .equalCentering
            cancelButtonStackView.alignment = .centerX
            cancelButtonStackView.setContentHuggingPriority(.defaultLow, for: .vertical)
            cancelButtonStackView.setContentHuggingPriority(.required, for: .horizontal)
            cancelButtonStackView.edgeInsets.left = 4
            cancelButtonStackView.spacing = 0
            
            cancelButton = UTAlertBannerCancelButton(frame: NSMakeRect(0, 0, 14, 14))
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.validationState = validationState
            cancelButton.action = #selector(closeButtonAction)
            cancelButton.target = self
            
            cancelButtonStackView.addArrangedSubview(cancelButton)
        }
        else {
            if let cancelButtonStackView = cancelButtonStackView {
                containerStackView.removeView(cancelButtonStackView)
            }
            
            cancelButtonStackView = nil
            cancelButton = nil
        }
        
        layoutViews()
        
        updateCornerRadius()
        setThemeColors()
    }
    
    override public func setThemeColors() {
        icon?.iconType   = validationIcon
        icon?.tokenName  = validationState.textToken
        label?.tokenName = validationState.textToken
        layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: validationState.backgroundToken).normal.cgColor
        
        iconStackView?.setThemeableViewColors()
        
        cancelButton?.setThemeColors()
        
        super.setThemeColors()
    }
    
    override public func setFrameSize(_ newSize: NSSize) {
        let heightChanged = newSize.height != frame.height
        super.setFrameSize(newSize)
        
        if bannerStyle == .pill && heightChanged {
            updateCornerRadius()
        }
    }
    
    //MARK: - Private API
    
    private func onValidationStateUpdated() {
        
        if validationState == .transient {
            icon.isHidden = true
            spinnerView?.isHidden = false
        }
        else {
            icon.isHidden = false
            spinnerView?.isHidden = true            
        }
        
        cancelButton?.validationState = validationState
        setThemeColors()
    }
    
    private func updateCornerRadius(){
        
        guard let layer = layer else { return }
        
        if bannerStyle == .rounded {
            if layer.cornerRadius != 8{
                layer.cornerRadius = 8
            }
        }
        else if bannerStyle == .pill {
            
            let cornerRadius:CGFloat = self.frame.height / 2
            if layer.cornerRadius != cornerRadius{
                layer.cornerRadius = cornerRadius
            }
        }
    }
    
    private func layoutViews(){
        containerStackView.removeAllViews()
        
        if isCentred {
            containerStackView.addView(NSView(), in: .leading)
            containerStackView.addView(iconStackView, in: .center)
            containerStackView.addView(labelStackView, in: .center)
            containerStackView.addView(NSView(), in: .trailing)
            
            if let cancelButtonStackView = cancelButtonStackView {
                containerStackView.addView(cancelButtonStackView, in: .trailing)
            }
        }
        else {
            containerStackView.addView(iconStackView, in: .leading)
            containerStackView.addView(labelStackView, in: .leading)
            labelStackView.alignment = .leading
            
            if let cancelButtonStackView = cancelButtonStackView {
                containerStackView.addView(cancelButtonStackView, in: .trailing)
            }
        }
    }
    
    //MARK: - Actions
    
    @objc private func closeButtonAction(_ sender:Any){
        delegate?.alertBannerCloseAction(sender: self)
    }
    
}
