//
//  Subject.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/9/30.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

protocol SubjectProtocl {
    associatedtype Observer
    func registerObserver(observer: Observer)
    func unRegisterObserver(observer: Observer)
}

class Subject<Observer>: NSObject {
    var observerList = [Observer]()
    
    func addObserver(observer: Observer) {
//        if !observerList.contains(where: { $0 === observer }) {
//            SPARK_LOG_DEBUG("\(type(of: observer)) \(observer)")
//            observerList.append(observer)
//        }
    }
    
    func removeObserver(observer: Observer) {
//        SPARK_LOG_DEBUG("\(type(of: observer)) \(observer)")
//        observerList.removeAll { $0 === observer }
    }
}
