//
//  TeamsViewController.swift
//  ComponentApp
//
//  Created by James Nestor on 11/10/2021.
//

import Cocoa
import UIToolkit

class TeamsViewController: UTBaseViewController {
    
    @IBOutlet var backgroundView: UTBackgroundView!
    @IBOutlet var mediumStackView: NSStackView!
    @IBOutlet var largeStackView: NSStackView!
    @IBOutlet var compactStackView: NSStackView!
    
    @IBOutlet var actionableLabelStackView: NSStackView!
    @IBOutlet var smallActionLabel: UTTeamLabel!
    @IBOutlet var mediumActionLabel: UTTeamLabel!
    @IBOutlet var largeActionLabel: UTTeamLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.style = .solidPrimary
        
        //medium - bodysecondary
        //large  - bodayprimary
        //small  - bodycomact

        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .defaultStyle))
        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .gold))
        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .orange))
        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .lime))
        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .mint))
        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .cyan))
        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .cobalt))
        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .slate))
        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .violet))
        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .purple))
        mediumStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .medium, style: .pink))
        
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .defaultStyle))
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .gold))
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .orange))
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .lime))
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .mint))
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .cyan))
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .cobalt))
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .slate))
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .violet))
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .purple))
        largeStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .large, style: .pink))
        
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .defaultStyle))
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .gold))
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .orange))
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .lime))
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .mint))
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .cyan))
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .cobalt))
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .slate))
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .violet))
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .purple))
        compactStackView.addArrangedSubview(UTTeamLabel(stringValue: "Team", size: .small, style: .pink))
        
        
        smallActionLabel.size = .small
        smallActionLabel.style = .cobalt
        smallActionLabel.isActionable = true
        smallActionLabel.teamLabelDeleage = self
        
        mediumActionLabel.size = .medium
        mediumActionLabel.style = .cyan
        mediumActionLabel.isActionable = true
        mediumActionLabel.teamLabelDeleage = self
        
        largeActionLabel.size = .large
        largeActionLabel.style = .orange
        largeActionLabel.isActionable = true
        largeActionLabel.teamLabelDeleage = self
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        
        mediumStackView.setThemeableViewColors()
        largeStackView.setThemeableViewColors()
        compactStackView.setThemeableViewColors()
    }
    
}

extension TeamsViewController : UTTeamLabelDelegate {
    func onLabelActioned(sender: UTTeamLabel) {
        NSLog("label action from \(sender.description)")
    }
}
