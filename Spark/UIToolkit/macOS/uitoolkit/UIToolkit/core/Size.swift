
import Cocoa

//IB  values so keep lower case to make configuration less error prone.
public enum ButtonHeight:  String {
    case extralarge
    case large
    case medium
    case small
    case extrasmall
    case unknown
}

public enum UTTextFieldSize {
    
    case extraLarge
    case large
    case medium
    case unknown
    
    var height:CGFloat {
        return UTTextFieldSize.getHeight(size:self)
    }
    
    var font:NSFont {
        return UTTextFieldSize.getFont(size:self)
    }
    
    var clearIconSize:CGFloat {
        return UTTextFieldSize.getClearIconSize(size: self)
    }
    
    static func getFont(size:UTTextFieldSize) -> NSFont {
        switch size{
        case .extraLarge: return UTFontType.bannerPrimary.font()
        case .large:      return UTFontType.bodyPrimary.font()
        case .medium:     return UTFontType.bodySecondary.font()
        case .unknown:    return UTFontType.bodyPrimary.font()
        }
    }
    
    static func getHeight(size:UTTextFieldSize) -> CGFloat {
        switch size{
        case .extraLarge: return 48
        case .large:      return 32
        case .medium:     return 28
        case .unknown:    return 32
        }
    }
    
    static func getClearIconSize(size:UTTextFieldSize) -> CGFloat {
        switch size{
        case .extraLarge: return 16
        case .large:      return 14
        case .medium:     return 12
        case .unknown:    return 14
        }
    }

}

public class TableSizeInfo {
        
    public enum TableRowSize: String{
        case large
        case medium
        case small
    }
    
    public var rowSize:TableRowSize
    
    public init(rowSize: TableRowSize){
        self.rowSize = rowSize
    }
    
    public func getHeaderRowHeight() -> CGFloat {
        return 32
    }
    
    public func getRowHeight() -> CGFloat {
        switch rowSize{
        case .large: return 48
        case .medium: return 40
        case .small: return 32
        }
    }
    
    func getSeparartorRowHeight() -> CGFloat {
        return 8
    }    
}
