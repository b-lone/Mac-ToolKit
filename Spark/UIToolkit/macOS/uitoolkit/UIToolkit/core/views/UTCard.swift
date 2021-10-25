//
//  UTCard.swift
//  UIToolkit
//
//  Created by Michelle Mulcair on 17/09/2021.
//

import Cocoa

public enum MeetingStatus {
    case active
    case cancelled
    case inactive
}

public enum MeetingMarkerType {
    case accepted
    case tentative
    case none
}

public class UTCard: UTView {
    
    public var status: MeetingStatus = .active {
        didSet {
            updateView()
        }
    }
    
    public var markerType: MeetingMarkerType = .accepted {
        didSet {
            updateView()
        }
    }
    
    public var hasBorder: Bool = false {
        didSet {
            updateView()
        }
    }
    
    private var backgroundColorToken:String {
        switch status {
        case .active:
            return "card-active-background"
        case .cancelled:
            return "card-cancelled-background"
        case .inactive:
            return "card-inactive-background"
        }
    }

    private var meetingMarkerView: UTMeetingMarkerView!
    
    public override func setThemeColors() {
        if hasBorder {
            self.layer?.borderColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "card-disabled-border").normal.cgColor
        }
        
        self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: backgroundColorToken).normal.cgColor
    }
    
    private func updateView() {
        self.layer?.cornerRadius = 4
        self.layer?.borderWidth = hasBorder ? 1 : 0
        
        setThemeColors()

        addMeetingMarkerView()
    }
    
    private func addMeetingMarkerView() {

        if meetingMarkerView == nil {
            meetingMarkerView = UTMeetingMarkerView()
        }
        meetingMarkerView.status = status
        meetingMarkerView.type = markerType
        meetingMarkerView.setThemeColors()
        addMarkerView(statusView: meetingMarkerView)
        
    }
    
    private func addMarkerView(statusView: UTMeetingMarkerView) {
        statusView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(statusView)
        let leadingConstraint  = NSLayoutConstraint.createLeadingSpaceToViewConstraint(firstItem: statusView, secondItem: self, constant: 0)
        let topConstraint = NSLayoutConstraint.createTopSpaceToViewConstraint(firstItem: statusView, secondItem: self)
        let bottomConstraint = NSLayoutConstraint.createBottomSpaceToViewConstraint(firstItem: statusView, secondItem: self)
        let widthConstaint   = NSLayoutConstraint.createWidthConstraint(firstItem: statusView, constant: 4)
        self.addConstraints([leadingConstraint, topConstraint, bottomConstraint, widthConstaint])
    }
}
