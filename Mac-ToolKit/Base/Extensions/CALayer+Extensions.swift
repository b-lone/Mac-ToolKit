//
//  CALayer+Extensions.swift
//  Mac-ToolKit
//
//  Created by Archie You on 2021/10/28.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Foundation
extension CALayer {
    func initializeSpinner(speed: Double = 1.33, clockWise: Bool = true) -> CABasicAnimation {
        
        self.isHidden = false
        let angle = clockWise ? -(Double.pi * 2.0): (Double.pi * 2.0)
        
        let spinningAnimation = CABasicAnimation(keyPath: Constants.rotationKeyPath)
        spinningAnimation.fromValue = 0.0
        spinningAnimation.toValue = angle
        spinningAnimation.duration = (1/speed)
        spinningAnimation.repeatCount = .infinity
        
        return spinningAnimation
    }
}

