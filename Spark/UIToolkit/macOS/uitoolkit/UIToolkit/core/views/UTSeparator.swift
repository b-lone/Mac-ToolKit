//
//  UTSeparator.swift
//  UIToolkit
//
//  Created by James Nestor on 04/06/2021.
//

import Cocoa

public class UTSeparatorView: UTView {
    
    public enum Style {
        case primary
        case secondary
        case defaultNormal
        case defaultFocus
        case classifiedNormal
        case classifiedFocus
        case externalNormal
        case externalFocus
        case announcementNormal
        case announcementFocus
        

        var colorToken: String {
            switch self {
            case .primary:
                return UTColorTokens.separatorPrimary.rawValue
            case .secondary:
                return UTColorTokens.separatorSecondary.rawValue
            case .defaultNormal:
                return UTColorTokens.separatorSecondary.rawValue
            case .defaultFocus:
                return UTColorTokens.separatorPrimary.rawValue
            case .classifiedNormal:
                return UTColorTokens.separatorError1.rawValue
            case .classifiedFocus:
                return UTColorTokens.separatorError0.rawValue
            case .externalNormal:
                return UTColorTokens.separatorWarn1.rawValue
            case .externalFocus:
                return UTColorTokens.separatorWarn0.rawValue
            case .announcementNormal:
                return UTColorTokens.separatorAnnounce1.rawValue
            case .announcementFocus:
                return UTColorTokens.separatorAnnounce0.rawValue
            }
        }
    }
    
    ///The style of the separator. The correct colour tokens will
    ///be picked based on the separator style
    public var style: Style = .primary {
        didSet {
            setThemeColors()
        }
    }
    
    private var color: CCColor{
        if style == .primary {
            return UIToolkit.shared.getThemeManager().getColors(tokenName: style.colorToken).normal
        }
        
        return UIToolkit.shared.getThemeManager().getColors(tokenName: style.colorToken).normal
    }
    
    public override func setThemeColors() {
        self.layer?.backgroundColor = color.cgColor
    }
}
