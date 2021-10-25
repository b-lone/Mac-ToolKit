//
//  UTTeamStyle.swift
//  UIToolkit
//
//  Created by James Nestor on 08/10/2021.
//

import Cocoa

@objc public enum UTTeamStyle : Int {
    
    case unknown
    case custom
    case defaultStyle
    case gold
    case orange
    case lime
    case mint
    case cyan
    case cobalt
    case slate
    case violet
    case purple
    case pink
    
    public var avatarColors : UTColorStates {
        switch self {
        case .unknown:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundDefault)
        case .custom:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundDefault)
        case .defaultStyle:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundDefault)
        case .gold:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundGold)
        case .orange:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundOrange)
        case .lime:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundLime)
        case .mint:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundMint)
        case .cyan:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundCyan)
        case .cobalt:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundCobalt)
        case .slate:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundSlate)
        case .violet:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundViolet)
        case .purple:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundPurple)
        case .pink:
            return UIToolkit.shared.getThemeManager().getColors(token: .avatarColorAvatarBackgroundPink)
        }
    }
    
    public var teamMarkerColors : UTColorStates {
        switch self {
        case .unknown:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundDefault)
        case .custom:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundDefault)
        case .defaultStyle:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundDefault)
        case .gold:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundGold)
        case .orange:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundOrange)
        case .lime:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundLime)
        case .mint:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundMint)
        case .cyan:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundCyan)
        case .cobalt:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundCobalt)
        case .slate:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundSlate)
        case .violet:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundViolet)
        case .purple:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundPurple)
        case .pink:
            return UIToolkit.shared.getThemeManager().getColors(token: .teamMarkerBackgroundPink)
        }
    }
}
