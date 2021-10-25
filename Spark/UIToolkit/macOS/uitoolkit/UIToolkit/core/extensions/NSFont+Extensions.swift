//
//  NSFont+Extensions.swift
//  UIToolkit
//
//  Created by James Nestor on 13/05/2021.
//

import Cocoa

extension NSFont {

    public class func loadFonts(in bundle:Bundle) {
        
        // Register Fonts
        let paths = bundle.paths(forResourcesOfType: "ttf", inDirectory: "") + bundle.paths(forResourcesOfType: "otf", inDirectory: "")
        for path in paths {
            let url = URL(fileURLWithPath: path)
            var errorRef: Unmanaged<CFError>?
            let registrationSuccess = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &errorRef)
            if !registrationSuccess{
                NSLog("Failed to register font")
            }
        }
    }
    
    public class func loadUIToolKitFonts(){
        loadFonts(in: Bundle.main)
    }
    
    public static func getIconFont() -> NSFont? {
        return getIconFont(size: 18)
    }
    
    public static func getIconFont(size: CGFloat) -> NSFont? {
        return NSFont(name : "momentum-ui-icons-rebrand", size :  size)
    }
    
    
    public static func calculateMaxFontSizeForGivenHeight(_ fontWeight:NSFont.Weight, containerHeight:CGFloat, minFontRangeSize:Int, maxFontRangeSize:Int) -> CGFloat {
        let basisString = "Basis String"
        let minFontSize = minFontRangeSize < 1 ? 0 : (minFontRangeSize - 1)
        for fontSize in stride(from: maxFontRangeSize, to: minFontSize, by: -1){
            
            let font = NSFont.systemFont(ofSize: CGFloat(fontSize), weight:fontWeight)
            let attributedString = NSAttributedString( string: basisString,
                                                       attributes: [NSAttributedString.Key.font : font ] )
            let stringSize = attributedString.size()
            if stringSize.height <= containerHeight{
                return CGFloat(fontSize)
            }
        }
        
        return CGFloat(minFontRangeSize);
    }
    
    public static func calculateMaxFontSizeForGivenHeight(_ fontName:String, containerHeight:CGFloat, minFontRangeSize:Int, maxFontRangeSize:Int) -> CGFloat {
        
        let basisString = "Basis String"
        
        let minFontSize = minFontRangeSize < 1 ? 0 : (minFontRangeSize - 1)
        
        for fontSize in stride(from: maxFontRangeSize, to: minFontSize, by: -1){
            
            if let font = NSFont(name: fontName, size: CGFloat(fontSize)){
                let attributedString = NSAttributedString( string: basisString,
                                                           attributes: [NSAttributedString.Key.font : font ] )
                let stringSize = attributedString.size()
                if stringSize.height <= containerHeight{
                    return CGFloat(fontSize)
                }
            }
        }
        
        return CGFloat(minFontRangeSize);
    }
    
    
}
