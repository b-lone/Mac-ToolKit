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
    var beginPoint: NSPoint {
        didSet {
            updateMinPointFlag()
        }
    }
    var endPoint: NSPoint {
        didSet {
            updateMinPointFlag()
        }
    }
    
    var minX: CGFloat {
        get { minPointIsBeginPoint ? beginPoint.x : endPoint.x }
        set {
            if minPointIsBeginPoint {
                beginPoint.x = newValue
                endPoint.x = max(endPoint.x, newValue)
            } else {
                endPoint.x = newValue
                beginPoint.x = max(beginPoint.x, newValue)
            }
        }
    }
    var maxX: CGFloat {
        get { minPointIsBeginPoint ? endPoint.x : beginPoint.x }
        set {
            if minPointIsBeginPoint {
                endPoint.x = newValue
                beginPoint.x = min(beginPoint.x, newValue)
            } else {
                beginPoint.x = newValue
                endPoint.x = min(endPoint.x, newValue)
            }
        }
    }
    var minY: CGFloat {
        get { minPointIsBeginPoint ? beginPoint.y : endPoint.y }
        set {
            if minPointIsBeginPoint {
                beginPoint.y = newValue
                endPoint.y = max(endPoint.y, newValue)
            } else {
                endPoint.y = newValue
                beginPoint.y = max(beginPoint.y, newValue)
            }
        }
    }
    var maxY: CGFloat {
        get { minPointIsBeginPoint ? endPoint.y : beginPoint.y }
        set {
            if minPointIsBeginPoint {
                endPoint.y = newValue
                beginPoint.y = max(beginPoint.y, newValue)
            } else {
                beginPoint.y = newValue
                endPoint.y = max(endPoint.y, newValue)
            }
        }
    }
    private var minPointIsBeginPoint = true
    
    var isPoint: Bool { return beginPoint == endPoint }
    
    
    var width: CGFloat { drawing.style.lineWidth }
    var color: NSColor {
        get { mColor ?? drawing.style.lineColor }
        set { mColor = newValue }
    }
    
    var stackingOrder: Int = 0
    var orientation: MagicOrientation = .horizontal
    private var mColor: NSColor?
    var drawing: MagicDrawing!
    
    init(startPoint: NSPoint, endPoint: NSPoint) {
        self.beginPoint = startPoint
        self.endPoint = endPoint
        super.init()
        updateMinPointFlag()
    }
    
    override func copy() -> Any {
        let line = MagicLine(startPoint: beginPoint, endPoint: endPoint)
        line.stackingOrder = stackingOrder
        line.orientation = orientation
        line.drawing = drawing
        line.mColor = mColor
        return line
    }
    
    private func updateMinPointFlag() {
        minPointIsBeginPoint = beginPoint.x < endPoint.x || beginPoint.y < endPoint.y
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
    
    func removAll() {
        lineList.removeAll()
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
    enum Level: Int {
        case screenBorder
        case windowBorder
    }
    var isKeyScreen = false
    private let screen: NSScreen
    private let level: Level
    @IBOutlet weak var drawingBoardView: MagicDrawingBoardView!
    
    private var onceFlag = true
    
    override var windowNibName: NSNib.Name? { "MagicDrawingBoardWindowController" }
    
    init(screen: NSScreen, level: Level) {
        self.screen = screen
        self.level = level
        super.init(window: nil)
        let _ = window
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        close()
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.backgroundColor = .clear
        window?.ignoresMouseEvents = true
        setuoWindowLevel()
        
        onScreenUpdated()
    }
    
    private func onScreenUpdated() {
        window?.setFrame(screen.frame, display: true)
    }
    
    private func setuoWindowLevel() {
        switch level {
        case .windowBorder:
            window?.level = .floating + 1
        case .screenBorder:
            window?.level = .screenSaver
        }
    }
    
    func removeDrawing(drawingId: MagicDrawingId) {
        removeDrawingLines(drawingId: drawingId)
        
        updateWindowVisibility()
    }
    
    func drawWindowsBorder(aboveWindowInfoList: [MagicWindowInfo], targetWindowInfoList: [MagicWindowInfo], drawing: MagicDrawing) {
        removeDrawingLines(drawingId: drawing.id)
        
        var lineList = getBorderedWindowBorderLines(borderedWindowInfoList: targetWindowInfoList, drawing: drawing)
        lineList = cutOverlappedLines(lineList: lineList, aboveWindowInfoList: aboveWindowInfoList, borderedWindowInfoList: targetWindowInfoList)
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

    func getIsCovered(windowInfoList: [MagicWindowInfo], targetWindowInfoList: [MagicWindowInfo], drawing: MagicDrawing) -> Bool {
        SPARK_LOG_TRACE("Start-----")
        var lineList = getBorderedWindowBorderLines(borderedWindowInfoList: targetWindowInfoList, drawing: drawing)
        lineList = cutOverlappedLines(lineList: lineList, aboveWindowInfoList: windowInfoList, borderedWindowInfoList: [])
        cutBeyondScreenLines(lineList: &lineList)
        SPARK_LOG_TRACE("Stop-----")
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
        var isLineCut = false
        if line.orientation == .horizontal {
            if line.beginPoint.y >= frame.minY, line.beginPoint.y <= frame.maxY {
                if line.beginPoint.x < frame.minX {
                    if line.endPoint.x < frame.minX {
                    } else if line.endPoint.x >= frame.minX, line.endPoint.x <= frame.maxX {
                        point4?.x = frame.minX - 1
                        isLineCut = true
                    } else if line.endPoint.x > frame.maxX {
                        point2 = NSMakePoint(frame.minX - 1, line.beginPoint.y)
                        point3 = NSMakePoint(frame.maxX + 1, line.beginPoint.y)
                        isLineCut = true
                    }
                } else if line.beginPoint.x >= frame.minX, line.beginPoint.x <= frame.maxX {
                    if line.endPoint.x < frame.minX {
                        point1?.x = frame.minX - 1
                        isLineCut = true
                    } else if line.endPoint.x >= frame.minX, line.endPoint.x <= frame.maxX {
                        point1 = nil
                        point4 = nil
                        isLineCut = true
                    } else if line.endPoint.x > frame.maxX {
                        point1?.x = frame.maxX + 1
                        isLineCut = true
                    }
                } else if line.beginPoint.x > frame.maxX {
                    if line.endPoint.x < frame.minX {
                        point2 = NSMakePoint(frame.maxX + 1, line.beginPoint.y)
                        point3 = NSMakePoint(frame.minX - 1, line.beginPoint.y)
                        isLineCut = true
                    } else if line.endPoint.x >= frame.minX, line.endPoint.x <= frame.maxX {
                        point4?.x = frame.maxX + 1
                        isLineCut = true
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
                        isLineCut = true
                    } else if line.endPoint.y > frame.maxY {
                        point2 = NSMakePoint(line.beginPoint.x, frame.minY - 1)
                        point3 = NSMakePoint(line.beginPoint.x, frame.maxY + 1)
                        isLineCut = true
                    }
                } else if line.beginPoint.y >= frame.minY, line.beginPoint.y <= frame.maxY {
                    if line.endPoint.y < frame.minY {
                        point1?.y = frame.minY - 1
                        isLineCut = true
                    } else if line.endPoint.y >= frame.minY, line.endPoint.y <= frame.maxY {
                        point1 = nil
                        point4 = nil
                        isLineCut = true
                    } else if line.endPoint.y > frame.maxY {
                        point1?.y = frame.maxY + 1
                        isLineCut = true
                    }
                } else if line.beginPoint.y > frame.maxY {
                    if line.endPoint.y < frame.minY {
                        point2 = NSMakePoint(line.beginPoint.x, frame.maxY + 1)
                        point3 = NSMakePoint(line.beginPoint.x, frame.minY - 1)
                        isLineCut = true
                    } else if line.endPoint.y >= frame.minY, line.endPoint.y <= frame.maxY {
                        point4?.y = frame.maxY + 1
                        isLineCut = true
                    } else if line.endPoint.y > frame.maxY {
                    }
                }
            }
        }
        
        if isLineCut {
            SPARK_LOG_TRACE("covered by:\(windowInfo.pName) \(windowInfo.name) \(windowInfo.frame)")
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
    
    private func cutBeyondScreenLines(lineList: inout MagicLineList) {
        let frame = screen.frame
        for line in lineList {
            line.minX = max(line.minX, frame.minX)
            line.maxX = min(line.maxX, frame.maxX)
            line.minY = max(line.minY, frame.minY)
            line.maxY = min(line.maxY, frame.maxY)
        }
        lineList.removeAll { $0.isPoint }
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
