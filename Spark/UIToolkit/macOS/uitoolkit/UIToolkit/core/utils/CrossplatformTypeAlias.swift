//
//  SparkColor.swift
//  SparkMacDesktop
//
//  Created by Jimmy Coyne on 27/05/2018.
//  Copyright © 2018 Cisco Systems. All rights reserved.
//

import Foundation

//CC common cocoa,
//TODO - this code is replicated in CocoaFrameworks.h, see if we can remove this file.

#if os(macOS)
   import Cocoa
   public typealias CCView = NSView
   public typealias CCColor = NSColor
   public typealias CCFont = NSFont
   public typealias CCImage = NSImage
   public typealias CCRect = NSRect
#else
  import UIKit
   public typealias CCView = UIView
   public typealias CCColor = UIColor
   public typealias CCFont = UIFont
   public typealias CCImage = UIImage
   public typealias CCRect = CGRect
#endif



