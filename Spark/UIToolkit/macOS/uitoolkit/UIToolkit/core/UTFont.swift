//
//  UTFont.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 04/05/2021.
//

import Cocoa

public enum UTFontType : CaseIterable {
    
    /// 40 semibold
    case display
    
    /// 26 bold
    case bannerTertiary
    
    /// 26 semibold
    case bannerPrimary
    
    /// 26 regular
    case bannerSecondary
    
    /// 20 semibold
    case title
    
    /// 16 bold
    case headerPrimary
    
    /// 16 bold
    case highlightPrimary
    
    /// 16 semibold
    case subheaderPrimary
    
    /// 16 regular
    case bodyPrimary
    
    /// 16 regular (underline)
    case hyperlinkPrimary
    
    /// 14 semibold
    case subheaderSecondary
    
    /// 14 bold
    case highlightSecondary
    
    /// 14 bold
    case headerSecondary
    
    /// 14 regular
    case bodySecondary
    
    /// 14 regular (underline)
    case hyperlinkSecondary
    
    /// 12 bold
    case highlightCompact
    
    /// 12 regular
    case bodyCompact
    
    /// 12 semibold
    case labelCompact
    
    public func font() -> NSFont {
        return UTCoreFont.getFont(size: self.size, weight: self.weight)
    }
    
    public var tokenName: String {
        
        switch self {
        case .display:
            return "display"
        case .bannerTertiary:
            return "banner-tertiary"
        case .bannerPrimary:
            return "banner-primary"
        case .bannerSecondary:
            return "banner-secondary"
        case .title:
            return "title"
        case .headerPrimary:
            return "header-primary"
        case .highlightPrimary:
            return "highlight-primary"
        case .subheaderPrimary:
            return "subheader-primary"
        case .bodyPrimary:
            return "body-primary"
        case .hyperlinkPrimary:
            //Underlined
            return "hyperlink-primary"
        case .subheaderSecondary:
            return "subheader-secondary"
        case .highlightSecondary:
            return "highlight-secondary"
        case .headerSecondary:
            return "header-secondary"
        case .bodySecondary:
            return "body-secondary"
        case .hyperlinkSecondary:
            //Underlined
            return "hyperlink-secondary"
        case .highlightCompact:
            return "highlight-compact"
        case .bodyCompact:
            return "body-compact"
        case .labelCompact:
            return "label-compact"
        }
    }
    
    public var weightString: String {
        return weight.stringValue
    }
    
    public var sizeString:String {
        return size.rawValue.description
    }
    
    var weight:UTCoreFont.Weight {
        switch self {
        case .display:
            return .semibold
        case .bannerTertiary:
            return .bold
        case .bannerPrimary:
            return .semibold
        case .bannerSecondary:
            return .regular
        case .title:
            return .semibold
        case .headerPrimary:
            return .bold
        case .highlightPrimary:
            return .bold
        case .subheaderPrimary:
            return .semibold
        case .bodyPrimary:
            return .regular
        case .hyperlinkPrimary:
            //Underlined
            return .regular
        case .subheaderSecondary:
            return .semibold
        case .highlightSecondary:
            return .bold
        case .headerSecondary:
            return .bold
        case .bodySecondary:
            return .regular
        case .hyperlinkSecondary:
            //Underlined
            return .regular
        case .highlightCompact:
            return .bold
        case .bodyCompact:
            return .regular
        case .labelCompact:
            return .semibold
        }
    }
    
    var size:UTCoreFont.Size {
        switch self {
        case .display:
            return .extraLarge
        case .bannerTertiary:
            return .large
        case .bannerPrimary:
            return .large
        case .bannerSecondary:
            return .large
        case .title:
            return .medium
        case .headerPrimary:
            return .mediumSmall
        case .highlightPrimary:
            return .mediumSmall
        case .subheaderPrimary:
            return .mediumSmall
        case .bodyPrimary:
            return .mediumSmall
        case .hyperlinkPrimary:
            //Underlined
            return .mediumSmall
        case .subheaderSecondary:
            return .small
        case .highlightSecondary:
            return .small
        case .headerSecondary:
            return .small
        case .bodySecondary:
            return .small
        case .hyperlinkSecondary:
            //Underlined
            return .small
        case .highlightCompact:
            return .extraSmall
        case .bodyCompact:
            return .extraSmall
        case .labelCompact:
            return .extraSmall
        }
    }
    
}
