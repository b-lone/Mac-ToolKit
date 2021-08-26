//
//  NSImag+SparkExtensions.swift
//  SparkMacDesktop
//
//  Created by James Nestor on 07/10/2015.
//  Copyright © 2015 Cisco Systems. All rights reserved.
//

import Foundation

extension NSImage
{
//    public typealias RoundingFunc = (_: CGImage, _: CGRect) -> CGImage?
//    public func roundImage(withRoundingFunc roundingFunc: RoundingFunc = AvatarHelper.sharedInstance.applyRounding) -> NSImage {
//        guard let imageRep = representations.first else { return self }
//
//        /*
//         Use the imageRep size (pixelsWidth and pixelsHigh) instead of self.size for the imageRect since the NSImage.size might not be be the actual
//         image size we want to use when applying the rounding: https://stackoverflow.com/questions/9264051/nsimage-size-not-real-size-with-some-pictures
//         NSImage.size and the imageRep size are often the same, but some metadata within an image can make these be different values.
//         */
//        var imageRect:CGRect = CGRect(x: 0, y: 0, width: imageRep.pixelsWide, height: imageRep.pixelsHigh)
//        if let imageRef = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil){
//            if let roundedCGImage = roundingFunc(imageRef, imageRect) {
//                return NSImage.init(cgImage: roundedCGImage, size:  NSZeroSize)
//            }
//        }
//
//        return self
//    }
//
//    public class func generateThumbnail(_ filePath: String, maxWidth: CGFloat) -> NSImage? {
//        // Try to create an NSImage - if this fails, then don't generate a preview
//        if ContentUploadUtilsProxy.isImage(filePath), let image = NSImage(contentsOfFile: filePath) {
//            let fileUrl = URL(fileURLWithPath: filePath)
//            if let imageSource = CGImageSourceCreateWithURL(fileUrl as CFURL, nil) {
//                if image.size.width > maxWidth {
//                    let scaleFactor: CGFloat = maxWidth/image.size.width
//                    let previewSize = CGSize(width: image.size.width * scaleFactor, height: image.size.height * scaleFactor)
//                    let options: [NSString: Any] = [kCGImageSourceThumbnailMaxPixelSize: max(previewSize.width, previewSize.height) , kCGImageSourceCreateThumbnailFromImageAlways: true, kCGImageSourceCreateThumbnailWithTransform : true]
//                    if let previewCGImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary?) {
//                        let previewImage: NSImage = NSImage.init(cgImage: previewCGImage, size: previewSize)
//                        return previewImage
//                    }
//                } else {
//                    // return the original image if it's smaller that what we want to generate for the preview
//                    return image
//                }
//            }
//        }
//
//        // If we can't generate an image, then it's not an image file so uplaod without a preview or thumbnail
//        return nil
//    }
//
    @objc public func resizeImage(_ maxWidth: CGFloat) -> NSImage? {

        if self.size.width > maxWidth  {
            let scaleFactor: CGFloat = maxWidth/self.size.width
            let height = self.size.height * scaleFactor
            let width = self.size.width * scaleFactor
            return resize(withSize: NSSize(width: width, height: height))

        } else {
            return self
        }
    }
//
//    @objc public func resizeHeightToFit(frameHeight: CGFloat) -> NSImage{
//
//        let scaleFactor:CGFloat = frameHeight / self.size.height
//        let height = frameHeight
//        let width = self.size.width * scaleFactor
//
//        let img = NSImage(size: CGSize(width: width, height: height))
//
//        img.lockFocus()
//        let ctx = NSGraphicsContext.current
//        ctx?.imageInterpolation = .high
//        self.draw(in: NSMakeRect(0, 0, width, height), from: NSMakeRect(0, 0, size.width, size.height), operation: .copy, fraction: 1)
//        img.unlockFocus()
//
//        return img
//    }
//
//    public func getImgWithRect(rect: NSRect) -> NSImage {
//        let img = NSImage(size: CGSize(width: rect.width, height: rect.height))
//
//        img.lockFocus()
//        let ctx = NSGraphicsContext.current
//        ctx?.imageInterpolation = .high
//        self.draw(in: NSMakeRect(0, 0, rect.width, rect.height), from: NSMakeRect(rect.minX, rect.minY, rect.width, rect.height), operation: .copy, fraction: 1)
//        img.unlockFocus()
//
//        return img
//    }
//
    func resize(withSize targetSize: NSSize) -> NSImage? {
        let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
            return representation.draw(in: frame)
        })

        return image
    }
//
//
//    func resizeMaintainingAspectRatio(withSize targetSize: NSSize) -> NSImage? {
//        let newSize: NSSize
//        let widthRatio = targetSize.width / size.height
//        let heightRatio = targetSize.height / size.width
//
//        if widthRatio > heightRatio {
//            newSize = NSSize(width: floor(size.width * widthRatio),
//                             height: floor(size.height * widthRatio))
//        }
//        else {
//            newSize = NSSize(width: floor(size.width * heightRatio),
//                             height: floor(size.height * heightRatio))
//        }
//        return self.resize(withSize: newSize)
//    }
////
//
//    func crop(toSize targetSize: NSSize) -> NSImage? {
//        guard let resizedImage = resizeMaintainingAspectRatio(withSize: targetSize) else {
//            return nil
//        }
//
//        let croppedImage = resizedImage.cropImage(toSize: targetSize)
//        return croppedImage
//    }
//
//    public func cropImage(toSize targetSize: NSSize) -> NSImage {
//        let outImage = NSImage.init(size: targetSize)
//        let rect = CGRect(x: floor(targetSize.width/2 - self.size.width/2),
//                      y: floor(targetSize.height/2 - self.size.height/2),
//                      width: self.size.width,
//                      height: self.size.height)
//        outImage.lockFocus()
//        self.draw(in: rect)
//        outImage.unlockFocus()
//
//        return outImage
//    }
//
//    func getCroppedImage(proportion: CGFloat) -> NSImage {
//        if proportion < 0 {
//            return self
//        }
//        let srcRect = NSMakeRect(0, 0, size.width, size.height)
//        let destRect = getDestRect(srcRect: srcRect, proportion: proportion)
//        let newImage = NSImage.init(size: destRect.size);
//        newImage.lockFocus()
//        draw(in: NSMakeRect(0, 0, destRect.size.width, destRect.size.height), from: destRect, operation: .sourceOver, fraction: 1.0)
//        newImage.unlockFocus()
//
//        return newImage
//    }
//
//    private func getDestRect(srcRect: NSRect, proportion: CGFloat) -> NSRect {
//        let originWidth = srcRect.size.width
//        let originHeight = srcRect.size.height
//        if originWidth == proportion * originHeight {
//            return srcRect;
//        }
//
//        var newRect = srcRect
//        if (originWidth > proportion * originHeight) {
//            newRect.origin.x = (originWidth - proportion * originHeight) / 2
//            newRect.size.width = proportion * originHeight
//        } else {
//            newRect.origin.y = (originHeight - originWidth / proportion) / 2
//            newRect.size.height = originWidth / proportion
//        }
//        return newRect
//    }
//
//    public class func createImageFromIconType(icon:MomentumIconType, color:CCColor?) -> NSImage?{
//
//        guard let font = NSFont(name: Constants.momentumIconFont, size: 16) else { return nil }
//
//        var attributes = [NSAttributedString.Key.font: font,
//                          NSAttributedString.Key.foregroundColor: SemanticThemeManager.getColors(for: .textPrimary).normal]
//
//        if let color = color{
//            attributes[NSAttributedString.Key.foregroundColor] = color
//        }
//
//        let strIcon:NSString = NSString(string: icon.ligature)
//        let img = NSImage(size:NSMakeSize(20, 20))
//        img.lockFocus()
//        strIcon.draw(at: NSMakePoint(3, 2), withAttributes: attributes)
//        img.unlockFocus()
//
//        return img
//    }
//
//    public func cropImageForAvatar(_ rect: CGRect) -> NSImage {
//
//        let outImage = NSImage.init(size: NSSize(width: rect.width, height: rect.height))
//        var imageSize = self.size
//        if (imageSize.height < imageSize.width) {
//            imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
//            imageSize.height = rect.size.height;
//        } else {
//            imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
//            imageSize.width = rect.size.width;
//        }
//        let rect = CGRect(x: rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
//                      y: rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
//                      width: imageSize.width,
//                      height: imageSize.height)
//        outImage.lockFocus()
//        self.draw(in: rect)
//        outImage.unlockFocus()
//
//        return outImage
//    }
//
//    @objc public func getPngRepresentation() -> NSData? {
//
//        if let tiff = self.tiffRepresentation {
//            if let bitmap = NSBitmapImageRep(data:tiff) {
//                if let data = bitmap.representation(using: NSBitmapImageRep.FileType.png, properties:[:]) {
//                    return data as NSData
//                }
//            }
//        }
//        return nil
//    }
//
//    public func savePNG(to url: URL) -> Bool {
//        do {
//            try getPngRepresentation()?.write(to: url)
//            return true
//        } catch {
//            print(error)
//            return false
//        }
//    }
//
    public static func getMultiWindowsImage(windowIds:[UInt32], callback:@escaping (NSImage?)->Void) {
        
        let pointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: windowIds.count)
        
        for i in 0..<windowIds.count{
            let windowId = UInt(windowIds[i])
            pointer[i] = UnsafeRawPointer(bitPattern: windowId)
        }
        
        var img:NSImage? = nil
        if let cfArray = CFArrayCreate(kCFAllocatorDefault, pointer, windowIds.count, nil){
            
            if let cgImg = CGImage(windowListFromArrayScreenBounds: CGRect.null, windowArray: cfArray, imageOption: CGWindowImageOption.bestResolution){
                img = NSImage(cgImage: cgImg, size: NSSize(width: cgImg.width, height: cgImg.height))
            }
        }
        
        pointer.deinitialize(count: windowIds.count)
        
        callback(img)
    }
    
    public static func getWindowImage(winId:UInt32, imageOptions:CGWindowImageOption = CGWindowImageOption(rawValue: 0), callback:@escaping (NSImage?)->Void) {
        var img:NSImage? = nil
        
        if let cgimg = CGWindowListCreateImage(CGRect.null, CGWindowListOption.optionIncludingWindow, winId, imageOptions){
            img = NSImage(cgImage: cgimg, size: NSSize(width: cgimg.width, height: cgimg.height))
        }
        
        callback(img)
    }
    
    public static func getScreenshot(displayId:UInt32, callback:@escaping (NSImage?)->Void) {
        var img : NSImage? = nil
        if let cgimg = CGDisplayCreateImage(displayId){
            img = NSImage(cgImage: cgimg, size: NSSize(width: cgimg.width, height: cgimg.height))
        }
        callback(img)
    }
//
//    public static func isImageUnderAvatarSizeThreshold(_ path: String) -> Bool {
//        var fileSize : UInt64 = 0
//        do {
//            let attr : NSDictionary? = try FileManager.default.attributesOfItem(atPath: path) as NSDictionary?
//            if let _attr = attr {
//                fileSize = _attr.fileSize();
//            }
//        }
//        catch {
//            SPARK_LOG_ERROR("attributesOfItemAtPath failed to get the attributes of " + path)
//        }
//        if fileSize < (1024 * 1024) {
//            return true
//        }
//
//        return false
//    }
//
//    func roundCorners(xRadius : CGFloat, yRadius : CGFloat) -> NSImage {
//        let width = self.size.width
//        let height = self.size.height
//        let newImage = NSImage(size: self.size)
//        newImage.lockFocus()
//        let context = NSGraphicsContext.current
//        context?.imageInterpolation = NSImageInterpolation.high
//
//        let imageFrame = NSRect(x: 0, y: 0, width: width, height: height)
//        let path = NSBezierPath(roundedRect: imageFrame,
//                                            xRadius: xRadius,
//                                            yRadius: yRadius)
//        path.windingRule = .evenOdd
//        path.addClip()
//        let rect = NSRect(x: 0, y: 0, width: width, height: height)
//        self.draw(at: NSPoint.zero, from: rect, operation: .sourceOver, fraction: 1)
//        newImage.unlockFocus()
//        return newImage
//    }
}
