//
//  MagicDrawingBoardWindowController.swift
//  WebexTeams
//
//  Created by Archie You on 2021/5/28.
//  Copyright © 2021 Cisco Systems. All rights reserved.
//

import Cocoa

enum MagicOrientation: Int {
    case horizontal
    case vertical
}


class MagicLine: NSObject {
    var beginPoint: NSPoint
    var endPoint: NSPoint
    var width: CGFloat = 5
    var color: NSColor = .red
    var stackingOrder: Int = 0
    var orientation: MagicOrientation = .horizontal
    var drawingId: MagicDrawingId = 0
    
    init(startPoint: NSPoint, endPoint: NSPoint) {
        self.beginPoint = startPoint
        self.endPoint = endPoint
    }
    
    override func copy() -> Any {
        let line = MagicLine(startPoint: beginPoint, endPoint: endPoint)
        line.width = width
        line.color = color
        line.stackingOrder = stackingOrder
        line.orientation = orientation
        return line
    }
}

class MagicDrawingBoardView: NSView {
    private var lines = [MagicLine]() {
        didSet {
            needsDisplay = true
        }
    }
    
    var isEmpty: Bool { lines.isEmpty }
    
    func appendLines(_ lines: [MagicLine]) {
        self.lines += lines
    }
    
    func removeDrawing(drawingId: MagicDrawingId) {
        lines.removeAll { $0.drawingId == drawingId }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        for line in lines {
            let bezierPath = NSBezierPath()
            bezierPath.move(to: line.beginPoint)
            bezierPath.line(to: line.endPoint)
            
            bezierPath.lineWidth = line.width
            line.color.setStroke()
            bezierPath.stroke()
        }
    }
}

class MagicDrawingBoardWindowController: NSWindowController {
    private let screen: NSScreen
    @IBOutlet weak var drawingBoardView: MagicDrawingBoardView!
    
    override var windowNibName: NSNib.Name? { "MagicDrawingBoardWindowController" }
    
    init(screen: NSScreen) {
        self.screen = screen
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.backgroundColor = .clear
        window?.ignoresMouseEvents = true
        window?.level = .screenSaver
        
        onScreenUpdated()
        
        print("windowDidLoad")
    }
    
    func onScreenUpdated() {
        window?.setFrame(screen.frame, display: true)
    }
    
    func removeDrawing(drawingId: MagicDrawingId) {
        drawingBoardView?.removeDrawing(drawingId: drawingId)

        updateWindowVisibility()
    }
    
    func drawWindowsBorder(aboveWindowInfoList: [MagicWindowInfo], borderedWindowInfoList: [MagicWindowInfo], drawingId: MagicDrawingId) {
        var lines = getBorderedWindowBorderLines(borderedWindowInfoList: borderedWindowInfoList)
        lines = cutOverlappedLines(lines: lines, aboveWindowInfoList: aboveWindowInfoList, borderedWindowInfoList: borderedWindowInfoList)
        lines.forEach{ $0.drawingId = drawingId}
        drawingBoardView.appendLines(lines)
        
        updateWindowVisibility()
    }
    
    func drawScreenBorder(style: MagicDrawingStyle, drawingId: MagicDrawingId) {
        let lines = getScreenBorderLines()
        setLinesPrarmeters(lines: lines, style: style, drawingId: drawingId)
        drawingBoardView.appendLines(lines)
        
        updateWindowVisibility()    
    }
    
    private func updateWindowVisibility() {
        if drawingBoardView?.isEmpty == true {
            close()
        } else {
            showWindow(self)
        }
    }
    
    func getIsCovered(windowInfoList: [MagicWindowInfo], window: MagicWindowInfo) -> Bool {
        var lines = getBorderedWindowBorderLines(borderedWindowInfoList: [window])
        lines = cutOverlappedLines(lines: lines, aboveWindowInfoList: windowInfoList, borderedWindowInfoList: [])
        return lines.count == 0
    }
    
    private func getBorderLines(frame: CGRect) -> [MagicLine] {
        let leftBottomPoint = NSMakePoint(frame.minX, frame.minY)
        let rightBottomPoint = NSMakePoint(frame.maxX, frame.minY)
        let leftTopPoint = NSMakePoint(frame.minX, frame.maxY)
        let rightTopPoint = NSMakePoint(frame.maxX, frame.maxY)
        
        let topLine = MagicLine(startPoint: leftTopPoint, endPoint: rightTopPoint)
        let bottomLine = MagicLine(startPoint: leftBottomPoint, endPoint: rightBottomPoint)
        let leftLine = MagicLine(startPoint: leftTopPoint, endPoint: leftBottomPoint)
        let rightLine = MagicLine(startPoint: rightBottomPoint, endPoint: rightTopPoint)

        topLine.orientation = .horizontal
        bottomLine.orientation = .horizontal
        leftLine.orientation = .vertical
        rightLine.orientation = .vertical
        
        return [topLine, bottomLine, leftLine, rightLine]
    }
    
    private func getScreenBorderLines() -> [MagicLine] {
        return getBorderLines(frame: window!.convertFromScreen(screen.frame))
    }
    
    private func getWindowBorderLines(windowInfo: MagicWindowInfo) -> [MagicLine] {
        let borderLines = getBorderLines(frame: window!.convertFromScreen(windowInfo.frame))
        borderLines.forEach { $0.stackingOrder = windowInfo.stackingOrder }
        return borderLines
    }
    
    private func getBorderedWindowBorderLines(borderedWindowInfoList: [MagicWindowInfo]) -> [MagicLine] {
        var borderLines = [MagicLine]()
        for borderedWindowInfo in borderedWindowInfoList {
            borderLines += getWindowBorderLines(windowInfo: borderedWindowInfo)
        }
        return borderLines
    }
    
    private func cutOverlappedLines(lines: [MagicLine], aboveWindowInfoList: [MagicWindowInfo], borderedWindowInfoList: [MagicWindowInfo]) -> [MagicLine]   {
        var result = lines
        for aboveWindowInfo in aboveWindowInfoList {
            var intermediateValues = [MagicLine]()
            for line in result {
                intermediateValues += cutOverlappedLine(line: line, windowInfo: aboveWindowInfo, stackingOrderIncrease: true)
            }
            result = intermediateValues
        }
        for borderedWindowInfo in borderedWindowInfoList {
            var intermediateValues = [MagicLine]()
            for line in result {
                intermediateValues += cutOverlappedLine(line: line, windowInfo: borderedWindowInfo, stackingOrderIncrease: false)
            }
            result = intermediateValues
        }
        return result
    }
    
    private func cutOverlappedLine(line: MagicLine, windowInfo: MagicWindowInfo, stackingOrderIncrease: Bool) -> [MagicLine] {
        guard stackingOrderIncrease && windowInfo.stackingOrder > line.stackingOrder || !stackingOrderIncrease && windowInfo.stackingOrder < line.stackingOrder else { return [line] }
        let frame = window!.convertFromScreen(windowInfo.frame)
        var point1:NSPoint? = line.beginPoint
        var point2: NSPoint?
        var point3: NSPoint?
        var point4: NSPoint? = line.endPoint
        if line.orientation == .horizontal {
            if line.beginPoint.y > frame.minY, line.beginPoint.y < frame.maxY {
                if line.beginPoint.x <= frame.minX {
                    if line.endPoint.x <= frame.minX {
                    } else if line.endPoint.x > frame.minX, line.endPoint.x < frame.maxX {
                        point4?.x = frame.minX
                    } else if line.endPoint.x >= frame.maxX {
                        point2 = NSMakePoint(frame.minX, line.beginPoint.y)
                        point3 = NSMakePoint(frame.maxX, line.beginPoint.y)
                    }
                } else if line.beginPoint.x > frame.minX, line.beginPoint.x < frame.maxX {
                    if line.endPoint.x <= frame.minX {
                        point1?.x = frame.minX
                    } else if line.endPoint.x > frame.minX, line.endPoint.x < frame.maxX {
                        point1 = nil
                        point4 = nil
                    } else if line.endPoint.x >= frame.maxX {
                        point1?.x = frame.maxX
                    }
                } else if line.beginPoint.x >= frame.maxX {
                    if line.endPoint.x <= frame.minX {
                        point2 = NSMakePoint(frame.maxX, line.beginPoint.y)
                        point3 = NSMakePoint(frame.minX, line.beginPoint.y)
                    } else if line.endPoint.x > frame.minX, line.endPoint.x < frame.maxX {
                        point4?.x = frame.maxX
                    } else if line.endPoint.x >= frame.maxX {
                    }
                }
            }
        } else {
            if line.beginPoint.x > frame.minX, line.beginPoint.x < frame.maxX {
                if line.beginPoint.y <= frame.minY {
                    if line.endPoint.y <= frame.minY {
                    } else if line.endPoint.y > frame.minY, line.endPoint.y < frame.maxY {
                        point4?.y = frame.minY
                    } else if line.endPoint.y >= frame.maxY {
                        point2 = NSMakePoint(frame.minY, line.beginPoint.y)
                        point3 = NSMakePoint(frame.maxY, line.beginPoint.y)
                    }
                } else if line.beginPoint.y > frame.minY, line.beginPoint.y < frame.maxY {
                    if line.endPoint.y <= frame.minY {
                        point1?.y = frame.minY
                    } else if line.endPoint.y > frame.minY, line.endPoint.y < frame.maxY {
                        point1 = nil
                        point4 = nil
                    } else if line.endPoint.y >= frame.maxY {
                        point1?.y = frame.maxY
                    }
                } else if line.beginPoint.y >= frame.maxY {
                    if line.endPoint.y <= frame.minY {
                        point2 = NSMakePoint(frame.maxY, line.beginPoint.y)
                        point3 = NSMakePoint(frame.minY, line.beginPoint.y)
                    } else if line.endPoint.y > frame.minY, line.endPoint.y < frame.maxY {
                        point4?.y = frame.maxY
                    } else if line.endPoint.y >= frame.maxY {
                    }
                }
            }
        }
        
        if let point1 = point1, let point2 = point2, let point3 = point3, let point4 = point4 {
            let line2 = line.copy() as! MagicLine
            line.beginPoint = point1
            line.endPoint = point2
            line2.beginPoint = point3
            line2.endPoint = point4
            return [line, line2]
        } else if let point1 = point1, let point4 = point4 {
            line.beginPoint = point1
            line.endPoint = point4
            return [line]
        }
        return []
    }
    
    private func setLinesPrarmeters(lines: [MagicLine], style: MagicDrawingStyle, drawingId: MagicDrawingId) {
        lines.forEach { line in
            line.color = style.lineColor
            line.drawingId = drawingId
        }
    }
}
