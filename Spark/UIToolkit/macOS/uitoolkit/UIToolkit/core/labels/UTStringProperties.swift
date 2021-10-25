//
//  UTStringProperties.swift
//  UIToolkit
//
//  Created by James Nestor on 23/06/2021.
//

import Cocoa

public class UTHitPosition {
    public enum UTHitPositionType {
        case mentionMe
        case mentionOther
        case mentionAll
        case searchMatch
    }
    
    var range:NSRange
    var type:UTHitPositionType
    
    public init(range:NSRange, type:UTHitPositionType){
        self.range = range
        self.type  = type
    }
}

public class UTStringProperties {
    
    var str:String
    var hitPositions:[UTHitPosition]
    
    public init(str:String){
        self.str     = str
        hitPositions = []        
    }
    
    public init(str:String, hitPositions:[UTHitPosition]){
        self.str          = str
        self.hitPositions = hitPositions
    }
}
