import Foundation
import Cocoa

extension NSImage {
    
    
    @objc public func resizeImage(maxWidth: CGFloat) -> NSImage? {
        if self.size.width > maxWidth  {
            let scaleFactor: CGFloat = maxWidth/self.size.width
            let width = self.size.width * scaleFactor
            let targetSize =  NSSize(width: width, height: width)
            
            let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
            guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
                return nil
            }
            let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
                return representation.draw(in: frame)
            })

            return image
            
        } else {
            return self
        }
    }
    
    @objc var cgImage: CGImage? {
      get {
        guard let imageData = self.tiffRepresentation else { return nil }
        guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
      }
    }
    

    public func roundImage() -> NSImage {
        
        guard let imageRep = representations.first else { return self }

        /*
         Use the imageRep size (pixelsWidth and pixelsHigh) instead of self.size for the imageRect since the NSImage.size might not be be the actual
         image size we want to use when applying the rounding: https://stackoverflow.com/questions/9264051/nsimage-size-not-real-size-with-some-pictures
         NSImage.size and the imageRep size are often the same, but some metadata within an image can make these be different values.
         */
        
        let width =  imageRep.pixelsWide > 0 ? CGFloat(imageRep.pixelsWide) : self.size.width
        let height = imageRep.pixelsHigh > 0 ? CGFloat(imageRep.pixelsHigh) : self.size.height
        
        var imageRect:CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        if let imageRef = self.cgImage(forProposedRect: &imageRect, context: nil, hints: nil){
            if let roundedCGImage = applyRounding(imageRef, imageRect: imageRect) {
                return NSImage.init(cgImage: roundedCGImage, size:  NSZeroSize)
            }
        }
        return self
    }
    
    private func applyRounding(_ imageRef:CGImage, imageRect:CGRect) -> CGImage? {
        let colorSpace =  imageRef.colorSpace
        if let context = CGContext (data: nil, width: Int(imageRect.width), height: Int(imageRect.height), bitsPerComponent: imageRef.bitsPerComponent, bytesPerRow: 0, space: colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue){
            context.saveGState()
            context.beginPath()
            let circleFrame = NSMakeRect(1.0, 1.0, imageRect.size.width - 2 , imageRect.size.height - 2 )
            let bPath = NSBezierPath(ovalIn: circleFrame)
            context.addPath(bPath.cgPath)
            context.closePath();
            context.clip();
            context.draw(imageRef, in: CGRect(x: 0, y: 0, width: imageRect.width, height: imageRect.height))
            
            if let clippedImage = context.makeImage(){
                context.restoreGState()
                return clippedImage
            }
        }
        return nil
    }
    
    
    public func cropImageForAvatar(_ rect: CGRect) -> NSImage {
        
        let outImage = NSImage.init(size: NSSize(width: rect.width, height: rect.height))
        var imageSize = self.size
        if  imageSize.height < imageSize.width {
            imageSize.width = floor((imageSize.width/imageSize.height) * rect.size.height);
            imageSize.height = rect.size.height;
        } else {
            imageSize.height = floor((imageSize.height/imageSize.width) * rect.size.width);
            imageSize.width = rect.size.width;
        }
        let rect = CGRect(x: rect.origin.x + floor(rect.size.width/2 - imageSize.width/2),
                      y: rect.origin.y + floor(rect.size.height/2 - imageSize.height/2),
                      width: imageSize.width,
                      height: imageSize.height)
        outImage.lockFocus()
        self.draw(in: rect)
        outImage.unlockFocus()
        
        return outImage
    }
}

