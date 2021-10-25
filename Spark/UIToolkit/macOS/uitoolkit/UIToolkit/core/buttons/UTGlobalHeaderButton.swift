//
//  UTGlobalHeaderButton.swift
//  UIToolkit
//
//  Created by James Nestor on 09/09/2021.
//

import Cocoa

public class UTGlobalHeaderButton : UTBaseButton {
    
    public enum Style {
        
        case devices
        case status
        case defaultIcon
        case cancelSearch
        
        //Global header buttons will need their own tokens for co branding
        func getBackgroundToken(on: Bool) -> String {
            switch self {
            case .devices:
                return UIToolkit.shared.isUsingLegacyTokens ? "appHeader-buttonDevice" : UTColorTokens.globalHeaderButtonDeviceBackground.rawValue
            case .status:
                return UIToolkit.shared.isUsingLegacyTokens ? "appHeader-buttonStatus" : UTColorTokens.globalHeaderButtonStatusBackground.rawValue
            case .defaultIcon:
                return UIToolkit.shared.isUsingLegacyTokens ? "appHeader-buttonPlus" : UTColorTokens.globalHeaderButtonIconBackground.rawValue
            case .cancelSearch:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-ghCancelSearchButton" : UTColorTokens.buttonSecondaryBackground.rawValue
            }
        }
                
        func getFontToken(on: Bool) -> String  {
            switch self {
            case .devices:
                if on {
                    return UIToolkit.shared.isUsingLegacyTokens ? "appHeader-buttonDevice-text-active" : UTColorTokens.globalHeaderButtonDeviceTextActive.rawValue
                }
                return UIToolkit.shared.isUsingLegacyTokens ? "appHeader-text" : UTColorTokens.globalHeaderButtonDeviceTextInactive.rawValue
            case .status:
                return UIToolkit.shared.isUsingLegacyTokens ? "appHeader-text" : UTColorTokens.globalHeaderButtonStatusText.rawValue
            case .defaultIcon:
                return UIToolkit.shared.isUsingLegacyTokens ? "appHeader-buttonPlus-icon" : UTColorTokens.globalHeaderButtonIconIcon.rawValue
            case .cancelSearch:
                return UIToolkit.shared.isUsingLegacyTokens ? "wx-ghCancelSearchButton-text" : UTColorTokens.globalHeaderSearchCancelButtonText.rawValue
            }
        }
        
        func getBorderToken() -> String{
            switch self {
            case .cancelSearch:
                return UIToolkit.shared.isUsingLegacyTokens ? "" : UTColorTokens.globalHeaderSearchCancelButtonBorder.rawValue
            default:
                return ""
            }
        }
    }
    
    override func initialise(){
        super.buttonHeight = .small
        super.buttonType = .pill
        self.globalHeaderStyle = .devices
        self.fontIconSize = 16
        self.labelFont = .subheaderSecondary
        super.initialise()
    }
    
    public var globalHeaderStyle: Style = .devices{
        didSet{
            if globalHeaderStyle == .defaultIcon {
                buttonType = .round
            }
            else {
                //Device can be pill or round
                buttonType = .pill
            }
            
            setThemeColors()
        }
    }
    
    internal override func setTokensFromStyle() {
        
        if globalHeaderStyle.getBackgroundToken(on: state == .on) != backgroundTokenName {
            backgroundTokenName = globalHeaderStyle.getBackgroundToken(on: state == .on)
        }
        
        if globalHeaderStyle.getFontToken(on: state == .on) != fontTokenName {
            fontTokenName = globalHeaderStyle.getFontToken(on: state == .on)
        }
        
        if globalHeaderStyle.getFontToken(on: state == .on) != iconTokenName {
            iconTokenName = globalHeaderStyle.getFontToken(on: state == .on)
        }
        
        if globalHeaderStyle.getBorderToken() != borderTokenName {
            borderTokenName = globalHeaderStyle.getBorderToken()
        }
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        switch height {
        default:
            return 28
        }
    }
    
}
