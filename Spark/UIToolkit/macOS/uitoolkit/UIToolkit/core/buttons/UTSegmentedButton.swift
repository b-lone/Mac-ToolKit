//
//  UTSegmentedButton.swift
//  UIToolkit
//
//  Created by chehuan2 on 2021/10/22.
//

import Cocoa

public class SegmentedButtonModel {
    var label: String
    var accessibilityLabel: String
    var iconType: MomentumRebrandIconType? = nil
    var tooltip: UTTooltipType? = nil
    
    public init(label: String, accessibilityLabel: String, iconType: MomentumRebrandIconType?, tooltip: UTTooltipType?) {
        self.label = label
        self.accessibilityLabel = accessibilityLabel
        self.iconType = iconType
        self.tooltip = tooltip
    }
}

public protocol UTSegmentedButtonDelegate : AnyObject{
    func segmentedButtonDidClick(sender: UTSegmentedButton, index: Int)
}

private extension NSUserInterfaceLayoutOrientation {
    var stackViewAlignment: NSLayoutConstraint.Attribute {
        switch self {
        case .vertical:
            return .centerX
        case .horizontal:
            return .centerY
        @unknown default:
            return .leading
        }
    }
}

public class UTSegmentedButton: UTHoverableView {
    
    public weak var delegate: UTSegmentedButtonDelegate?
    
    public var orientation: NSUserInterfaceLayoutOrientation = .horizontal {
        didSet {
            updateData()
        }
    }
    public var segmentedButtonModels: [SegmentedButtonModel] = [] {
        didSet {
            updateData()
        }
    }
        
    public var buttonHeight: ButtonHeight = .medium {
        didSet {
            for button in buttons {
                button.buttonHeight = buttonHeight
            }
        }
    }

    public var style: UTButton.Style = .primary {
        didSet {
            for button in buttons {
                button.style = style
            }
        }
    }
    
    public var showSplitLine: Bool = true {
        didSet {
            updateData()
        }
    }
    
    private var buttons: [UTSplitButton] = []

    private lazy var containerStackView: NSStackView = {
        let containerStackView = NSStackView()
        containerStackView.wantsLayer = true
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.orientation = orientation
        containerStackView.spacing = -1
        return containerStackView
    }()

    override func initialise() {
        super.popoverBehavior = .semitransient
        self.wantsLayer = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setAsOnlySubviewAndFill(subview: containerStackView)
    }

    @objc
    private func buttonDidClick(_ sender: UTSplitButton) {
        removeToolTip()
        if let index = buttons.firstIndex(of: sender) {
            delegate?.segmentedButtonDidClick(sender: self, index: index)
        }
    }
    
    private func updateData() {
        buttons.removeAll()
        containerStackView.removeAllViews()
        containerStackView.orientation = orientation
        containerStackView.alignment = orientation.stackViewAlignment
        for (index, model) in segmentedButtonModels.enumerated() {
            let button = UTSplitButton()
            setupButtonStyle(button, index: index)
            setupButtonModel(button, model: model)
            button.target = self
            button.action = #selector(buttonDidClick(_:))
            buttons.append(button)
            containerStackView.addArrangedSubview(button)
        }
    }
    
    private func setupButtonStyle(_ button:UTSplitButton, index: Int) {
        button.oriantation = orientation
        switch orientation {
        case .horizontal:
            if segmentedButtonModels.count == 1 {
                button.roundSetting = .pill
            } else if index == 0 {
                button.roundSetting = .lhs
            } else if index == segmentedButtonModels.endIndex - 1 {
                button.roundSetting = .rhs
            } else {
                button.buttonType = .square
                button.roundSetting = .none
            }
        case .vertical:
            if segmentedButtonModels.count == 1 {
                button.roundSetting = .pill
            } else if index == 0 {
                button.roundSetting = .top
            } else if index == segmentedButtonModels.endIndex - 1 {
                button.roundSetting = .bottom
            } else {
                button.buttonType = .square
                button.roundSetting = .none
            }
        @unknown default:
            fatalError()
        }
    }

    private func setupButtonModel(_ button:UTButton, model: SegmentedButtonModel) {
        if !model.label.isEmpty {
            button.title = model.label
        }
        if !model.accessibilityLabel.isEmpty {
            button.setAccessibilityLabel(model.accessibilityLabel)
        }
        if let icon = model.iconType {
            button.fontIcon = icon
        }
        if let tooltip = model.tooltip {
            button.addUTToolTip(toolTip: tooltip)
        }
    }

    public func toggleEnabled(_ isEnabled: Bool, at index:Int) {
        guard let button = buttons.getItemAtIndex(index) else {
            return
        }
        button.isEnabled = isEnabled
    }

    public override func setThemeColors() {
        for button in buttons {
            button.setThemeColors()
        }
        self.needsDisplay = true
    }

    public override var intrinsicContentSize: NSSize{
        let height = buttons.reduce(0) { $0 + $1.intrinsicContentSize.height }
        let width = buttons.reduce(0) { $0 + $1.intrinsicContentSize.width }
        return NSSize(width: width, height: height)
    }
}
