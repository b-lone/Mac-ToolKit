//
//  ShareSourceVM.swift
//  Mac-Toolkit
//
//  Created by Archie You on 2021/8/26.
//  Copyright © 2021 Cisco. All rights reserved.
//

import Cocoa

class ShareSourceVM : NSObject {
    
    @objc public init(sourceId:String, name:String){
        self.sourceId = sourceId
        self.name = name
    }
    
    public var sourceId : String
    public var name : String
    
    override public var description:String{
        get{
            return "[name:\(name)] - [sourceId:\(sourceId)]"
        }
    }
}
