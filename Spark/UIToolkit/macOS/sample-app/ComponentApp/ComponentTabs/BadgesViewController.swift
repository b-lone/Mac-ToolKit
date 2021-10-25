//
//  BadgesViewController.swift
//  ComponentApp
//
//  Created by James Nestor on 18/05/2021.
//

import Cocoa
import UIToolkit

class BadgesViewController: UTBaseViewController {
    
    @IBOutlet var badgeCountStackView: NSStackView!
    
    @IBOutlet var shortcutKeyStackView: NSStackView!
    @IBOutlet var indicatorBadge: UTIndicatorBadge!
    
    @IBOutlet var unreadButton: NSButton!
    @IBOutlet var mentionButton: NSButton!
    @IBOutlet var alertButton: NSButton!
    @IBOutlet var muteButton: NSButton!
    @IBOutlet var newlyAddedButton: NSButton!
    @IBOutlet var outgoingCallButton: NSButton!
    
    @IBOutlet var unreadIndicatorBadge: UTIndicatorBadge!
    @IBOutlet var mentionIndicatorBadge: UTIndicatorBadge!
    @IBOutlet var alertIndicatorBadge: UTIndicatorBadge!
    @IBOutlet var muteIndicatorBadge: UTIndicatorBadge!
    @IBOutlet var newlyAddedBadge: UTIndicatorBadge!
    @IBOutlet var outgoingCallBadge: UTIndicatorBadge!
    
    @IBOutlet var shortcutsStackView: UTShortcutStackView!
    @IBOutlet var shortcutsStackView2: UTShortcutStackView!
    @IBOutlet var shortcutsStackView3: UTShortcutStackView!
    
    @IBOutlet var multilineStackView: NSStackView!
    @IBOutlet var tagStackView: NSStackView!
    @IBOutlet var chipStackView: NSStackView!
    @IBOutlet var teamMarkerStackView: NSStackView!
    
    deinit{
        NSLog("deinit BadgesViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        
        unreadIndicatorBadge.badgeType  = .unread
        mentionIndicatorBadge.badgeType = .mention
        alertIndicatorBadge.badgeType   = .alert
        muteIndicatorBadge.badgeType    = .muted
        newlyAddedBadge.badgeType       = .newlyAdded
        outgoingCallBadge.badgeType     = .outgoingCall
        
        let shortcutKey1 = UTShortcutKeyLabel(shortcutString: "⌘")
        let shortcutKey2 = UTShortcutKeyLabel(shortcutString: "SHIFT")
        let shortcutKey3 = UTShortcutKeyLabel(shortcutString: "B")
        
        shortcutKeyStackView.addView(shortcutKey1, in: .leading)
        shortcutKeyStackView.addView(shortcutKey2, in: .leading)
        shortcutKeyStackView.addView(shortcutKey3, in: .leading)
        
        shortcutsStackView.addShortcutKeys(shortcutStrings: ["⌘", "SHIFT", "B"])
        shortcutsStackView2.addShortcutKeys(shortcutStrings: ["⌘", "⌥", "/"])
        shortcutsStackView3.addShortcutKeys(shortcutStrings: ["⌘", "Y"])
        
        let multilineChip1 = UTMultilineChip()
        multilineChip1.style = .one
        multilineChip1.title = "L1"
        
        let multilineChip2 = UTMultilineChip()
        multilineChip2.style = .two
        multilineChip2.title = "L2"
        
        let multilineChip3 = UTMultilineChip()
        multilineChip3.style = .three
        multilineChip3.title = "L3"
        
        let multilineChip4 = UTMultilineChip()
        multilineChip4.style = .four
        multilineChip4.title = "L4"
        
        let multilineChip5 = UTMultilineChip()
        multilineChip5.style = .five
        multilineChip5.title = "L5"
        
        let multilineChip6 = UTMultilineChip()
        multilineChip6.style = .six
        multilineChip6.title = "L6"
        
        let multilineChip7 = UTMultilineChip()
        multilineChip7.style = .seven
        multilineChip7.title = "L7"
        
        let multilineChip8 = UTMultilineChip()
        multilineChip8.style = .eight
        multilineChip8.title = "L8"
        
        multilineStackView.addArrangedSubview(multilineChip1)
        multilineStackView.addArrangedSubview(multilineChip2)
        multilineStackView.addArrangedSubview(multilineChip3)
        multilineStackView.addArrangedSubview(multilineChip4)
        multilineStackView.addArrangedSubview(multilineChip5)
        multilineStackView.addArrangedSubview(multilineChip6)
        multilineStackView.addArrangedSubview(multilineChip7)
        multilineStackView.addArrangedSubview(multilineChip8)
        
        let tag1 = UTTag()
        tag1.title = "Static"
        tag1.style = .staticTag
        
        let tag2 = UTTag()
        tag2.title = "Overlay"
        tag2.style = .overlay
        
        let tag3 = UTTag()
        tag3.title = "Primary"
        tag3.style = .primary
        
        let tag4 = UTTag()
        tag4.title = "Cobalt"
        tag4.style = .cobalt
        
        let tag5 = UTTag()
        tag5.title = "Lime"
        tag5.style = .lime
        
        let tag6 = UTTag()
        tag6.title = "Mint"
        tag6.style = .mint
        
        let tag7 = UTTag()
        tag7.title = "Slate"
        tag7.style = .slate
        
        let tag8 = UTTag()
        tag8.title = "Violet"
        tag8.style = .violet
        
        let tag9 = UTTag()
        tag9.title = "Purple"
        tag9.style = .purple
        
        let tag10 = UTTag()
        tag10.title = "Orange"
        tag10.style = .orange
        
        let tag11 = UTTag()
        tag11.title = "Gold"
        tag11.style = .gold

        tagStackView.addArrangedSubview(tag1)
        tagStackView.addArrangedSubview(tag2)
        tagStackView.addArrangedSubview(tag3)
        tagStackView.addArrangedSubview(tag4)
        tagStackView.addArrangedSubview(tag5)
        tagStackView.addArrangedSubview(tag6)
        tagStackView.addArrangedSubview(tag7)
        tagStackView.addArrangedSubview(tag8)
        tagStackView.addArrangedSubview(tag9)
        tagStackView.addArrangedSubview(tag10)
        tagStackView.addArrangedSubview(tag11)
        
        let chip1 = UTChip()
        chip1.style = .secondary
        chip1.title = "Filter label"
        chip1.fontIcon = .filterBold
        
        let chip2 = UTChip()
        chip2.style = .message
        chip2.title = "Chip label"
        chip2.fontIcon = .cancelBold
        
        chipStackView.addArrangedSubview(chip1)
        chipStackView.addArrangedSubview(chip2)
        
        let teamMarker1 = UTTeamMarker()
        teamMarker1.style = .defaultStyle
        
        let teamMarker2 = UTTeamMarker()
        teamMarker2.style = .gold
        
        let teamMarker3 = UTTeamMarker()
        teamMarker3.style = .orange
        
        let teamMarker4 = UTTeamMarker()
        teamMarker4.style = .lime
        
        let teamMarker5 = UTTeamMarker()
        teamMarker5.style = .mint
        
        let teamMarker6 = UTTeamMarker()
        teamMarker6.style = .cyan
        
        let teamMarker7 = UTTeamMarker()
        teamMarker7.style = .cobalt
        
        let teamMarker8 = UTTeamMarker()
        teamMarker8.style = .slate
        
        let teamMarker9 = UTTeamMarker()
        teamMarker9.style = .violet
        
        let teamMarker10 = UTTeamMarker()
        teamMarker10.style = .purple
        
        let teamMarker11 = UTTeamMarker()
        teamMarker11.style = .pink
        
        teamMarkerStackView.addArrangedSubview(teamMarker1)
        teamMarkerStackView.addArrangedSubview(teamMarker2)
        teamMarkerStackView.addArrangedSubview(teamMarker3)
        teamMarkerStackView.addArrangedSubview(teamMarker4)
        teamMarkerStackView.addArrangedSubview(teamMarker5)
        teamMarkerStackView.addArrangedSubview(teamMarker6)
        teamMarkerStackView.addArrangedSubview(teamMarker7)
        teamMarkerStackView.addArrangedSubview(teamMarker8)
        teamMarkerStackView.addArrangedSubview(teamMarker9)
        teamMarkerStackView.addArrangedSubview(teamMarker10)
        teamMarkerStackView.addArrangedSubview(teamMarker11)
        
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        self.view.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-secondary").normal.cgColor
        
        indicatorBadge.setThemeColors()
        
        unreadIndicatorBadge.setThemeColors()
        mentionIndicatorBadge.setThemeColors()
        alertIndicatorBadge.setThemeColors()
        muteIndicatorBadge.setThemeColors()
        newlyAddedBadge.setThemeColors()
        outgoingCallBadge.setThemeColors()
        
        for view in badgeCountStackView.views{
            if let badge = view as? ThemeableProtocol{
                badge.setThemeColors()
            }
        }
        
        for view in shortcutKeyStackView.views{
            if let v = view as? ThemeableProtocol{
                v.setThemeColors()
            }
        }
        
        shortcutsStackView.setThemeColors()
        shortcutsStackView2.setThemeColors()
        shortcutsStackView3.setThemeColors()
        
        multilineStackView.setThemeableViewColors()
        tagStackView.setThemeableViewColors()
        chipStackView.setThemeableViewColors()
        teamMarkerStackView.setThemeableViewColors()
    }
    
    @IBAction func badgeTypeRadioButtonAction(_ sender: Any) {
        guard let button = sender as? NSButton else { return }
        
        if button == unreadButton {
            indicatorBadge.badgeType = .unread
        }
        else if button == mentionButton {
            indicatorBadge.badgeType = .mention
        }
        else if button == alertButton {
            indicatorBadge.badgeType = .alert
        }
        else if button == muteButton {
            indicatorBadge.badgeType = .muted
        }
        else if button == newlyAddedButton {
            indicatorBadge.badgeType = .newlyAdded
        }
        else if button == outgoingCallButton {
            indicatorBadge.badgeType = .outgoingCall
        }
    }
    
    @IBAction func isSelectedCheckBox(_ sender: Any) {
        guard let checkbox = sender as? NSButton else { return }
        
        unreadIndicatorBadge.isSelected  = checkbox.state == .on
        mentionIndicatorBadge.isSelected = checkbox.state == .on
        alertIndicatorBadge.isSelected   = checkbox.state == .on
        muteIndicatorBadge.isSelected    = checkbox.state == .on
        newlyAddedBadge.isSelected       = checkbox.state == .on
        outgoingCallBadge.isSelected     = checkbox.state == .on
    }
    
}
