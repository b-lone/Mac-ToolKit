//
//  NSTabView2.swift
//  UIToolkit
//
//  Created by Jimmy Coyne on 27/05/2021.
//

import Cocoa

public enum Placement {
    case leading
    case centre
    case trailing
    case top
    case bottom
    
    internal func toGravity() -> NSStackView.Gravity {
        switch self {
        case .centre:
            return .center
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        case .top:
            return .top
        case .bottom:
            return .bottom
        }
    }
}

private class TabComponent {
    var button: UTTabButton
    var tabViewItem: NSTabViewItem?
    
    init(button:UTTabButton, tabViewItem: NSTabViewItem? ) {
        self.button = button
        self.tabViewItem = tabViewItem
    }
    
    convenience init(button:UTTabButton) {
        self.init(button: button, tabViewItem: nil)
    }
}

public class UTTabView: UTView {
    
    public var selectedTabItem: UTTabItem? {
        for (tabItem, component) in self.tabComponentsMap {
            
            if component.button.state == .on {
                return tabItem
            }
        }
        return nil
    }
    
    override public var nextKeyView: NSView? {
        didSet{
            if tabButtonStackView != nil {
                tabButtonStackView.nextKeyView = nextKeyView
                super.nextKeyView = tabButtonStackView
            }
        }
    }
    
    internal var tabButtonContainerSize:CGFloat = 28
    private var tabButtonStackView:UTTabStackView!
    private var tabAreaView: NSTabView!
    private var tabComponentsMap:[UTTabItem:TabComponent] = [:]
    private var containerStackView:NSStackView!
    
    public weak var delegate:UTTabViewDelegate?
    
    internal var orientation:NSUserInterfaceLayoutOrientation = .horizontal
    
    override func initialise() {
        
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Container for tab view buttons and tab view area
        containerStackView = NSStackView(frame: self.bounds)
        containerStackView.wantsLayer = true
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.orientation  = orientation
        containerStackView.distribution = .fillProportionally
        containerStackView.alignment    = orientation == .horizontal ? .leading : .top
        containerStackView.spacing      = 0
        self.setAsOnlySubviewAndFill(subview: containerStackView)
        
        let tabButtonStackViewWidth  = orientation == .horizontal ? frame.width : tabButtonContainerSize
        let tabButtonStackViewHeight = orientation == .horizontal ? tabButtonContainerSize : frame.height
        
        // Container for tab buttons to switch between tabs
        let stackFrame = NSMakeRect(0,0, tabButtonStackViewWidth, tabButtonStackViewHeight)
        tabButtonStackView = UTTabStackView(frame:stackFrame)
        tabButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        tabButtonStackView.wantsLayer = true
        tabButtonStackView.orientation = orientation
        tabButtonStackView.distribution = .gravityAreas
        tabButtonStackView.setHuggingPriority(.required, for: orientation == .horizontal ? .vertical : .horizontal)
        tabButtonStackView.setHuggingPriority(.defaultLow, for: orientation == .horizontal ? .horizontal : .vertical)
        tabButtonStackView.useSystemFocusRing = true
        
        let tabAreaViewWidth  = orientation == .horizontal ? frame.width : frame.width - tabButtonContainerSize
        let tabAreaViewHeight = orientation == .vertical ? frame.height : frame.height - tabButtonContainerSize
        
        // Tab area
        let tabFrame = NSMakeRect(0,0, tabAreaViewWidth, tabAreaViewHeight )
        tabAreaView = NSTabView(frame: tabFrame)
        tabAreaView.translatesAutoresizingMaskIntoConstraints = false
        tabAreaView.tabViewType = .noTabsNoBorder
        tabAreaView.tabViewBorderType = .none
        tabAreaView.delegate = self
        
        containerStackView.addArrangedSubview(tabButtonStackView)
        containerStackView.addArrangedSubview(tabAreaView)
        
        tabButtonStackView.delegate = self
        
        if orientation == .horizontal {
            tabButtonStackView.upDownChangeSelection    = false
            tabButtonStackView.leftRigthChangeSelection = true
        }
        else {
            tabButtonStackView.upDownChangeSelection    = true
            tabButtonStackView.leftRigthChangeSelection = false
        }
        
        super.initialise()
    }
    
    public func setTabButtonEdgeInsets(edgeInsets:NSEdgeInsets) {
        tabButtonStackView.edgeInsets = edgeInsets
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
        tabButtonStackView.setThemeableViewColors()
    }
    
    public func clipping(allow: Bool) {
        if allow {
            tabButtonStackView.setClippingResistancePriority(.defaultLow, for: .horizontal)
        } else {
            tabButtonStackView.setClippingResistancePriority(.defaultHigh, for: .horizontal)
        }
    }
    
    
    public func renameTab(at tabNumber :Int, name: String, accessibilityLabel: String) {
        
        guard tabNumber >= 0 &&  tabNumber < tabButtonStackView.views.count else {
            return
        }
        
        let button = tabButtonStackView.views[tabNumber]
        if let button = button as? UTTabButton {
            button.title = name
            button.setAccessibilityLabel(accessibilityLabel)
        }
    }
    
    public func enable(at tabNumber :Int, enable: Bool) {
        guard tabNumber >= 0 &&  tabNumber < tabButtonStackView.views.count else {
            return
        }
        let button = tabButtonStackView.views[tabNumber]
        if let button = button as? UTTabButton {
            button.isEnabled = enable
        }
    }

    @discardableResult
    public func removeTab(at tabNumber : Int) -> Bool  {
        guard tabNumber >= 0 &&  tabNumber < tabButtonStackView.views.count else {
            return false
        }
        if let tab =  tabButtonStackView.views[tabNumber] as? UTTabButton {
            return removeTab(tab: tab.tabItem)
        }
        return false
    }
    
    @discardableResult
    public func removeTab(tab: UTTabItem) -> Bool {
        if let tabToRemove = getButton(tab: tab) {
            tabButtonStackView.removeView(tabToRemove)
            
            if let tabComponent = tabComponentsMap[tab] {
                if let nsTab = tabComponent.tabViewItem {
                    tabAreaView.removeTabViewItem(nsTab)
                }
                tabComponentsMap.removeValue(forKey: tab)
            } else {
                assert(false, "issue finding tab in tabarea")
            }
            
           
            return true
        }
        return false
    }
    

    public func addTab(tab: UTTabItem,  placement: Placement = .leading) {
        
    
        
        let button = buildButton(tab: tab)
        
        var tabitem:NSTabViewItem! = nil
        if let vc = tab.viewController {
            tabitem = NSTabViewItem(viewController: vc)
            tabAreaView.addTabViewItem(tabitem)
        }
 
        if tabButtonStackView.views.count == 0 {
            button.setOn(true)
        }
        
        tabButtonStackView.addView(button, in: placement.toGravity())
        let tabComponent = TabComponent(button: button, tabViewItem: tabitem)
        tabComponentsMap[tab] = tabComponent   
    }
    
    // May raise an NSRangeException
    public func insertTab(tab: UTTabItem, at index: Int, placement: Placement = .leading)  {
        
        let button = buildButton(tab: tab)
        var tabItem:NSTabViewItem! = nil
        if let vc = tab.viewController {
            tabItem = NSTabViewItem(viewController: vc)
            tabAreaView.insertTabViewItem(tabItem, at: index)
        }

        let tabComponent:TabComponent
        if tabItem != nil{
            tabComponent = TabComponent(button: button, tabViewItem: tabItem)
        } else {
            tabComponent = TabComponent(button: button)
        }


        tabButtonStackView.insertView(button, at: index, in: placement.toGravity())
        tabComponentsMap[tab] =  tabComponent
    }
    

    public func getTabs()  -> [UTTabItem] {
        var tabs:[UTTabItem] = []
        for case let button as UTTabButton in tabButtonStackView.subviews {
            tabs.append(button.tabItem)
        }
        return tabs
    }
    
    
    public func selectTab(tab: UTTabItem) {
        let button = getButton(tab: tab)
        button?.performClick(self)
    }
    
    public func setArrowOnForTab(for tabItem: UTTabItem, arrowOn: Bool) {
        if let tabComponent = tabComponentsMap[tabItem]{
            tabComponent.button.setArrowState(arrowOn)
        }
    }
        
    public func setSelected(tab: UTTabItem) {
        for case let button as UTTabButton in tabButtonStackView.subviews {
            button.setOn(false)
        }
        let onButton = getButton(tab: tab)
        onButton?.setOn(true)
    }
    
    public func updateBadgeCount(for tabItem: UTTabItem, count:Int) {
        
        if let tabComponent = tabComponentsMap[tabItem]{
            tabComponent.button.updateBadgeCount(count: count)
        }
        
    }
    
    public var count:Int {
        return tabButtonStackView.views.count
    }
    
    public func removeAllTab() {
       let tabs = tabButtonStackView.views
        for tab in tabs {
            tabButtonStackView.removeView(tab)
        }
    }
    
    internal func getButton(tab:UTTabItem) -> UTTabButton? {
        var tabToRemove:UTTabButton? = nil
        for  view in tabButtonStackView.views {
            if let button = view as? UTTabButton  {
                if button.tabItem == tab  {
                    tabToRemove = button
                }
            }
        }
        return tabToRemove
    }
    
    //Private
    internal func buildButton(tab: UTTabItem) -> UTTabButton {
        
        let button = UTTabButton()
        
        if let lhsIcon = tab.lhsElement {
            button.addUIElement(element: .FontIcon(lhsIcon))
            if let lhsIconColorToken = tab.lhsIconColorToken {
                button.iconTokenName = lhsIconColorToken
            }
        }
        
        if tab.badgeCount > 0  {
            button.addUIElement(element: .Badge(tab.badgeCount))
        }
        
        if let image = tab.image {
            
            guard let image = image.resizeImage(maxWidth: button.elementSize.imageWidth) else {
                assert(false, "could not resize image")
                return  UTTabButton()
            }
            button.addUIElement(element: .Image(image))
        }
        
        
        button.title = tab.label
        button.toolTip = tab.tooltip
        
        if tab.enableArrow {
            button.addUIElement(element: .ArrowIcon)
        }
        
        if tab.showUnreadPill {
            button.addUIElement(element: .UnreadPill)
        }
        
        button.target = self
        button.action = #selector(buttonSelected)
        button.tabButtonDelegate = self
        button.tabItem = tab
        
        return button
    }
    
    @IBAction func buttonSelected(_ sender: UTTabButton) {
        for view in tabButtonStackView.views {
            if let button = view as? UTTabButton  {
                if sender == button  {
                        button.setOn(true)
                        if let uttab = button.tabItem {
                            if let comp = tabComponentsMap[uttab] {
                                let nsTab = comp.tabViewItem
                                if nsTab?.tabState == .selectedTab {
                                    continue
                                }
                                tabAreaView.selectTabViewItem(nsTab)
                            }
                            delegate?.tabView(self, didSelect: button )
                    }
                    
                } else {
                    button.setOn(false)
                }
            }
        }
    }
}

//MARK: - NSStackViewDelegate
extension UTTabView: NSStackViewDelegate {
    
    public func stackView(_ stackView: NSStackView, willDetach views: [NSView]) {
   
    }
    
    public func stackView(_ stackView: NSStackView, didReattach views: [NSView]) {
   
    }
}

//MARK: - UTTabButtonDelegate
extension UTTabView: UTTabButtonDelegate {
    public func onRightMouseClick(_ button: UTTabButton) {
        delegate?.tabView(self, didRightClick: button)
    }
}

//MARK: - NSTabViewDelegate
extension UTTabView: NSTabViewDelegate {
    
    public func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
    }
    
    public func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
    }
}

#if DEBUG
extension UTTabView {
    public func getButtonForTest(tab:UTTabItem) -> UTTabButton? {
        return getButton(tab: tab)
    }
}
#endif
