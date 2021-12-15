//
//  String+Extensions.swift
//  UIToolkit
//
//  Created by James Nestor on 14/06/2021.
//

import Cocoa

extension String {

    func trimWhiteSpace() -> String{
       return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }

    public static func formatCallDurationSinceDate(_ date: Date?) -> String {
        guard let date = date, date.timeIntervalSince1970 > 0 else { return "" }
        return Self.formatCallDuration(date.timeIntervalSinceNow)
    }
    
    public static func formatCallDuration(_ elapsedSeconds:Double) -> String {
        var elapsedSecondsStr:String = ""
        var elapsedTime:Double = elapsedSeconds
        
        if elapsedTime < 0 {
            elapsedTime = -1 * elapsedTime
        }

        let interval = Int(elapsedTime)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        
        if hours > 0 {
            elapsedSecondsStr = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        else {
            elapsedSecondsStr = String(format: "%02d:%02d", minutes, seconds)
        }
        
        return elapsedSecondsStr
    }
    
    func NSRangeFromRange(_ range:Range<String.Index>) -> NSRange{
        return NSRange(range, in: self)
    }
    
    func replaceNewlineCharactersWithWhitespace() -> String{
        let newStr = self.replacingOccurrences(of: "\r", with: "")
        return newStr.replacingOccurrences(of: "\n", with: " ")
    }
    
    func size(with font:NSFont, constrainedTo size:NSSize) -> NSSize{
        
        let textStorage   = NSTextStorage(string: self)
        let textContainer = NSTextContainer(containerSize: size)
        let layoutManager = NSLayoutManager()
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textStorage.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0,textStorage.length))
        textContainer.lineFragmentPadding = 0
        layoutManager.glyphRange(for: textContainer)
        let constrainedSize = layoutManager.usedRect(for: textContainer)
        
        return NSMakeSize(constrainedSize.width, constrainedSize.height)
    }

    public static var separatorString:String{
        return " • "
    }
    
    public func decodeBase64() -> Data? {
        return Data(base64Encoded: self, options: [])
    }
}

extension StringProtocol where Index == String.Index {
    public func ranges<T: StringProtocol>(of substring: T, options: String.CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let result = range(of: substring, options: options, range: (ranges.last?.upperBound ?? startIndex)..<endIndex, locale: locale) {
            ranges.append(result)
        }
        return ranges
    }
}
