//
//  ShareIosScreenPromptWindowController.swift
//  WebexTeams
//
//  Created by Archie You on 2021/8/30.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa
import UIToolkit

typealias IShareIosScreenPromptWindowController = NSWindowController & ShareIosScreenPromptWindowControllerProtocol

protocol ShareIosScreenPromptWindowControllerProtocol: AnyObject {
    func showWindow(screen: ScreenId?)
}

class ShareIosScreenPromptWindowController: BaseWindowController {
    override var windowNibName: NSNib.Name? { "ShareIosScreenPromptWindowController" }
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var effectView: NSVisualEffectView!
    @IBOutlet weak var spinner: UTSpinnerView!
    @IBOutlet weak var titleLabel: UTLabel!
    
    @IBOutlet weak var step1ContainerView: NSView!
    @IBOutlet weak var step1LabelView: NSView!
    @IBOutlet weak var step1NumLabel: UTLabel!
    @IBOutlet weak var step1ImageView: NSImageView!
    @IBOutlet weak var step1Label: NSTextField!
    
    @IBOutlet weak var step2ContainerView: NSView!
    @IBOutlet weak var step2LabelView: NSView!
    @IBOutlet weak var step2NumLabel: UTLabel!
    @IBOutlet weak var step2ImageView: NSImageView!
    @IBOutlet weak var step2Label: NSTextField!
    
    private var sharedScreenUuid: ScreenId?
    
    override init(appContext: AppContext) {
        super.init(appContext: appContext)
        let _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.backgroundColor = .clear
        window?.hasShadow = true
        window?.isMovableByWindowBackground = true
        window?.level = .floating
        window?.center()
        
        contentView.wantsLayer = true
        contentView.layer?.cornerRadius = 10
        
        spinner.size = .medium
        spinner.style = .loading
        
        titleLabel.stringValue = LocalizationStrings.sharingWillStartAutomatically
        titleLabel.fontType = .bannerSecondary
        titleLabel.style = .primary
        titleLabel.lineBreakMode = .byWordWrapping
        
        step1ContainerView.wantsLayer = true
        step1ContainerView.layer?.cornerRadius = 12
        
        step1LabelView.wantsLayer = true
        step1LabelView.layer?.cornerRadius = 4
        
        step1NumLabel.fontType = .subheaderPrimary
        step1NumLabel.style = .primary
        
        step2ContainerView.wantsLayer = true
        step2ContainerView.layer?.cornerRadius = 12
        
        step2LabelView.wantsLayer = true
        step2LabelView.layer?.cornerRadius = 4
        
        step2NumLabel.fontType = .subheaderPrimary
        step2NumLabel.style = .primary

        setThemeColors()
    }
    
    override func close() {
        super.close()
        spinner.stopSpinner()
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        window?.appearance = NSAppearance.getVibrantThemedAppearance()
        
        spinner.setThemeColors()
        titleLabel.setThemeColors()
        
        step1ContainerView.layer?.backgroundColor = ThemeManager.isDarkTheme() ? CCColor.white.withAlpha(0.07).cgColor : CCColor.black.withAlpha(0.07).cgColor
        step1LabelView.layer?.backgroundColor = ThemeManager.isDarkTheme() ? CCColor.white.withAlpha(0.2).cgColor : CCColor.black.withAlpha(0.2).cgColor
        step1NumLabel.setThemeColors()
        step1ImageView.image = ThemeManager.isDarkTheme() ? Bundle.getImageInSparkBundle(imageName: "share-ios-computer-phone-dark") : Bundle.getImageInSparkBundle(imageName: "share-ios-computer-phone-light")
        updateStepLabel(lable: step1Label, textWithPara: LocalizationStrings.connectYourIphoneOrIpad, boldText: LocalizationStrings.cable)
        
        step2ContainerView.layer?.backgroundColor = ThemeManager.isDarkTheme() ? CCColor.white.withAlpha(0.07).cgColor : CCColor.black.withAlpha(0.07).cgColor
        step2LabelView.layer?.backgroundColor = ThemeManager.isDarkTheme() ? CCColor.white.withAlpha(0.2).cgColor : CCColor.black.withAlpha(0.2).cgColor
        step2NumLabel.setThemeColors()
        step2ImageView.image = ThemeManager.isDarkTheme() ? Bundle.getImageInSparkBundle(imageName: "share-ios-tap-on-phone-dark") : Bundle.getImageInSparkBundle(imageName: "share-ios-tap-on-phone-light")
        updateStepLabel(lable: step2Label, textWithPara: LocalizationStrings.trustThisComputer, boldText: LocalizationStrings.trust)
    }
    
    private func updateStepLabel(lable: NSTextField, textWithPara: String, boldText: String) {
        let string = String.localizedStringWithFormat(textWithPara, boldText)
        let range = (string as NSString).range(of: boldText)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let foregroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "label-primary-text").normal
        let attributedString = NSMutableAttributedString(string: string, attributes:
                                                            [
                                                                .font : NSFont.systemFont(ofSize: 16),
                                                                .paragraphStyle: paragraphStyle,
                                                                .foregroundColor: foregroundColor
                                                            ])
        attributedString.addAttribute(.font, value: NSFont.boldSystemFont(ofSize: 16), range: range)
        lable.attributedStringValue = attributedString
    }
    
    private func updateWindowFrame() {
        guard let window = window else { return }
        let screenFrame = NSScreen.screen(uuid: sharedScreenUuid).frame
        let size = window.frame.size
        let frame = NSMakeRect(screenFrame.minX + (screenFrame.width - size.width) / 2,
                               screenFrame.minY + (screenFrame.height - size.height) / 2,
                               size.width,
                               size.height)
        window.setFrame(frame, display: true, animate: true)
    }
}

extension ShareIosScreenPromptWindowController: ShareIosScreenPromptWindowControllerProtocol {
    func showWindow(screen: ScreenId?) {
        spinner.startSpinner()
        showWindow(nil)
        sharedScreenUuid = screen
        updateWindowFrame()
    }
}
