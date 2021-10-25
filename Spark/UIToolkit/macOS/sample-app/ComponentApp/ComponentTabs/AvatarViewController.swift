//
//  AvatarViewController.swift
//  ComponentApp
//
//  Created by Jimmy Coyne on 16/06/2021.
//

import Cocoa
import UIToolkit

class AvatarViewController: UTBaseViewController, NSTextFieldDelegate {
    
    @IBOutlet var avatarStackView: NSStackView!
    @IBOutlet var avatarName: NSTextField!
    @IBOutlet var presenseSelection: NSPopUpButton!
    @IBOutlet var avatarOption: NSButton!
    @IBOutlet var intialsOption: NSButton!
    @IBOutlet var selfMessageOption: NSButton!
    @IBOutlet var lockOption: NSButton!
    @IBOutlet var pairOption: NSButton!
    @IBOutlet var exConfOption: NSButton!
    @IBOutlet var scheduledMeetingOption: NSButton!
    
    @IBOutlet var isTypingButton: NSButton!
    //Avatar that is initialised in the xib file and gets updated with
    //changes rather than recreated which tests for updating view
    @IBOutlet var updateAvatarView: UTAvatarView!
    @IBOutlet var overflowStackView: NSStackView!
    
  let avatarSizes = [UTAvatarView.Size.extraExtraLarge, UTAvatarView.Size.extraLarge,UTAvatarView.Size.large, UTAvatarView.Size.medium, UTAvatarView.Size.small, UTAvatarView.Size.extraSmall ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.wantsLayer = true
        
        updateAvatarView.enableHover = true
        updateAvatarView.hoverDelegate = self
    
        avatarName.isEnabled = false
        avatarName.target = self
        avatarName.action = #selector(userNameChange)
        
        presenseSelection.addItem(withTitle: "None")
        presenseSelection.addItem(withTitle: "Active")
        presenseSelection.addItem(withTitle: "Call")
        presenseSelection.addItem(withTitle: "Dnd")
        presenseSelection.addItem(withTitle: "Meeting")
        presenseSelection.addItem(withTitle: "Pto")
        presenseSelection.addItem(withTitle: "Quiet")
        presenseSelection.addItem(withTitle: "Recents")
        presenseSelection.addItem(withTitle: "Meeting")
        presenseSelection.addItem(withTitle: "Scheduled Meeting")
        presenseSelection.addItem(withTitle: "Screen share")
        presenseSelection.addItem(withTitle: "Mobile")
        presenseSelection.addItem(withTitle: "Device")
        refresh()
        
        
        let overflowView1 = UTAvatarOverflowBadge()
        overflowView1.count = 3
        overflowView1.hoverDelegate = self
        
        let overflowView2 = UTAvatarOverflowBadge()
        overflowView2.count = 22
        overflowView2.hoverDelegate = self
        
        let overflowView3 = UTAvatarOverflowBadge()
        overflowView3.count = 33
        overflowView3.hoverDelegate = self
        
        let overflowView4 = UTAvatarOverflowBadge()
        overflowView4.count = 99
        overflowView4.hoverDelegate = self
        
        let overflowView5 = UTAvatarOverflowBadge()
        overflowView5.count = 200
        overflowView5.hoverDelegate = self
        
        let overflowView6 = UTAvatarOverflowBadge()
        overflowView6.count = 10000
        overflowView6.hoverDelegate = self
        
        overflowStackView.addArrangedSubview(overflowView1)
        overflowStackView.addArrangedSubview(overflowView2)
        overflowStackView.addArrangedSubview(overflowView3)
        overflowStackView.addArrangedSubview(overflowView4)
        overflowStackView.addArrangedSubview(overflowView5)
        overflowStackView.addArrangedSubview(overflowView6)
    }
    
    @IBAction func presenceSelectionAction(_ sender: Any) {
        refresh()
    }
    
    @IBAction func avatarTypeChange(_ sender: NSObject) {
        refresh()
    }
    
    @IBAction func userNameChange(_ sender: Any) {
        refresh()
    }
    
    @IBAction func setIsTyping(_ sender: Any) {
        refresh()
    }
    
    func refresh() {
        
        let views = avatarStackView.views
        avatarStackView.removeViews(items: views)
        
        for size in avatarSizes {
            let avatarView = UTAvatarView()

            avatarView.dataSource = getAvatarDataSource(size: size)
            avatarView.enableHover = true
            avatarView.hoverDelegate = self
            avatarView.isTyping = isTypingButton.state == .on
            avatarStackView.addView(avatarView, in: .leading)
        }
        
        updateAvatarView.dataSource = getAvatarDataSource(size: .medium)        
    }
    
    
    override func setThemeColors() {
        super.setThemeColors()
        avatarStackView.setThemeableViewColors()
        overflowStackView.setThemeableViewColors()
        updateAvatarView.setThemeColors()
        view.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "background-primary").normal.cgColor
    }
    
    func getState(state:String) -> UTPresenceState  {
        switch state {
        case "Active": return .active
        case "Call": return .call
        case "Dnd": return .dnd
        case "Meeting": return  .meeting
        case "None": return .none
        case "Pto": return .pto
        case "Quiet": return .quiet
        case "Recents": return .recents
        case "Scheduled Meeting": return .scheduleMeeting
        case "Screen share": return .screenShare
        case "Mobile": return .mobile
        case "Device": return .device
        default:
            return .active
        }
    }
    
    private func getAvatarDataSource(size:UTAvatarView.Size) -> AvatarImageViewDataSourceProtocol{
        var dataSource:AvatarImageViewDataSourceProtocol!
        
        avatarName.isEnabled = intialsOption.state == .on
        let presenceState = getState(state: presenseSelection.selectedItem?.title ?? "None")
        if  intialsOption.state == .on  {
            let avatarBgColor = NSColor(calibratedRed: 147/255.0, green: 32/255.0, blue: 153/255.0, alpha: 1)
            dataSource = AvatarImageViewDataSource(presenceState: presenceState, size: size, name: avatarName.stringValue, bgColor: avatarBgColor)
        } else if avatarOption.state == .on  {
            let cutestDog = NSImage(named: "maya")
            dataSource = AvatarImageViewDataSource(presenceState: presenceState,size: size , avatar: cutestDog!)
        }
        else if lockOption.state == .on {
            dataSource = AvatarImageViewDataSource.initLockAvatar(size: size)
        }
        else if selfMessageOption.state == .on {
            dataSource = AvatarImageViewDataSource.initSelfMessage(size: size)
        }
        else if pairOption.state == .on {
            dataSource = AvatarImageViewDataSource.initPairAvatar(size: size)
        }
        else if exConfOption.state == .on {
            dataSource = AvatarImageViewDataSource.initDefaultExConferenceAvatar(size: size)
        }
        else if scheduledMeetingOption.state == .on {
            dataSource = AvatarImageViewDataSource.initMeetingIconAvatar(size: size)
        }
        
        return dataSource
    }
}

extension AvatarViewController : UTHoverableViewDelegate {
    func isHoveredChanged(sender: UTView, isHovered: Bool) {
        
        if updateAvatarView == sender {
            NSLog("isHoveredChanged for avatar: [\(updateAvatarView.description)] size: [\(updateAvatarView.dataSource.size.rawValue)] isHoverd: [\(isHovered)]")
            return
        }
        
        for view in avatarStackView.views {
            if view == sender {
                if let avatarView = sender as? UTAvatarView {
                    NSLog("isHoveredChanged for avatar: [\(avatarView.description)] size: [\(avatarView.dataSource.size.rawValue)] isHoverd: [\(isHovered)]")
                    return
                }
            }
        }
        
        for view in overflowStackView.views {
            if view == sender {
                if let overflowView = sender as? UTAvatarOverflowBadge {
                    NSLog("isHoveredChanged for Overflow badge: [\(overflowView.description)] count: [\(overflowView.count)] isHoverd: [\(isHovered)]")
                }
            }
        }
    }
}


