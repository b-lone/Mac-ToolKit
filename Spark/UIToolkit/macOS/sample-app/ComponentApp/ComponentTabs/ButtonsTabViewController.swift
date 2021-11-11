//
//  ButtonsTabViewController.swift
//  TestApp
//
//  Created by Jimmy Coyne on 25/04/2021.
//

import Cocoa
import UIToolkit

class ButtonsTabViewController: UTBaseViewController {
    
    @IBOutlet weak var largePillButton: UTPillButton!
    @IBOutlet weak var mediumPillButton: UTPillButton!
    @IBOutlet weak var smallPillButton: UTPillButton!
    @IBOutlet weak var extraSmallPIllButton: UTPillButton!
    
    @IBOutlet weak var largePillWithIconButton: UTPillButton!
    @IBOutlet weak var mediumPillWithIconButton: UTPillButton!
    @IBOutlet weak var smallPillWithIconButton: UTPillButton!
    
    @IBOutlet weak var extraLargeRoundButton: UTRoundButton!
    @IBOutlet weak var largeRoundButton: UTRoundButton!
    @IBOutlet weak var mediumRoundButton: UTRoundButton!
    @IBOutlet weak var smallRoundButton: UTRoundButton!
    @IBOutlet weak var extraSmallRoundButton: UTRoundButton!
    
    @IBOutlet weak var mediumDownArrowButton: UTDownArrowButton!
    @IBOutlet weak var smallDownArrowButton: UTDownArrowButton!

    @IBOutlet weak var largeRoundedCornerButton: UTRoundedCornerButton!
    @IBOutlet weak var mediumRoundedCornerButton: UTRoundedCornerButton!
    @IBOutlet weak var smallRoundedCornerButton: UTRoundedCornerButton!
    @IBOutlet weak var extraSmallRoundedCornerButton: UTRoundedCornerButton!
    
    @IBOutlet weak var dualButtonControlSmall: UTDualButton!
    @IBOutlet weak var dualButtonControlMedium: UTDualButton!
    @IBOutlet weak var buttonGridView: NSGridView!
    @IBOutlet weak var doubleLength: NSButton!
    @IBOutlet weak var dualButton: UTDualButton!
    
    
    @IBOutlet weak var buttonStylesStackView: NSStackView!
    
    @IBOutlet weak var dualIconButton: UTIconDualButton!
    @IBOutlet weak var largeIconDualButton: UTIconDualButton!
    @IBOutlet weak var dualIconWithLabelButton: UTIconDualWithTitleButton!
    @IBOutlet weak var largeDualIconWithLabelButton: UTIconDualWithTitleButton!
    
    @IBOutlet weak var lhsRoundedCornerButton: UTRoundedCornerButton!
    @IBOutlet weak var rhsRoundedCornerButton: UTRoundedCornerButton!
        
    @IBOutlet var iconButtonStackView: NSStackView!
    @IBOutlet var favoriteIconButton: UTIconButton!
    private var settingsIconButton:UTIconButton!
    private var attatchmentIconButton:UTIconButton!
    private var flagsButton:UTIconButton!
    

    @IBOutlet weak var navtabButton: UTNavigationTabButton!

    @IBOutlet var globalHeaderBackgroundView: GlobalHeaderBackgroundView!
    @IBOutlet var globalHeaderStackView: NSStackView!
    private var statusButton:UTGlobalHeaderButton!
    private var backButton:UTGlobalHeaderButton!
    private var forwardButton:UTGlobalHeaderButton!
    private var plusButton:UTGlobalHeaderButton!
    private var devicesButton:UTGlobalHeaderButton!
    
    lazy var pillsButtons:[(UTPillButton,ButtonHeight )] = [(largePillButton, ButtonHeight.large) ,(mediumPillButton,ButtonHeight.medium), (smallPillButton, ButtonHeight.small), (extraSmallPIllButton, ButtonHeight.extrasmall)]
    
    lazy var pillsWithIconButtons:[(UTPillButton,ButtonHeight )] = [(largePillWithIconButton, ButtonHeight.large) ,(mediumPillWithIconButton,ButtonHeight.medium), (smallPillWithIconButton, ButtonHeight.small)]
    
    lazy var roundIconButtons:[(UTRoundButton,ButtonHeight )] = [(extraLargeRoundButton, ButtonHeight.extralarge),(largeRoundButton, ButtonHeight.large) ,(mediumRoundButton,ButtonHeight.medium), (smallRoundButton, ButtonHeight.small), (extraSmallRoundButton, ButtonHeight.extrasmall)]
    
    lazy var roundDownArrowButtons:[(UTDownArrowButton,ButtonHeight )] = [(mediumDownArrowButton,ButtonHeight.medium), (smallDownArrowButton, ButtonHeight.small) ]
    
    lazy var roundedCornerButtons:[(UTRoundedCornerButton,ButtonHeight )] = [(largeRoundedCornerButton, ButtonHeight.large), (mediumRoundedCornerButton, ButtonHeight.medium), (smallRoundedCornerButton, ButtonHeight.small), (extraSmallRoundedCornerButton, ButtonHeight.extrasmall) ]

    lazy var dualIconWithLabelButtons:[(UTIconDualWithTitleButton,UTIconDualWithTitleButton.Size)] = [(dualIconWithLabelButton, UTIconDualWithTitleButton.Size.small) ,(largeDualIconWithLabelButton, UTIconDualWithTitleButton.Size.medium)]
    
    lazy var allButtons = pillsWithIconButtons + roundIconButtons + roundDownArrowButtons +  pillsButtons + roundedCornerButtons as [Any]
    
    let styles:[(UTButton.Style, String)] = [(.primary,"primary"), (.secondary, "secondary"), (.ghost, "ghost"), (.ghostCancel, "ghostCancel"), (.ghostMessage, "gostMessage"), (.join ,"join"), (.outlineJoin, "outlineJoin") , (.cancel, "cancel"), (.outlineCancel,"outlineCancel"), (.message, "message"), (.hyperlink, "hyperlink")]
    
    
    lazy var attributedString : NSAttributedString = {
        
        let  normalText = "Hi am normal "
        let  boldText  = "And I am BOLD! "
        let  attributedString = NSMutableAttributedString(string:normalText)
        let  attrs = [NSAttributedString.Key.font : NSFont.boldSystemFont(ofSize: 15)]
        let  boldString = NSMutableAttributedString(string: boldText, attributes:attrs)
        attributedString.append(boldString)
        attributedString.append(attributedString)
        attributedString.append(boldString)
        return attributedString
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonStylesStackView.distribution = .fillEqually
        // Do view setup here.
        updateButtons()
        updateButtonStyles()
        updateSplitButtons()
        
        dualButtonControlSmall.delegate = self
        dualButtonControlMedium.delegate = self
        
        dualIconButton.size = .small
        dualIconButton.addLHSDetails(accessibilityLabel: "zoom in", icon: .zoomOutBold)
        dualIconButton.addRHSDetails(accessibilityLabel: "zoom out", icon: .zoomInBold)
        dualIconButton.toolTip = "UTIconDualButton"
        
        largeIconDualButton.size = .medium
        largeIconDualButton.addLHSDetails(accessibilityLabel: "zoom in", icon: .zoomOutBold)
        largeIconDualButton.addRHSDetails(accessibilityLabel: "zoom out", icon: .zoomInBold)
        let details = UTRichTooltipDetails(tooltip: attributedString, size: .medium )
        largeIconDualButton.addUTToolTip(toolTip: .rich(details))
        
        favoriteIconButton.icon = .favorite
        settingsIconButton = UTIconButton()
        settingsIconButton.icon = .settings
        attatchmentIconButton = UTIconButton()
        attatchmentIconButton.icon = .attatchment
        
        flagsButton = UTIconButton()
        flagsButton.icon = .flag
        
        iconButtonStackView.addArrangedSubview(settingsIconButton)
        iconButtonStackView.addArrangedSubview(attatchmentIconButton)
        iconButtonStackView.addArrangedSubview(flagsButton)
        
        updateRoundedCornerButtonPair()

        guard let image = NSImage(named: "swift") else {
            assert(false, "Image is missing")
            return
        }
        
        navtabButton.addIcon(image: image)

        //Global header buttons
        statusButton = UTGlobalHeaderButton()
        statusButton.globalHeaderStyle = .status
        statusButton.title = "Set a status"
        
        backButton = UTGlobalHeaderButton()
        backButton.globalHeaderStyle = .defaultIcon
        backButton.fontIcon = .arrowLeftBold
        
        forwardButton = UTGlobalHeaderButton()
        forwardButton.globalHeaderStyle = .defaultIcon
        forwardButton.fontIcon = .arrowRightBold
        
        plusButton = UTGlobalHeaderButton()
        plusButton.globalHeaderStyle = .defaultIcon
        plusButton.fontIcon = .plusBold
        
        devicesButton = UTGlobalHeaderButton()
        devicesButton.globalHeaderStyle = .devices
        devicesButton.fontIcon = .deviceConnectionBold
        devicesButton.title = "Connect to a device"
        devicesButton.action = #selector(ButtonsTabViewController.deviceButtonAction)
        devicesButton.target = self
        
        globalHeaderStackView.wantsLayer = true
        globalHeaderStackView.layer?.cornerRadius = 8
        globalHeaderStackView.addArrangedSubview(statusButton)
        globalHeaderStackView.addArrangedSubview(backButton)
        globalHeaderStackView.addArrangedSubview(forwardButton)
        globalHeaderStackView.addArrangedSubview(plusButton)
        globalHeaderStackView.addArrangedSubview(devicesButton)
    }
    
    
    private func getTitle() -> String {
        let isEnabled = doubleLength.state == .on
        return isEnabled == true ? "Button Button" : "Button"
    }
    
    private func updateButtons() {
        for (pillButton, size) in pillsButtons {
            pillButton.buttonHeight = size
            pillButton.title = getTitle()
            let details = UTRichTooltipDetails(tooltip: attributedString, size: .medium )
            pillButton.addUTToolTip(toolTip: .rich(details))
        }

       
        for (pillsWithIconButton, size) in pillsWithIconButtons {
            pillsWithIconButton.fontIcon = .videoBold
            pillsWithIconButton.buttonHeight = size
            pillsWithIconButton.title = getTitle()
            let details = UTRichTooltipDetails(tooltip: attributedString, size: .large)
            pillsWithIconButton.addUTToolTip(toolTip: .rich(details))
        }
    
        for (roundIconButton, size) in roundIconButtons {
            roundIconButton.fontIcon = .videoBold
            roundIconButton.buttonHeight = size
            let details = UTRichTooltipDetails(tooltip: attributedString, size: .small)
            roundIconButton.addUTToolTip(toolTip: .rich(details))
        }
    
        for (roundDownArrowButton, size) in roundDownArrowButtons {
            roundDownArrowButton.fontIcon = .videoBold
            roundDownArrowButton.buttonHeight = size
            roundDownArrowButton.title = getTitle()
        }
        
        for (button, size) in roundedCornerButtons {
            button.fontIcon = .videoBold
            button.buttonHeight = size
            button.title = getTitle()
            let details = UTRichTooltipDetails(tooltip: attributedString, size: .large)
            button.addUTToolTip(toolTip: .rich(details))
            button.style = .secondary
        }
  
        for (button, size) in dualIconWithLabelButtons {
            button.size = size
            button.addLHSDetails(accessibilityLabel: "back", icon: .arrowLeftBold)
            button.addRHSDetails(accessibilityLabel: "forward", icon: .arrowRightBold)
            button.addMiddleDetails(accessibilityLabel: getTitle(), title: getTitle())
            button.toolTip = "UTIconDualWithTitleButton"
        }
    }
    
    func updateButtonStyles() {
        buttonStylesStackView.removeAllViews()
        for (style,_) in styles {
            
            let button:UTButton!
            if style == .hyperlink {
                button = UTHyperlinkButton()
            } else {
                button = UTPillButton()
            }
            
            button.style = style
            button.title = getTitle()
            button.toolTip = "UTPillButton"
            buttonStylesStackView.addView(button, in: .leading)
            
           
        }
    }
    
    func updateSplitButtons() {
        dualButtonControlSmall.buttonHeight = .small
        dualButtonControlSmall.addRHSDetails(accessibilityLabel: "accessibilityLabel", iconType: .arrowDownBold)
        dualButtonControlSmall.addLHSDetails(label: getTitle(), accessibilityLabel: "label",iconType: .videoBold )
        dualButtonControlSmall.addUTToolTip(toolTip: .rich(UTRichTooltipDetails(tooltip: attributedString, size: .medium))) 
        
        dualButtonControlMedium.buttonHeight = .medium
        dualButtonControlMedium.addRHSDetails(accessibilityLabel: "accessibilityLabel", iconType: .arrowDownBold)
        dualButtonControlMedium.addLHSDetails(label: getTitle(), accessibilityLabel: "label",iconType: .videoBold )
        dualButtonControlMedium.toolTip = "UTDualButton"
    }
    
    func updateRoundedCornerButtonPair() {
        lhsRoundedCornerButton.buttonHeight = .medium
        lhsRoundedCornerButton.title = "Automatically Optimize"
        lhsRoundedCornerButton.style = .secondary
        lhsRoundedCornerButton.roundSetting = .lhs
        
        rhsRoundedCornerButton.fontIcon = .videoBold
        rhsRoundedCornerButton.buttonHeight = .medium
        rhsRoundedCornerButton.style = .secondary
        rhsRoundedCornerButton.roundSetting = .rhs
    }
    
    
    @IBAction func doubleLenghtAction(_ sender: Any) {
        
        updateButtons()
        updateButtonStyles()
        updateSplitButtons()
    }
    
    @IBAction func deviceButtonAction(_ sender: Any){
        devicesButton.state = devicesButton.state == .on ? .off : .on
        devicesButton.setThemeColors()
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        for tuple  in allButtons {
            if let (button, _) = tuple as? (UTButton,ButtonHeight) {
                button.setThemeColors()
            }
        }
        
        for button in buttonStylesStackView.subviews {
            if let pillButton = button as? UTPillButton {
                pillButton.setThemeColors()
            }
        }
        dualButtonControlSmall.setThemeColors()
        dualButtonControlMedium.setThemeColors()
        
        dualIconButton.setThemeColors()
        largeIconDualButton.setThemeColors()
        
        for (button, _) in dualIconWithLabelButtons {
            button.setThemeColors()
        }
        
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-primary").normal.cgColor

        lhsRoundedCornerButton.setThemeColors()
        rhsRoundedCornerButton.setThemeColors()
        
        iconButtonStackView.setThemeableViewColors()
        globalHeaderStackView.setThemeableViewColors()
        globalHeaderBackgroundView.setThemeColors()
    }
    
    
}

extension ButtonsTabViewController : UTDualButtonDelegate {
    func lhsButtonClicked(sender: UTDualButton, button: UTButton) {
        print("lhsButtonClicked")
    }
    
    func rhsButtonCLicked(sender: UTDualButton, button: UTButton) {
        print("rhsButtonCLicked")
    }
}
