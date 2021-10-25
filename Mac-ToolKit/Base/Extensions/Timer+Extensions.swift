//
//  Timer+Extensions.swift
//  WebexTeams
//
//  Created by avangipu on 8/27/20.
//  Copyright © 2020 Cisco Systems. All rights reserved.
//

import Foundation

protocol SparkTimerProtocol: AnyObject {
    var isValid: Bool { get }
    func startTimer(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool)
    func startTimer(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool, forMode mode: RunLoop.Mode)
    func stopTimer()
}

class SparkTimer: SparkTimerProtocol & NSObject {
    
    private weak var timer: Timer?
    
    var isValid: Bool {
        return timer?.isValid ?? false
    }
    
    func startTimer(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool) {
        timer = Timer.scheduledTimer(timeInterval: ti, target: aTarget, selector: aSelector, userInfo: userInfo, repeats: yesOrNo)
    }
    
    func startTimer(timeInterval ti: TimeInterval, target aTarget: Any, selector aSelector: Selector, userInfo: Any?, repeats yesOrNo: Bool, forMode mode: RunLoop.Mode) {
        let aTimer = Timer(timeInterval: ti, target: aTarget, selector: aSelector, userInfo: userInfo, repeats: yesOrNo)
        RunLoop.current.add(aTimer, forMode: mode)
        timer = aTimer
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
}
