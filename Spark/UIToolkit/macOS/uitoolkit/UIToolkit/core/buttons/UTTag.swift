//
//  UTTag.swift
//  UIToolkit
//
//  Created by James Nestor on 16/09/2021.
//

import Cocoa

public class UTTag: UTBaseButton {
    
    public enum Style {
        case staticTag
        case overlay
        case primary
        case cobalt
        case lime
        case mint
        case slate
        case violet
        case purple
        case orange
        case gold
        
        var backgroundToken:String {
            switch self {
            case .staticTag:
                return UTColorTokens.tagStaticBackground.rawValue
            case .overlay:
                return UTColorTokens.tagOverlayBackground.rawValue
            case .primary:
                return UTColorTokens.tagPrimaryBackground.rawValue
            case .cobalt:
                return UTColorTokens.tagCobaltBackground.rawValue
            case .lime:
                return UTColorTokens.tagLimeBackground.rawValue
            case .mint:
                return UTColorTokens.tagMintBackground.rawValue
            case .slate:
                return UTColorTokens.tagSlateBackground.rawValue
            case .violet:
                return UTColorTokens.tagVioletBackground.rawValue
            case .purple:
                return UTColorTokens.tagPurpleBackground.rawValue
            case .orange:
                return UTColorTokens.tagOrangeBackground.rawValue
            case .gold:
                return UTColorTokens.tagGoldBackground.rawValue
            }
        }
                
        var fontToken:String {
            switch self {
            case .staticTag:
                return UTColorTokens.tagStaticText.rawValue
            case .overlay:
                return UTColorTokens.tagOverlayText.rawValue
            case .primary:
                return UTColorTokens.tagPrimaryText.rawValue
            case .cobalt:
                return UTColorTokens.tagCobaltText.rawValue
            case .lime:
                return UTColorTokens.tagLimeText.rawValue
            case .mint:
                return UTColorTokens.tagMintText.rawValue
            case .slate:
                return UTColorTokens.tagSlateText.rawValue
            case .violet:
                return UTColorTokens.tagVioletText.rawValue
            case .purple:
                return UTColorTokens.tagPurpleText.rawValue
            case .orange:
                return UTColorTokens.tagOrangeText.rawValue
            case .gold:
                return UTColorTokens.tagGoldText.rawValue
            }
        }
        
        var borderToken: String{
            switch self {
            case .staticTag:
                return UTColorTokens.tagStaticBorder.rawValue
            case .overlay:
                return UTColorTokens.tagOverlayBorder.rawValue
            case .primary:
                return UTColorTokens.tagPrimaryBorder.rawValue
            case .cobalt:
                return UTColorTokens.tagCobaltBorder.rawValue
            case .lime:
                return UTColorTokens.tagLimeBorder.rawValue
            case .mint:
                return UTColorTokens.tagMintBorder.rawValue
            case .slate:
                return UTColorTokens.tagSlateBorder.rawValue
            case .violet:
                return UTColorTokens.tagVioletBorder.rawValue
            case .purple:
                return UTColorTokens.tagPurpleBorder.rawValue
            case .orange:
                return UTColorTokens.tagOrangeBorder.rawValue
            case .gold:
                return UTColorTokens.tagGoldBorder.rawValue
            }
        }
    }
    
    public var style:Style = .primary {
        didSet {
            setThemeColors()
        }
    }

    override func initialise(){        
        super.buttonType = .rounded
        super.initialise()
    }
    
    override func toCGFloat(height: ButtonHeight) -> CGFloat {
        return 24
    }
    
    override var trailingPadding:CGFloat {
        return 8
    }
    
    override var leadingPadding:CGFloat {
        return 8
    }
    
    override public func updateCorners() {
        layer?.cornerRadius =  4
    }
    
    override func updateLabelFontSize() {
        self.labelFont = .subheaderSecondary
    }
    
    override func setTokensFromStyle() {
        
        if style.backgroundToken != backgroundTokenName {
            backgroundTokenName = style.backgroundToken
        }
        
        if style.fontToken != fontTokenName {
            fontTokenName = style.fontToken
        }
                
        if style.borderToken != borderTokenName {
            borderTokenName = style.borderToken
        }
    }
    
}
