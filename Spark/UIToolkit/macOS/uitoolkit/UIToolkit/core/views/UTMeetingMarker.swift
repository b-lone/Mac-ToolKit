//
//  UTMeetingMarker.swift
//  UIToolkit
//
//  Created by Michelle Mulcair on 17/09/2021.
//

import Cocoa

public class UTMeetingMarkerView: UTView {
       
    public var status: MeetingStatus = .active
    public var type: MeetingMarkerType = .accepted
       
    private var colorToken: String {
        switch status{
        case .active:
            return "meetingmarker-active-background"
        case .inactive:
            return "meetingmarker-inactive-background"
        case .cancelled:
            return "meetingmarker-default-background"
        }
    }
    
    private var thicknessOfLines: CGFloat = 2.0
    private var gapsOfLines: CGFloat = 3.0
    
    public override func setThemeColors() {
        
        self.wantsLayer = true
        if type == .accepted {
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: colorToken).normal.cgColor
        } else {
            self.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: "meetingmarker-default-background").normal.cgColor
        }

    }
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if type == .tentative && !colorToken.isEmpty {
            guard let context = NSGraphicsContext.current?.cgContext else { return }
            let lineColor = UIToolkit.shared.getThemeManager().getColors(tokenName: colorToken).normal.cgColor
            context.setStrokeColor(lineColor)
            context.setLineWidth(thicknessOfLines)
        
            let width = dirtyRect.size.width
            let height = dirtyRect.size.height
            var position = -(width > height ? width : height) - thicknessOfLines
            while position < width {
                context.move( to: CGPoint(x: position - thicknessOfLines, y: -thicknessOfLines) )
                context.addLine( to: CGPoint(x: position + thicknessOfLines + height, y: thicknessOfLines+height) )
                context.strokePath()
                position += gapsOfLines + thicknessOfLines * 2
            }
        } else {
            return
        }
    }
}
