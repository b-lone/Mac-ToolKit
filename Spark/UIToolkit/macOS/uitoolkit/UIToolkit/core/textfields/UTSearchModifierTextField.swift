//
//  UTSearchModifierTextField.swift
//  UIToolkit
//
//  Created by James Nestor on 03/09/2021.
//

import Cocoa

//MARK: - UTModifierType
public enum UTModifierType {
    case unknown
    case sharedIn
    case sharedBy
    case with
    case startDate
    case endDate
    
    var serverModifierNameString:String{
        switch(self){
        case .unknown:
            return "unknown"
        case .sharedIn:
            return "sharedIn"
        case .sharedBy:
            return "sharedBy"
        case .startDate:
            return "startDate"
        case .endDate:
            return "endDate"
        case .with:
            return "with"
        }
    }
}

//MARK: - UTModifier
public class UTModifier {
    public var type:UTModifierType
    public var stringValue:String?
    public var timeValue:Date?
    
    public init(type:UTModifierType, stringValue:String){
        self.type = type
        self.stringValue = stringValue
    }
    
}

public protocol UTSearchModifierDelegate : AnyObject {
    func modifierSearchStringDetected(_ textField: UTSearchModifierTextField, type:UTModifierType)
    func modifierSearchStringRemoved(_ textField: UTSearchModifierTextField, type:UTModifierType)
    
    ///when the user selects the space/contact for a modifer
    func modifierCompleted(_ textField: UTSearchModifierTextField, modifier: UTModifier)
    func allSearchResultModifiersRemoved(textField: UTSearchModifierTextField)
    
    func controlDoCommandBySelector(_ textField: UTSearchModifierTextField, commandSelector: Selector) -> Bool
}

//MARK: - UTSearchModifierTextField
public class UTSearchModifierTextField : UTSearchInputTextField {
    
    override var borderColors:UTColorStates {
        return UIToolkit.shared.getThemeManager().getColors(token: .globalHeaderTextfieldBorderModifier)
    }
    
    //MARK: - Public variables
    public var searchString:String{
        if isModifierSearch{
            return getPlainTextAfterModifier()
        }
        
        return getSearchStringWithoutModifiers(self.attributedStringValue)
    }
    
    public var currentModifierType:UTModifierType{
        if let modifierAttachment = currentModifierAttachment{
            return modifierAttachment.type
        }
        
        return .unknown
    }
    
    public var hasSearchInput: Bool {
        return attributedStringValue.length > 0
    }
    
    public var modifiers:[UTModifier] {
        return getSearchModifiers(withFilter: { (value) -> UTModifier? in
            return (value as? UTModifierWithResultAttachment)?.modifier ?? nil
        })
    }
       
    //This means we are doing a search based on a single
    //modifier and should not apply other modifiers to the search
    public var isModifierSearch: Bool{
        return currentModifierAttachment != nil
    }
    
    public weak var modifierDelegate:UTSearchModifierDelegate?
    
    //MARK: - Private variables
    private var currentModifierAttachment:UTModifierTypeTextAttachment? = nil
    private var completionString:NSAttributedString? {
        didSet {
            if oldValue != completionString {
                self.needsDisplay = true
            }
        }
    }
    
    private var currentAcceptedModifiers:[String:(UTModifierType,String)]{
        var filteredModifiers = [String:(UTModifierType, String)]()
        
        if hasModifier(.with) {
            filteredModifiers = supportedModifers.filter({return $0.value.0 == .with})
        }
        else if hasModifier(.sharedIn) || hasModifier(.sharedBy) {
            filteredModifiers = supportedModifers.filter({return $0.value.0 != .with})
        }
        else{
            filteredModifiers = supportedModifers
        }
        
        return filteredModifiers
    }
    
    private var supportedModifers:[String:(UTModifierType, String)] = [:]
    private var hasResultModifier = false
    
    //MARK: - Initialisation
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    override func initialise() {
        
        super.initialise()
        
        self.allowsEditingTextAttributes = true        
        self.style = .globalSearch
        self.size = .medium
        (self.cell as? UTBaseTextFieldCellProtocol)?.setFixedHeight(value: 20)
        self.layer?.cornerRadius = self.size.height / 2        
    }
    
    
    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if let str = completionString{

            let currentStringSize = self.attributedStringValue.size()
            var drawPoint = NSMakePoint(currentStringSize.width + 3, 0)
            
            var shouldDraw = true
            
            if let c = cell as? UTTextFieldCell {
                let updatedRect = c.updatedDrawingRect
                drawPoint.x += updatedRect.origin.x
                drawPoint.y += updatedRect.origin.y
                
                let w = drawPoint.x + str.size().width
                if w > (updatedRect.width + updatedRect.origin.x){
                    shouldDraw = false
                }
            }
            
            if shouldDraw{
                str.draw(at: drawPoint)
            }
        }
    }
    
    public override func textDidChange(_ notification: Notification) {
        let lowerString = self.stringValue.lowercased()
        if !isModifierSearch{

            if let selectedRange = self.currentEditor()?.selectedRange{
                showCompletionTextIfNeeded(currentRange: selectedRange)
            }
            
            for acceptedModifier in currentAcceptedModifiers{
                let lowerModifier = acceptedModifier.0.lowercased()
                
                if let matchedRange = lowerString.range(of: lowerModifier){
                    //Check if there is either a whitespace before it or the matched range is at position 0
                    if lowerString.distance(from: lowerString.startIndex, to: matchedRange.lowerBound) == 0{
                        let r = lowerString.NSRangeFromRange(matchedRange)
                        replaceTextWithModifierType(acceptedModifier.1.0, range: r)
                        modifierDelegate?.modifierSearchStringDetected(self, type: acceptedModifier.1.0)
                    }
                    else{
                        let range = (lowerString.index(before: matchedRange.lowerBound) ..< matchedRange.upperBound)
                        let nsr = lowerString.NSRangeFromRange(range)
                        if isCharacterInRangeModifierOrWhiteSpace(nsr){
                            let r = lowerString.NSRangeFromRange(matchedRange)
                            removeStringAndInsertModifier(acceptedModifier.1.0, range: r)
                            modifierDelegate?.modifierSearchStringDetected(self, type: acceptedModifier.1.0)
                        }
                    }
                }
            }
        }
        else{
            //See if we still contain the modifier and if it has been deleted set
            if(!containsTypeAttachment()){
                if let type = currentModifierAttachment?.type{
                    currentModifierAttachment = nil
                    modifierDelegate?.modifierSearchStringRemoved(self, type: type)
                }
            }
        }
        
        //See if full result modifier was removed
        if hasResultModifier{
            if modifiers.isEmpty{
                hasResultModifier = false
                modifierDelegate?.allSearchResultModifiersRemoved(textField: self)
            }
        }
        
        restyleAttributedText()
        super.textDidChange(notification)
    }
    
    public func clearSearch(){
        self.stringValue = ""
        self.currentModifierAttachment = nil
        self.hasResultModifier = false
        self.completionString = nil
        
        self.needsDisplay = true
    }
    
    public func setSupportedModifiers(modifiers:[String:(UTModifierType,String)]) {
        self.supportedModifers = modifiers
    }
    
    public func hasModifier(_ modifierType:UTModifierType) -> Bool {
        return modifiers.contains(where: { $0.type == modifierType })
    }
    
    private func showCompletionTextIfNeeded(currentRange:NSRange){
        guard currentModifierAttachment == nil else { return }
        
        let str = self.stringValue.lowercased()
        let lastWord = getLastWordCharacters(searchString)
        let completionChars = getCompletionStringForWord(lastWord)

        guard !completionChars.isEmpty else {
            completionString = nil
            return
        }
        
        guard let rangeOfString = str.range(of: str) else {
            completionString = nil
            return
        }

        let nsRangeOfString = str.NSRangeFromRange(rangeOfString)

        if currentRange.location == (nsRangeOfString.location + nsRangeOfString.length) && currentRange.length == 0{
            self.completionString = getCompletionAttributedString(completionChars)
        }
        else{
            completionString = nil
        }
    }
    
    func completeModifierString() -> Bool{
        
        if completionString != nil{
            
            completionString = nil
            let lastWord = self.getLastWordCharacters(searchString)
            let modifier = getCompletionModifier(lastWord)
            
            if let range = self.stringValue.range(of: lastWord, options: NSString.CompareOptions.backwards){
                self.replaceTextWithModifierType(modifier, range: self.stringValue.NSRangeFromRange(range))
                modifierDelegate?.modifierSearchStringDetected(self, type:modifier)
            }
            
            return true
        }
        
        return false
    }
    
    override internal func focusStateChanged(isFocused:Bool){
        super.focusStateChanged(isFocused: isFocused)
        
        completionString = nil
        self.needsDisplay = true
    }
    
    private func restyleAttributedText(){
        let fontColor = self.textColor!
        let attrString = NSMutableAttributedString(attributedString: removeNewLineCharacters(self.attributedStringValue))
        let fullTextRange = NSMakeRange(0, attrString.length)
        
        attrString.enumerateAttribute(NSAttributedString.Key.attachment,
            in: fullTextRange,
            options: .longestEffectiveRangeNotRequired,
            using: { (value:Any?, range: NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                if !(value is UTModifierTextAttachment){
                    attrString.setAttributes([NSAttributedString.Key : Any](), range: range)
                    attrString.setAttributes([NSAttributedString.Key.font : self.font!,
                                              NSAttributedString.Key.foregroundColor : fontColor], range: range)
                }
            })
        
        self.attributedStringValue = attrString
    }
    
    private func removeNewLineCharacters(_ attrString:NSAttributedString) -> NSAttributedString{
        
        let attrString = NSMutableAttributedString()
        let fullTextRange = NSMakeRange(0, attributedStringValue.length)
        
        self.attributedStringValue.enumerateAttribute(NSAttributedString.Key.attachment,
            in: fullTextRange,
            options: .longestEffectiveRangeNotRequired,
            using: {[weak self] (value:Any?, range: NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                if let a = value as? UTModifierTextAttachment{
                    attrString.append(NSAttributedString(attachment: a))
                }
                else{
                    if let a = self?.attributedStringValue.attributedSubstring(from: range){
                        attrString.append(NSAttributedString(string: a.string.replaceNewlineCharactersWithWhitespace()))
                    }
                }
        })
        
        return attrString
    }
    
    func replaceTextWithModifierType(_ modifier:UTModifierType, range:NSRange){
        let currentAttrString = NSMutableAttributedString(attributedString: attributedStringValue)
        let modifierAttributedString = NSAttributedString(attachment: createModifierAttachement(modifier))
        
        currentAttrString.replaceCharacters(in: range, with: modifierAttributedString)
        self.attributedStringValue = currentAttrString
    }
    
    fileprivate func isCharacterInRangeModifierOrWhiteSpace(_ r:NSRange) -> Bool{
        var isMatch = false
        
        self.attributedStringValue.enumerateAttribute(NSAttributedString.Key.attachment,
            in: NSMakeRange(r.location, r.length),
            options: .longestEffectiveRangeNotRequired,
            using: {[weak self] (value:Any?, range: NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            
                if value is UTModifierTypeTextAttachment{
                    isMatch = true
                }
                else if value is UTModifierWithResultAttachment{
                    isMatch = true
                }
                else{
                    if let attrString = self?.attributedStringValue.attributedSubstring(from: NSMakeRange(r.location, 1)){
                        if attrString.string == " "{
                            isMatch = true
                        }
                    }
                }
        })
        
        return isMatch
    }
    
    private func containsTypeAttachment() -> Bool{
        
        var containsTypeModifier = false
        
        self.attributedStringValue.enumerateAttribute(NSAttributedString.Key.attachment,
            in: NSMakeRange(0, attributedStringValue.length),
            options: .longestEffectiveRangeNotRequired,
            using: { (value:Any?, range: NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                if value is UTModifierTypeTextAttachment{
                    containsTypeModifier = true
                    return
                }
        })
        
        return containsTypeModifier
    }
    
    func removeStringAndInsertModifier(_ modifier:UTModifierType, range:NSRange){
        
        let currentAttrString = NSMutableAttributedString(attributedString: attributedStringValue)
        let modifierAttributedString = NSAttributedString(attachment: createModifierAttachement(modifier))
        
        currentAttrString.replaceCharacters(in: range, with: "")
        
        //Change this to add it to the end of the current tokens
        currentAttrString.insert(modifierAttributedString, at: range.location)
        self.attributedStringValue = currentAttrString
        
        
        //Should I hide other modifiers at this point
    }
    
    fileprivate func getCompletionModifier(_ str:String) -> UTModifierType{
        
        for acceptedModifier in currentAcceptedModifiers{
            let modText = acceptedModifier.0.lowercased()
            
            if modText.hasPrefix(str){
                return acceptedModifier.1.0
            }
        }
        
        return .unknown
    }
    
    private func getModifierString(modifierType: UTModifierType) -> String {
        for (_, (type, displayString)) in supportedModifers {
            if type == modifierType {
                return displayString
            }
        }
        
        return "unknown"
    }
    
    private func getLastWordCharacters(_ str:String) -> String{
        let words = str.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        
        return words.last ?? str
    }
    
    internal func getCompletionStringForWord(_ str:String) -> String{
        let lowerStr = str.lowercased()
        
        for acceptedModifier in self.currentAcceptedModifiers{
            let modText = acceptedModifier.0.lowercased()
            
            if modText == lowerStr{
                return ""
            }
            
            if modText.hasPrefix(lowerStr){
                
                if let r = modText.range(of: lowerStr) {
                    return String(modText[r.upperBound...])
                }
            }
        }
        
        return ""
    }
    
    internal func getCompletionAttributedString(_ string:String) -> NSAttributedString{
        let style = NSMutableParagraphStyle()
        style.alignment = self.alignment
        var attsDictionary = [NSAttributedString.Key.foregroundColor: self.style.placeholderTextColorStates.normal,
                               NSAttributedString.Key.paragraphStyle: style]
        attsDictionary[NSAttributedString.Key.font] = self.font
        
        let attrString = NSMutableAttributedString.init(string: string, attributes: attsDictionary as [NSAttributedString.Key : Any])
        return attrString
    }
    
    fileprivate func getPlainTextAfterModifier() -> String{
        var returnString = ""
        
        self.attributedStringValue.enumerateAttribute(NSAttributedString.Key.attachment,
            in: NSMakeRange(0, attributedStringValue.length),
            options: .longestEffectiveRangeNotRequired,
            using: {[weak self] (value:Any?, range: NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                
                if value is UTModifierTypeTextAttachment{
                    
                    if let attrString = self?.attributedStringValue{
                        let locationAfterModifier = range.location + range.length
                        let lengthOfRemainingString = attrString.length - locationAfterModifier
                        
                        if lengthOfRemainingString > 0{
                            let restOfString = NSMakeRange(locationAfterModifier, lengthOfRemainingString)
                            returnString = attrString.attributedSubstring(from: restOfString).string
                            return
                        }
                    }
                }
        })
        
        return returnString
    }
    
    fileprivate func getSearchStringWithoutModifiers(_ atrributedString:NSAttributedString) -> String{
        var plainString:String = ""
        
        atrributedString.enumerateAttribute(NSAttributedString.Key.attachment,
            in: NSMakeRange(0, attributedStringValue.length),
            options: .longestEffectiveRangeNotRequired,
            using: { (value:Any?, range: NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                
                if value is UTModifierTextAttachment{
                    
                }
                else{
                    let stringWithoutModifier = atrributedString.attributedSubstring(from: range)
                    plainString += stringWithoutModifier.string
                }
        } )
        
        return plainString
    }
    
    public func insertModifierType(type: UTModifierType) {
        let currentAttrString = NSMutableAttributedString(attributedString: attributedStringValue)

        let modifierAttachment = createModifierAttachement(type)

        let attrString = NSAttributedString(attachment: modifierAttachment)
        currentAttrString.append(attrString)
        self.attributedStringValue = currentAttrString
    }
    
    
    public func getSearchModifiers(withFilter valueAsModifier: (Any?) -> UTModifier?) -> [UTModifier] {
        var modifiers:[UTModifier] = []
        
        self.attributedStringValue.enumerateAttribute(NSAttributedString.Key.attachment,
            in: NSMakeRange(0, attributedStringValue.length),
            options: .longestEffectiveRangeNotRequired,
            using: { (value:Any?, range: NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                
                if let modifierAttachment = value as? UTModifierWithResultAttachment {
                    modifiers.append(modifierAttachment.modifier)
                }
        })

        return modifiers
    }
    
    fileprivate func replaceTypeModifierWithResultModifierRemovingTextAfter(_ resultModifier:UTModifierWithResultAttachment){
    
        let modifiedAttrString = NSMutableAttributedString()
        var plainStringLeftOfType:String = ""
        var matched = false
        
        self.attributedStringValue.enumerateAttribute(NSAttributedString.Key.attachment,
            in: NSMakeRange(0, attributedStringValue.length),
            options: .longestEffectiveRangeNotRequired,
            using: {[weak self] (value:Any?, range: NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                
                if let modifier = value as? UTModifierTypeTextAttachment{
                    if modifier.type == resultModifier.modifier.type {
                        modifiedAttrString.append(NSAttributedString(attachment: resultModifier))
                        matched = true
                        return
                    }
                    else{
                        assert(false)
                    }
                }
                else if let modifier = value as? UTModifierWithResultAttachment{
                    modifiedAttrString.append(NSAttributedString(attachment: modifier))
                }
                else{
                    if !matched{
                        if let attrStringValue = self?.attributedStringValue{
                            plainStringLeftOfType.append(attrStringValue.attributedSubstring(from: range).string)
                        }
                    }
                }
        } )
        
        
        if !plainStringLeftOfType.isEmpty{
            plainStringLeftOfType = plainStringLeftOfType.trimWhiteSpace()
            modifiedAttrString.append(NSAttributedString(string: plainStringLeftOfType))
        }
        
        guard let fontColor = self.textColor else { return }
        guard let theFont = self.font else { return }
        
        modifiedAttrString.addAttributes([NSAttributedString.Key.font : theFont,
                                          NSAttributedString.Key.foregroundColor: fontColor], range: NSMakeRange(0, modifiedAttrString.length))
        
        self.attributedStringValue = modifiedAttrString        
    }
 
    public func insertModifier(_ modifier: UTModifier, withDisplayString displayString: String){

        let modifierName = getModifierString(modifierType:modifier.type)
        let modifierAttachment = createModifierAttachement(modifierName+displayString, modifier:modifier)

        if currentModifierAttachment != nil{
            replaceTypeModifierWithResultModifierRemovingTextAfter(modifierAttachment)
        }
        else{
            self.attributedStringValue = NSAttributedString(attachment: modifierAttachment)
        }

        currentModifierAttachment = nil
        hasResultModifier = true

        modifierDelegate?.modifierCompleted(self, modifier: modifier)
    }

    private func createModifierAttachement(_ displayString:String, modifier: UTModifier) -> UTModifierWithResultAttachment{
        return UTModifierWithResultAttachment.create(displayString: displayString, modifier: modifier)
    }
    
    private func createModifierAttachement(_ modifierType: UTModifierType) -> UTModifierTypeTextAttachment{
        let modifierName = getModifierString(modifierType:modifierType)
        let modifierAttachment = UTModifierTypeTextAttachment.create(displayString: modifierName, modifierType: modifierType)
        currentModifierAttachment = modifierAttachment
        
        return modifierAttachment
    }
    
    override func updateLeadingCellPadding(addLeadingIconPadding:Bool){
        guard hasLeadingIconPadding != addLeadingIconPadding else { return }
        
        hasLeadingIconPadding = addLeadingIconPadding
        if let cell = self.cell as? UTBaseTextFieldCellProtocol {
            
            if hasLeadingIconPadding{
                cell.updateLeadingPadding(value:  UTTextFieldCellGlobalHeaderIconLeadingPadding)                
            }
            else{
                cell.updateLeadingPadding(value: UTTextFieldCellDefaultLeadingPadding)
            }
        }
    }
    
    
    //TODO: Both functions added for non global header case is it still needed
    func removeStringAndInsertAttachment(displayString:String, range:NSRange){
        
        let currentAttrString = NSMutableAttributedString(attributedString: attributedStringValue)
        let modifierAttributedString = NSAttributedString(attachment: getTextAttachement(displayString: displayString))

        currentAttrString.replaceCharacters(in: range, with: "")
        currentAttrString.insert(modifierAttributedString, at: range.location)
        
        self.attributedStringValue = currentAttrString
    }
    
    private func getTextAttachement(displayString: String) -> UTModifierTextAttachment{
        let textAttachment = UTModifierTextAttachment(displayString: displayString)
        let textAttachmentCell = ModifierAttachmentCell()
        textAttachmentCell.font = UTFontType.subheaderSecondary.font()
        textAttachment.attachmentCell = textAttachmentCell

        return textAttachment
    }
    
}

//MARK: - NSTextViewDelegate
extension UTSearchModifierTextField : NSTextViewDelegate{
    public func textViewDidChangeSelection(_ notification: Notification) {
        if let notObj = notification.object as? NSText, let currentEditor = self.currentEditor(){
            if notObj == currentEditor{
                showCompletionTextIfNeeded(currentRange: currentEditor.selectedRange)
            }
        }
    }
    public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        var bHandled = false
        
        if !isModifierSearch{
            if commandSelector == #selector(NSResponder.insertTab(_:)) || commandSelector == #selector(NSResponder.moveRight(_:)){
                bHandled = completeModifierString()

                if !bHandled{
                    return modifierDelegate?.controlDoCommandBySelector(self, commandSelector: commandSelector) ?? false
                }
                
                return true
            }
        }
        
        return modifierDelegate?.controlDoCommandBySelector(self, commandSelector: commandSelector) ?? false
    }
}
