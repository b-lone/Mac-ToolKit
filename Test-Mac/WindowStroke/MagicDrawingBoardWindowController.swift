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
    var width: CGFloat { drawing.style.lineWidth }
    var color: NSColor {
        get { mColor ?? drawing.style.lineColor }
        set { mColor = newValue }
    }
    var stackingOrder: Int = 0
    var orientation: MagicOrientation = .horizontal
    
    var drawing: MagicDrawing!
    
    private var mColor: NSColor?
    
    init(startPoint: NSPoint, endPoint: NSPoint) {
        self.beginPoint = startPoint
        self.endPoint = endPoint
    }
    
    override func copy() -> Any {
        let line = MagicLine(startPoint: beginPoint, endPoint: endPoint)
        line.stackingOrder = stackingOrder
        line.orientation = orientation
        line.drawing = drawing
        return line
    }
}

typealias MagicLineList = [MagicLine]

class MagicDrawingBoardView: NSView {
    private var lineList = MagicLineList() {
        didSet {
            needsDisplay = true
        }
    }
    
    var isEmpty: Bool { lineList.isEmpty }
    
    func appendLines(_ lineList: MagicLineList) {
        self.lineList += lineList
    }
    
    func removeDrawing(drawingId: MagicDrawingId) {
        lineList.removeAll { $0.drawing.id == drawingId }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        for line in lineList {
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
    var isKeyScreen = false
    private let screen: NSScreen
    @IBOutlet weak var drawingBoardView: MagicDrawingBoardView!
    
    private var onceFlag = true
    
    override var windowNibName: NSNib.Name? { "MagicDrawingBoardWindowController" }
    
    init(screen: NSScreen) {
        self.screen = screen
        super.init(window: nil)
        let _ = window
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
    }
    
    func onScreenUpdated() {
        window?.setFrame(screen.frame, display: true)
    }
    
    func removeDrawing(drawingId: MagicDrawingId) {
        removeDrawingLines(drawingId: drawingId)
        
        updateWindowVisibility()
    }
    
    func drawWindowsBorder(aboveWindowInfoList: [MagicWindowInfo], borderedWindowInfoList: [MagicWindowInfo], drawing: MagicDrawing) {
        removeDrawingLines(drawingId: drawing.id)
        
        var lineList = getBorderedWindowBorderLines(borderedWindowInfoList: borderedWindowInfoList, drawing: drawing)
        lineList = cutOverlappedLines(lineList: lineList, aboveWindowInfoList: aboveWindowInfoList, borderedWindowInfoList: borderedWindowInfoList)
        lineList.forEach{
            $0.drawing = drawing
            $0.color = isKeyScreen ? MagicDrawingStyle.sharingApplication.lineColor : MagicDrawingStyle.unsharedApplication.lineColor
        }
        optimizingVertices(lineList: lineList)
        drawingBoardView.appendLines(lineList)

        updateWindowVisibility()
    }
    
    func drawScreenBorder(drawing: MagicDrawing) {
        let lineList = getScreenBorderLines(drawing: drawing)
        lineList.forEach{ $0.drawing = drawing }
        drawingBoardView.appendLines(lineList)
        
        updateWindowVisibility()
    }
    
    private func removeDrawingLines(drawingId: MagicDrawingId) {
        drawingBoardView.removeDrawing(drawingId: drawingId)
    }
    
    private func updateWindowVisibility() {
        if drawingBoardView.isEmpty {
            close()
        } else {
            showWindow(self)
            if onceFlag {
                onceFlag = false
                if let windowNumber = window?.windowNumber {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: OnShareShouldExcludeWindow), object: self, userInfo: ["windowNumber": windowNumber])
                }
            }
        }
    }
    
    func getIsCovered(windowInfoList: [MagicWindowInfo], coveredWindowInfoList: [MagicWindowInfo], drawing: MagicDrawing) -> Bool {
        var lineList = getBorderedWindowBorderLines(borderedWindowInfoList: coveredWindowInfoList, drawing: drawing)
        lineList = cutOverlappedLines(lineList: lineList, aboveWindowInfoList: windowInfoList, borderedWindowInfoList: [])
        return lineList.count == 0
    }
    
    private func getBorderLines(frame: CGRect, drawing: MagicDrawing) -> MagicLineList {
        let leftBottomPoint = NSMakePoint(frame.minX, frame.minY)
        let rightBottomPoint = NSMakePoint(frame.maxX, frame.minY)
        let leftTopPoint = NSMakePoint(frame.minX, frame.maxY)
        let rightTopPoint = NSMakePoint(frame.maxX, frame.maxY)
        
        let leftLine = MagicLine(startPoint: leftBottomPoint, endPoint: leftTopPoint)
        let rightLine = MagicLine(startPoint: rightBottomPoint, endPoint: rightTopPoint)
        let topLine = MagicLine(startPoint: leftTopPoint, endPoint: rightTopPoint)
        let bottomLine = MagicLine(startPoint: leftBottomPoint, endPoint: rightBottomPoint)
        

        topLine.orientation = .horizontal
        bottomLine.orientation = .horizontal
        leftLine.orientation = .vertical
        rightLine.orientation = .vertical
        
        return [topLine, bottomLine, leftLine, rightLine]
    }
    
    private func getScreenBorderLines(drawing: MagicDrawing) -> MagicLineList {
        return getBorderLines(frame: window!.convertFromScreen(screen.frame), drawing: drawing)
    }
    
    private func getWindowBorderLines(windowInfo: MagicWindowInfo, drawing: MagicDrawing) -> MagicLineList {
        let borderLineList = getBorderLines(frame: window!.convertFromScreen(windowInfo.frame), drawing: drawing)
        borderLineList.forEach { $0.stackingOrder = windowInfo.stackingOrder }
        return borderLineList
    }
    
    private func getBorderedWindowBorderLines(borderedWindowInfoList: [MagicWindowInfo], drawing: MagicDrawing) -> MagicLineList {
        var borderLineList = MagicLineList()
        for borderedWindowInfo in borderedWindowInfoList {
            borderLineList += getWindowBorderLines(windowInfo: borderedWindowInfo, drawing: drawing)
        }
        return borderLineList
    }
    
    private func cutOverlappedLines(lineList: MagicLineList, aboveWindowInfoList: [MagicWindowInfo], borderedWindowInfoList: [MagicWindowInfo]) -> MagicLineList   {
        var result = lineList
        for aboveWindowInfo in aboveWindowInfoList {
            var intermediateValues = MagicLineList()
            for line in result {
                intermediateValues += cutOverlappedLine(line: line, windowInfo: aboveWindowInfo, stackingOrderIncrease: true)
            }
            result = intermediateValues
        }
        for borderedWindowInfo in borderedWindowInfoList {
            var intermediateValues = MagicLineList()
            for line in result {
                intermediateValues += cutOverlappedLine(line: line, windowInfo: borderedWindowInfo, stackingOrderIncrease: false)
            }
            result = intermediateValues
        }
        return result
    }
    
    private func cutOverlappedLine(line: MagicLine, windowInfo: MagicWindowInfo, stackingOrderIncrease: Bool) -> MagicLineList {
        guard stackingOrderIncrease && windowInfo.stackingOrder > line.stackingOrder || !stackingOrderIncrease && windowInfo.stackingOrder < line.stackingOrder else { return [line] }
        let frame = window!.convertFromScreen(windowInfo.frame)
        var point1:NSPoint? = line.beginPoint
        var point2: NSPoint?
        var point3: NSPoint?
        var point4: NSPoint? = line.endPoint
        if line.orientation == .horizontal {
            if line.beginPoint.y >= frame.minY, line.beginPoint.y <= frame.maxY {
                if line.beginPoint.x < frame.minX {
                    if line.endPoint.x < frame.minX {
                    } else if line.endPoint.x >= frame.minX, line.endPoint.x <= frame.maxX {
                        point4?.x = frame.minX - 1
                    } else if line.endPoint.x > frame.maxX {
                        point2 = NSMakePoint(frame.minX - 1, line.beginPoint.y)
                        point3 = NSMakePoint(frame.maxX + 1, line.beginPoint.y)
                    }
                } else if line.beginPoint.x >= frame.minX, line.beginPoint.x <= frame.maxX {
                    if line.endPoint.x < frame.minX {
                        point1?.x = frame.minX - 1
                    } else if line.endPoint.x >= frame.minX, line.endPoint.x <= frame.maxX {
                        point1 = nil
                        point4 = nil
                    } else if line.endPoint.x > frame.maxX {
                        point1?.x = frame.maxX + 1
                    }
                } else if line.beginPoint.x > frame.maxX {
                    if line.endPoint.x < frame.minX {
                        point2 = NSMakePoint(frame.maxX + 1, line.beginPoint.y)
                        point3 = NSMakePoint(frame.minX - 1, line.beginPoint.y)
                    } else if line.endPoint.x >= frame.minX, line.endPoint.x <= frame.maxX {
                        point4?.x = frame.maxX + 1
                    } else if line.endPoint.x > frame.maxX {
                    }
                }
            }
        } else {
            if line.beginPoint.x >= frame.minX, line.beginPoint.x <= frame.maxX {
                if line.beginPoint.y < frame.minY {
                    if line.endPoint.y < frame.minY {
                    } else if line.endPoint.y >= frame.minY, line.endPoint.y <= frame.maxY {
                        point4?.y = frame.minY - 1
                    } else if line.endPoint.y > frame.maxY {
                        point2 = NSMakePoint(line.beginPoint.x, frame.minY - 1)
                        point3 = NSMakePoint(line.beginPoint.x, frame.maxY + 1)
                    }
                } else if line.beginPoint.y >= frame.minY, line.beginPoint.y <= frame.maxY {
                    if line.endPoint.y < frame.minY {
                        point1?.y = frame.minY - 1
                    } else if line.endPoint.y >= frame.minY, line.endPoint.y <= frame.maxY {
                        point1 = nil
                        point4 = nil
                    } else if line.endPoint.y > frame.maxY {
                        point1?.y = frame.maxY + 1
                    }
                } else if line.beginPoint.y > frame.maxY {
                    if line.endPoint.y < frame.minY {
                        point2 = NSMakePoint(line.beginPoint.x, frame.maxY + 1)
                        point3 = NSMakePoint(line.beginPoint.x, frame.minY - 1)
                    } else if line.endPoint.y >= frame.minY, line.endPoint.y <= frame.maxY {
                        point4?.y = frame.maxY + 1
                    } else if line.endPoint.y > frame.maxY {
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
    
    private func getAdjustedHorizontalPoint(originPoint: CGPoint, comparedPoint: CGPoint, halfLineWidth: CGFloat, isAddition: Bool) -> CGPoint {
        let dx = originPoint.x - comparedPoint.x
        let dy = originPoint.y - comparedPoint.y
        
        if abs(dy) < halfLineWidth, abs(dx) < halfLineWidth {
            if isAddition {
                return NSMakePoint(comparedPoint.x + halfLineWidth, originPoint.y)
            } else {
                return NSMakePoint(comparedPoint.x - halfLineWidth, originPoint.y)
            }
        }
        return originPoint
    }
    
    private func optimizingVertices(lineList: MagicLineList) {
        let horizontalLineList = lineList.filter{ $0.orientation == .horizontal }
        let verticalLineList = lineList.filter{ $0.orientation == .vertical }
        
        var halfLineWidth: CGFloat = 0
        if !horizontalLineList.isEmpty {
            halfLineWidth = horizontalLineList[0].width / 2
        }
        
        for horizontalLine in horizontalLineList {
            for verticalLine in verticalLineList {
                horizontalLine.beginPoint = getAdjustedHorizontalPoint(originPoint: horizontalLine.beginPoint, comparedPoint: verticalLine.beginPoint, halfLineWidth: halfLineWidth, isAddition: horizontalLine.beginPoint.x >= horizontalLine.endPoint.x)
                horizontalLine.beginPoint = getAdjustedHorizontalPoint(originPoint: horizontalLine.beginPoint, comparedPoint: verticalLine.endPoint, halfLineWidth: halfLineWidth, isAddition: horizontalLine.beginPoint.x >= horizontalLine.endPoint.x)
                horizontalLine.endPoint = getAdjustedHorizontalPoint(originPoint: horizontalLine.endPoint, comparedPoint: verticalLine.beginPoint, halfLineWidth: halfLineWidth, isAddition: horizontalLine.endPoint.x >= horizontalLine.beginPoint.x)
                horizontalLine.endPoint = getAdjustedHorizontalPoint(originPoint: horizontalLine.endPoint, comparedPoint: verticalLine.endPoint, halfLineWidth: halfLineWidth, isAddition: horizontalLine.endPoint.x >= horizontalLine.beginPoint.x)
            }
        }
    }
}
