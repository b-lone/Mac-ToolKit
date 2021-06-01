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
    
    init(startPoint: NSPoint, endPoint: NSPoint) {
        self.beginPoint = startPoint
        self.endPoint = endPoint
    }
    
    override var description: String {
        "startPoint:\(beginPoint) endPoint:\(endPoint)"
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
    var lines = [MagicLine]() {
        didSet {
            needsDisplay = true
        }
    }
    
    func appendLines(_ lines: [MagicLine]) {
        self.lines += lines
    }
    
    func clear() {
        lines.removeAll()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        for line in lines {
            print("\(line)")
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
        self.window?.setFrame(screen.frame, display: true)
        self.window?.backgroundColor = .clear
        self.window?.ignoresMouseEvents = true
        self.window?.level = .screenSaver - 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        print("windowDidLoad")
    }
    
    func drawWindowsBorder(aboveWindowInfoList: [MagicWindowInfo], borderedWindowInfoList: [MagicWindowInfo]) {
        drawingBoardView.clear()
        
        fillWindowInfoWindowBasedFrame(windowInfoList: aboveWindowInfoList)
        fillWindowInfoWindowBasedFrame(windowInfoList: borderedWindowInfoList)
        
        var lines = getBorderedWindowBorderLines(borderedWindowInfoList: borderedWindowInfoList)
        lines = cutOverlappedLines(lines: lines, aboveWindowInfoList: aboveWindowInfoList, borderedWindowInfoList: borderedWindowInfoList)
        drawingBoardView.appendLines(lines)
    }
    
    func drawScreenBorder() {
        drawingBoardView.clear()
        
        drawingBoardView.appendLines(getScreenBorderLines())
    }
    
    func getIsCovered(windowInfoList: [MagicWindowInfo], window: MagicWindowInfo) -> Bool {
        fillWindowInfoWindowBasedFrame(windowInfoList: windowInfoList)
        var lines = getBorderedWindowBorderLines(borderedWindowInfoList: [window])
        lines = cutOverlappedLines(lines: lines, aboveWindowInfoList: windowInfoList, borderedWindowInfoList: [])
        return lines.count == 0
    }
    
    func fillWindowInfoWindowBasedFrame(windowInfoList: [MagicWindowInfo]) {
        windowInfoList.forEach {
            let frame = $0.bounds
            let screenFrame = NSScreen.screens[0].frame
            $0.windowBasedFrame = window!.convertFromScreen(NSMakeRect(frame.minX, screenFrame.maxY - frame.maxY, frame.width, frame.height))
        }
    }
    
    func getBorderLines(frame: CGRect) -> [MagicLine] {
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
//        topLine.color = .red
//        bottomLine.color = .yellow
//        leftLine.color = .green
//        rightLine.color = .blue
        
        return [topLine, bottomLine, leftLine, rightLine]
    }
    
    func getScreenBorderLines() -> [MagicLine] {
        return getBorderLines(frame: window!.convertFromScreen(screen.frame))
    }
    
    func getWindowBorderLines(windowInfo: MagicWindowInfo) -> [MagicLine] {
        let borderLines = getBorderLines(frame: windowInfo.windowBasedFrame)
        borderLines.forEach { $0.stackingOrder = windowInfo.stackingOrder }
        return borderLines
    }
    
    func getBorderedWindowBorderLines(borderedWindowInfoList: [MagicWindowInfo]) -> [MagicLine] {
        var borderLines = [MagicLine]()
        for borderedWindowInfo in borderedWindowInfoList {
            borderLines += getWindowBorderLines(windowInfo: borderedWindowInfo)
        }
        return borderLines
    }
    
    func cutOverlappedLines(lines: [MagicLine], aboveWindowInfoList: [MagicWindowInfo], borderedWindowInfoList: [MagicWindowInfo]) -> [MagicLine]   {
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
    
    func cutOverlappedLine(line: MagicLine, windowInfo: MagicWindowInfo, stackingOrderIncrease: Bool) -> [MagicLine] {
        guard stackingOrderIncrease && windowInfo.stackingOrder > line.stackingOrder || !stackingOrderIncrease && windowInfo.stackingOrder < line.stackingOrder else { return [line] }
        let frame = windowInfo.windowBasedFrame
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
}
