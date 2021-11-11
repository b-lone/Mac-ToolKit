//
//  UTScrollView.swift
//  UIToolkit
//
//  Created by James Nestor on 19/05/2021.
//

import Cocoa

@IBDesignable
public class UTScrollView: NSScrollView, ThemeableProtocol {
    
    public var legacyStyle:UTLegacyScrollerStyle = .customBackground{
        didSet{
            if let vscroller = self.verticalScroller as? UTScroller{
                vscroller.legacyScrollerStyle = legacyStyle
            }
            
            if let hscroller = self.horizontalScroller as? UTScroller{
                hscroller.legacyScrollerStyle = legacyStyle
            }
        }
    }
    
    //MARK: - Lifecycle
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    }
    
    private func initialise(){
        
        self.borderType = .noBorder
        self.horizontalScrollElasticity = .none
        self.drawsBackground = false
        
        initialiseVerticalScroller()
        
        if hasHorizontalScroller{
            if self.horizontalScroller?.isKind(of: UTScroller.self) == false{
                self.horizontalScroller = UTScroller(legacyScrollerStyle:legacyStyle)
                self.horizontalScroller?.wantsLayer = true
            }
        }
                
        setThemeColors()
    }
    
    override public var hasVerticalScroller: Bool {
        didSet {
            if oldValue != hasVerticalScroller {
                initialiseVerticalScroller()
            }
        }
    }
    
    private func initialiseVerticalScroller() {
        if hasVerticalScroller{
            if self.verticalScroller?.isKind(of: UTScroller.self) == false{
                self.verticalScroller = UTScroller(legacyScrollerStyle: legacyStyle)
                self.verticalScroller?.wantsLayer = true
            }
        }
        else {
            self.verticalScroller = nil
        }
    }
    
    override public func viewDidMoveToWindow() {
        if let window = self.window {
            self.appearance = window.appearance
        }
    }
    
    //MARK: - ThemeableProtocol
    public func setThemeColors() {
        if let window = self.window {
            self.appearance = window.appearance
        }
        
        if let vscroller = self.verticalScroller as? ThemeableProtocol{
            vscroller.setThemeColors()
        }
        
        if let hscroller = self.horizontalScroller as? ThemeableProtocol{
            hscroller.setThemeColors()
        }
    }
    
}
