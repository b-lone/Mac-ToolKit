//
//  AlertsVC.swift
//  ComponentApp
//
//  Created by James Nestor on 17/06/2021.
//

import Cocoa
import UIToolkit

class AlertsVC: UTBaseViewController {

    @IBOutlet var lhsStackView: NSStackView!
    @IBOutlet var rhsStackView: NSStackView!
    @IBOutlet var alertBadgeStackView: NSStackView!
    
    private var successTwoLineAlert:UTAlertBanner!
    private var errorTwoLineAlert:UTAlertBanner!
    private var warningTwoLineAlert:UTAlertBanner!
    private var generalTwoLineAlert:UTAlertBanner!
    private var transientTwoLineAlert:UTAlertBanner!
    
    @IBOutlet var twoLineCloseStackView: NSStackView!
    @IBOutlet var successTwoLineAlertWithClose: UTAlertBanner!
    @IBOutlet var errorTwoLineAlertWithClose: UTAlertBanner!
    @IBOutlet var warningTwoLineAlertWithClose: UTAlertBanner!
    @IBOutlet var generalTwoLineAlertWithClose: UTAlertBanner!
    
    @IBOutlet var sep: UTGradientSeparator!
    @IBOutlet var focus: UTGradientSeparator!
    @IBOutlet var warn: UTGradientSeparator!
    @IBOutlet var error: UTGradientSeparator!
    
    private var successAlert:UTAlertBanner!
    private var errorAlert:UTAlertBanner!
    private var warningAlert:UTAlertBanner!
    private var generalAlert:UTAlertBanner!
    private var transientAlert:UTAlertBanner!
    
    private var successAlertCentred:UTAlertBanner!
    private var errorAlertCentred:UTAlertBanner!
    private var warningAlertCentred:UTAlertBanner!
    private var generalAlertCentred:UTAlertBanner!
    private var transientAlertCentred:UTAlertBanner!
        
    private var defaultBadge:UTAlertBadge!
    private var announcementBadge:UTAlertBadge!
    private var alertWarningBadge:UTAlertBadge!
    private var importantBadge:UTAlertBadge!
    private var alertGeneralBadge:UTAlertBadge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
        lhsStackView.edgeInsets = NSEdgeInsets(top: 16, left: 16, bottom: 0, right: 0)
                
        //alertTwoLineText
        successTwoLineAlert   = UTAlertBanner(stringValue:LocalizationStrings.alertTwoLineText, validationState:.success)
        errorTwoLineAlert     = UTAlertBanner(stringValue:LocalizationStrings.alertTwoLineText, validationState:.error)
        warningTwoLineAlert   = UTAlertBanner(stringValue:LocalizationStrings.alertTwoLineText, validationState:.warning)
        generalTwoLineAlert   = UTAlertBanner(stringValue:LocalizationStrings.alertTwoLineText, validationState:.general)
        transientTwoLineAlert = UTAlertBanner(stringValue:LocalizationStrings.alertTwoLineText, validationState:.transient)
        
        successTwoLineAlertWithClose.configure(stringValue: LocalizationStrings.alertTwoLineText, validationState: .success, wantsCloseButton: true, isCentred: false, style: .rounded)
        errorTwoLineAlertWithClose.configure(stringValue: LocalizationStrings.alertTwoLineText,   validationState: .error,   wantsCloseButton: true, isCentred: false, style: .rounded)
        warningTwoLineAlertWithClose.configure(stringValue: LocalizationStrings.alertTwoLineText, validationState: .warning, wantsCloseButton: true, isCentred: false, style: .rounded)
        generalTwoLineAlertWithClose.configure(stringValue: LocalizationStrings.alertTwoLineText, validationState: .general, wantsCloseButton: true, isCentred: false, style: .rounded)
        
        lhsStackView.addArrangedSubview(successTwoLineAlert)
        lhsStackView.addArrangedSubview(errorTwoLineAlert)
        lhsStackView.addArrangedSubview(warningTwoLineAlert)
        lhsStackView.addArrangedSubview(generalTwoLineAlert)
        lhsStackView.addArrangedSubview(transientTwoLineAlert)
        
        rhsStackView.edgeInsets = NSEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        successAlert   = UTAlertBanner(stringValue:LocalizationStrings.success,        validationState:.success,   wantsCloseButton:true, style: .pill)
        errorAlert     = UTAlertBanner(stringValue:LocalizationStrings.error,          validationState:.error,     wantsCloseButton:true, style: .pill)
        warningAlert   = UTAlertBanner(stringValue:LocalizationStrings.warning,        validationState:.warning,   wantsCloseButton:true, style: .pill)
        generalAlert   = UTAlertBanner(stringValue:LocalizationStrings.generalInfo,    validationState:.general,   wantsCloseButton:true, style: .pill)
        transientAlert = UTAlertBanner(stringValue:LocalizationStrings.transientState, validationState:.transient, wantsCloseButton:true, style: .pill)
        
        // horizontal gradient separators
        sep.style = .normal
        error.style = .error
        
        // vertical gradient separators
        focus.style = .focused
        focus.direction = .vertical
        warn.style = .warn
        warn.direction = .vertical
        
        rhsStackView.addArrangedSubview(successAlert)
        rhsStackView.addArrangedSubview(errorAlert)
        rhsStackView.addArrangedSubview(warningAlert)
        rhsStackView.addArrangedSubview(generalAlert)
        rhsStackView.addArrangedSubview(transientAlert)
        
        // Centred
        successAlertCentred   = UTAlertBanner(stringValue:LocalizationStrings.success,        validationState:.success,   isCentred: true, style: .pill)
        errorAlertCentred     = UTAlertBanner(stringValue:LocalizationStrings.error,          validationState:.error,     isCentred: true, style: .pill)
        warningAlertCentred   = UTAlertBanner(stringValue:LocalizationStrings.warning,        validationState:.warning,   isCentred: true, style: .pill)
        generalAlertCentred   = UTAlertBanner(stringValue:LocalizationStrings.generalInfo,    validationState:.general,   isCentred: true, style: .pill)
        transientAlertCentred = UTAlertBanner(stringValue:LocalizationStrings.transientState, validationState:.transient, isCentred: true, style: .pill)
        
        rhsStackView.addArrangedSubview(successAlertCentred)
        rhsStackView.addArrangedSubview(errorAlertCentred)
        rhsStackView.addArrangedSubview(warningAlertCentred)
        rhsStackView.addArrangedSubview(generalAlertCentred)
        rhsStackView.addArrangedSubview(transientAlertCentred)
        
        
        defaultBadge      = UTAlertBadge(style: .defaultBadge, iconType: .hideBold,         title: LocalizationStrings.alertLabel)
        announcementBadge = UTAlertBadge(style: .announcement, iconType: .announcementBold, title: LocalizationStrings.alertLabel)
        alertWarningBadge = UTAlertBadge(style: .alertWarning, iconType: .externalUserBold, title: LocalizationStrings.alertLabel)
        importantBadge    = UTAlertBadge(style: .important,    iconType: .shieldBold,       title: LocalizationStrings.alertLabel)
        alertGeneralBadge = UTAlertBadge(style: .alertGeneral, iconType: .blockedBold,      title: LocalizationStrings.alertLabel)
        
        alertBadgeStackView.addArrangedSubview(defaultBadge)
        alertBadgeStackView.addArrangedSubview(announcementBadge)
        alertBadgeStackView.addArrangedSubview(alertWarningBadge)
        alertBadgeStackView.addArrangedSubview(importantBadge)
        alertBadgeStackView.addArrangedSubview(alertGeneralBadge)
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        self.view.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-primary").normal.cgColor
        lhsStackView.setThemeableViewColors()
        rhsStackView.setThemeableViewColors()
        alertBadgeStackView.setThemeableViewColors()
        twoLineCloseStackView.setThemeableViewColors()
    }
    
    override func onLanguageChanged() {
        successTwoLineAlert.labelString   = LocalizationStrings.alertTwoLineText
        errorTwoLineAlert.labelString     = LocalizationStrings.alertTwoLineText
        warningTwoLineAlert.labelString   = LocalizationStrings.alertTwoLineText
        generalTwoLineAlert.labelString   = LocalizationStrings.alertTwoLineText
        transientTwoLineAlert.labelString = LocalizationStrings.alertTwoLineText
        
        successAlert.labelString   = LocalizationStrings.success
        errorAlert.labelString     = LocalizationStrings.error
        warningAlert.labelString   = LocalizationStrings.warning
        generalAlert.labelString   = LocalizationStrings.generalInfo
        transientAlert.labelString = LocalizationStrings.transientState
        
        successAlertCentred.labelString   = LocalizationStrings.success
        errorAlertCentred.labelString     = LocalizationStrings.error
        warningAlertCentred.labelString   = LocalizationStrings.warning
        generalAlertCentred.labelString   = LocalizationStrings.generalInfo
        transientAlertCentred.labelString = LocalizationStrings.transientState
        
        defaultBadge.stringValue      = LocalizationStrings.alertLabel
        announcementBadge.stringValue = LocalizationStrings.alertLabel
        alertWarningBadge.stringValue = LocalizationStrings.alertLabel
        importantBadge.stringValue    = LocalizationStrings.alertLabel
        alertGeneralBadge.stringValue = LocalizationStrings.alertLabel
    }
    
}
