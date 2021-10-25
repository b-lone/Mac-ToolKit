//
//  UTPopoverViewController.swift
//  UIToolkit
//
//  Created by James Nestor on 24/05/2021.
//

import Cocoa

class UTPopoverViewController: UTBaseViewController {
    
    //Add stackview as the container for the main content. This will allow padding to be added easily.
    //Some popovers contain a close X button in the top right hand corner which will require padding of 8
    private (set) var stackView = NSStackView()
        
    //Keep strong reference to keep view controller alive
    private var contentViewController:NSViewController?
    
    private var cancelButton:UTCancelIconButton?
    
    init(style: UTPopoverView.Style = .primary ){
        super.init(nibName: nil, bundle: nil)
        let popover = UTPopoverView()
        popover.style = style
        self.view = popover
        stackView.wantsLayer = true
        stackView.distribution = .fill
        stackView.setHuggingPriority(.required, for: .vertical)        
        self.view.setAsOnlySubviewAndFill(subview: stackView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        NSLog("deinit UTPopoverViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //View did load will never be called as this is not loading a xib file
    }
    
    override func setThemeColors() {
        super.setThemeColors()
        self.view.window?.appearance = NSAppearance.getThemedAppearance()
        (self.view as? UTPopoverView)?.setThemeColors()
    }
    
    func setMainContentViewController(viewController:NSViewController){
        contentViewController = viewController
        let contentView = viewController.view
        self.preferredContentSize = contentView.frame.size
        stackView.addView(contentView, in: .leading)
    }
    
    func isMainContenetViewController(viewController:NSViewController) -> Bool {
        return contentViewController == viewController
    }
    
    func addCancelButtion(){
        
        guard contentViewController != nil else{
            assert(false, "contentViewController should be added first")
            return
        }
        
        guard self.cancelButton == nil else {
            NSLog("Cancel button already exists ignoring")
            return
        }
        
        let cancelButton = UTCancelIconButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.target = self
        cancelButton.action = #selector(UTPopoverViewController.cancelButtonAction)
        self.view.addSubview(cancelButton)

        let trailingConstraint = NSLayoutConstraint.createTrailingSpaceToViewConstraint(firstItem: cancelButton, secondItem: self.view, constant: -8)
        let topConstraint = NSLayoutConstraint.createTopSpaceToViewConstraint(firstItem: cancelButton, secondItem: self.view, constant: 8)
        NSLayoutConstraint.activate([trailingConstraint, topConstraint])
        
        self.cancelButton = cancelButton
        
        stackView.edgeInsets.right = 8
        stackView.edgeInsets.top = 8
        self.preferredContentSize = NSMakeSize(self.preferredContentSize.width + 8, self.preferredContentSize.height + 8)
    }
    
    @IBAction func cancelButtonAction(_ sender: AnyObject) {
        self.view.window?.performClose(self)
    }
    
}
