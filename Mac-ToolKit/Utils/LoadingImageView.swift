//
//  LoadingImageView.swift
//  SparkMacDesktop
//
//  Created by James Nestor on 14/03/2018.
//  Copyright © 2018 Cisco Systems. All rights reserved.
//

import Cocoa

extension LoadingImageView{
    
    enum SpinnerSize:String{
        case small  = "spinner_16"
        case normal = "spinner_28"
        case medium = "spinner_32"
        case large  = "spinner_36"
        case extraLarge = "spinner_50"
    }
    
    enum SpinnerColour {
        case blackWhite
        case green
    }
}

class LoadingImageView: CSIRotatingImageView {

    var isLightBackground = true
    
    func loadImageIfNeeded(onLightBackground:Bool, spinnerSize:LoadingImageView.SpinnerSize = .normal, spinnerColor: SpinnerColour = .blackWhite){
        
        if isLightBackground != onLightBackground || self.image == nil{
            
            isLightBackground = onLightBackground
        
            switch spinnerColor {
            case .blackWhite:
                let imageToLoad = onLightBackground ? spinnerSize.rawValue : spinnerSize.rawValue + "_w"
                self.image = Bundle.getImageInSparkBundle(imageName: imageToLoad)
            case .green:
                let imageToLoad = spinnerSize.rawValue + "_g"
                self.image = Bundle.getImageInSparkBundle(imageName: imageToLoad)
            }
        }
    }
    
}
