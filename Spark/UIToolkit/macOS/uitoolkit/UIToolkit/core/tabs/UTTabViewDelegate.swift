//
//  UTTabViewDelegate.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 28/05/2021.
//

import Cocoa

public protocol UTTabViewDelegate : AnyObject{
    func tabView(_ tabView: UTTabView, didSelect tabViewItem: UTTabButton )
    func tabView(_ tabView: UTTabView, didRightClick tabViewItem: UTTabButton)
}

