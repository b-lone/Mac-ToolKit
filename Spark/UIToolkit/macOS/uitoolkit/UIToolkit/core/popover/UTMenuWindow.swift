//
//  UTMenuWindow.swift
//  UIToolkit
//
//  Created by James Nestor on 30/08/2021.
//

import Cocoa

public class UTMenuWindow : UTPopoverWindow {
    
    var menuWindowVC: UTMenuWindowViewController!
    
    public convenience init(contentViewController:NSViewController,
                     sender:NSView,
                     bounds:NSRect,
                     edge:NSRectEdge = .minY,
                     makeKey:Bool = true,
                     xPosition: PopoverXPosition = .middle,
                     yPosition: PopoverYPosition = .top,
                     isTransient:Bool = true,
                     preventOffscreen: Bool = true,
                     xOffset:CGFloat = 0,
                     yOffset:CGFloat = 0,
                     shouldShow: Bool = false,
                     listenToFocusChange:Bool = false,
                     identifier:NSUserInterfaceItemIdentifier = NSUserInterfaceItemIdentifier("UTMenuPopover"),
                     delegate:UTPopoverWindowDelegate? = nil){
        
        self.init()
        self.configure(xOffset: xOffset, yOffset: yOffset, isTransient: isTransient, listenToFocusChange: listenToFocusChange, delegate: delegate)
        menuWindowVC.setMainContentViewController(viewController: contentViewController)
        self.identifier = identifier
        self.preventOffScreen = preventOffscreen
        
        
        if shouldShow{
            showRelativeToRect(posView: sender, edge: edge, makeKey: makeKey, xPosition: xPosition, yPosition: yPosition)
        }
    }
    
    public func configure(xOffset:CGFloat = 0, yOffset:CGFloat = 0, isTransient:Bool = true, listenToFocusChange:Bool = false, delegate: UTPopoverWindowDelegate? = nil) {
        transientStyle = isTransient
        self.xOffset = xOffset
        self.yOffset = yOffset
        styleMask = []
        backgroundColor = .clear
        isOpaque = false
        windowToFront = true
        self.isReleasedWhenClosed = false
        self.appearance = NSAppearance.getThemedAppearance()
        self.utPopoverWindowDelegate = delegate
        self.listenToFocusChange = listenToFocusChange

        menuWindowVC = UTMenuWindowViewController()
        self.contentViewController = menuWindowVC
    }
    
    public func setMainContentViewController(viewController:NSViewController) {
        menuWindowVC.setMainContentViewController(viewController: viewController)
    }
}

public class UTSearchResultWindow : UTPopoverWindow, ThemeableProtocol {
    
    var menuWindowVC: UTMenuWindowViewController!
    
    public init() {
        super.init(contentRect: NSMakeRect(0, 0, 300, 300), styleMask: [], backing: .buffered, defer: true)
        configure()
    }
    
    public func configure() {
        self.xOffset = 0
        self.yOffset = 4
        self.isOpaque = false
        self.isReleasedWhenClosed = false
        self.identifier = NSUserInterfaceItemIdentifier("UTSearchResultWindow")
        styleMask = []
        backgroundColor = .clear
        self.appearance = NSAppearance.getThemedAppearance()
        self.hasShadow = true
        self.preventOffScreen = false
        
        menuWindowVC = UTMenuWindowViewController()
        self.contentViewController = menuWindowVC
    }
    
    public func setMainContentViewController(viewController:NSViewController) {
        assert(menuWindowVC != nil)
        menuWindowVC.setMainContentViewController(viewController: viewController)
    }   
    
    public func setSize(size:NSSize){
        menuWindowVC.preferredContentSize = size
        self.setContentSize(size)
    }
    
    public func setThemeColors() {
        menuWindowVC?.setThemeColors()
    }
}

class UTMenuWindowViewController: UTBaseViewController {
    
    //Add stackview as the container for the main content. This will allow padding to be added easily.
    //Some popovers contain a close X button in the top right hand corner which will require padding of 8
    private (set) var stackView = NSStackView()
        
    //Keep strong reference to keep view controller alive
    private var contentViewController:NSViewController?
    
    var backgroundTokenName:String {
        return UIToolkit.shared.isUsingLegacyTokens ? "background-primary" : UTColorTokens.popoverPrimaryBackground.rawValue
    }
    
    var borderTokenName: String {
        return UIToolkit.shared.isUsingLegacyTokens ? "background-quaternary" : UTColorTokens.modalPrimaryBorder.rawValue
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        self.view = NSView()
        self.view.wantsLayer = true
        self.view.layer?.cornerRadius = 12
        self.view.layer?.borderWidth = 1
        stackView.wantsLayer = true
        stackView.distribution = .fill
        stackView.setHuggingPriority(.required, for: .vertical)
        self.view.setAsOnlySubviewAndFill(subview: stackView)
        self.setThemeColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        NSLog("deinit UTMenuWindowViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //View did load will never be called as this is not loading a xib file
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        self.view.window?.appearance = NSAppearance.getThemedAppearance()
        self.view.layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName: backgroundTokenName).normal.cgColor
        self.view.layer?.borderColor = UIToolkit.shared.getThemeManager().getColors(tokenName: borderTokenName).normal.cgColor
    }
    
    func setMainContentViewController(viewController:NSViewController){
        contentViewController = viewController
        let contentView = viewController.view
        self.preferredContentSize = contentView.frame.size
        stackView.addView(contentView, in: .leading)
    }
    
}
