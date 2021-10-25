//
//  UTToastWindow.swift
//  UIToolkit
//
//  Created by James Nestor on 08/07/2021.
//

import Cocoa

public class UTToastWindow: NSPanel, ThemeableProtocol {
    
    private let ToastWindowFadeInDuration:TimeInterval = 0.9
    
    public init(contentViewController:NSViewController, hasWindowCloseButton:Bool) {
        let contentRect = contentViewController.view.frame
        let windowStyle:NSWindow.StyleMask = hasWindowCloseButton ? [.borderless, .fullSizeContentView, .closable, .titled, .nonactivatingPanel] : [.borderless, .fullSizeContentView, .titled, .nonactivatingPanel]
        
        super.init(contentRect: contentRect, styleMask: windowStyle, backing: .buffered, defer: true)
        
        self.contentViewController = contentViewController
        initialise()
    }
    
    public init(contentView:NSView, hasWindowCloseButton:Bool) {
        let contentRect = contentView.frame
        let windowStyle:NSWindow.StyleMask = hasWindowCloseButton ? [.borderless, .fullSizeContentView, .closable, .titled, .nonactivatingPanel] : [.borderless, .fullSizeContentView, .titled, .nonactivatingPanel]
        
        super.init(contentRect: contentRect, styleMask: windowStyle, backing: .buffered, defer: true)
        self.contentView = contentView
        initialise()
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        initialise()
    }
    
    func initialise() {
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.isOpaque           = false
        self.backgroundColor    = .clear
        self.hasShadow          = true
        self.level              = .statusBar
        self.titleVisibility    = .hidden
        self.titlebarAppearsTransparent  = true
        self.isMovableByWindowBackground = true
        
        self.standardWindowButton(.closeButton)?.isHidden       = !isClosable
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
        self.standardWindowButton(.zoomButton)?.isHidden        = true
        
    }

    public func fadeIn() {
        self.fadeInWithDuration(ToastWindowFadeInDuration)
    }
    
    //MARK: - ThemeableProtocol
    public func setThemeColors() {
        self.appearance = NSAppearance.getThemedAppearance()
        (self.contentView as? ThemeableProtocol)?.setThemeColors()
    }
}
