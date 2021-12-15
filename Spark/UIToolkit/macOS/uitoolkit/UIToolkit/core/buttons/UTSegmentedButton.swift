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
    var iconType: MomentumIconsRebrandType? = nil
    var tooltip: UTTooltipType? = nil
    
    public init(label: String, accessibilityLabel: String, iconType: MomentumIconsRebrandType?, tooltip: UTTooltipType?) {
        self.label = label
        self.accessibilityLabel = accessibilityLabel
        self.iconType = iconType
        self.tooltip = tooltip
    }
}

public protocol UTSegmentedButtonDelegate : AnyObject{
    func segmentedButtonDidClick(sender: UTSegmentedButton, index: Int)
}

public protocol UTSegmentedButtonDataSource : AnyObject{
    func segmentedButton(_ segmentedButton: UTSegmentedButton, shouldShowSplitLineAt index: Int) -> Bool
}

public class UTSegmentedButton: UTHoverableView {
    
    public weak var delegate: UTSegmentedButtonDelegate?
    public weak var dataSource: UTSegmentedButtonDataSource? {
        didSet {
            updateData()
        }
    }
    
    public var isEnabled: Bool {
        get {
            buttons.reduce(false) { $0 || $1.isEnabled }
        }
        set {
            for button in buttons {
                button.isEnabled = newValue
            }
        }
    }
    
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

    public var style: UTButton.Style = .layout {
        didSet {
            for button in buttons {
                button.style = style
                if style.hasBorder {
                    button.layer?.borderWidth = 0
                }
            }
            showBorder = style.hasBorder
        }
    }
    
    public var showBorder: Bool = true {
        didSet {
            layer?.borderWidth = showBorder ? 1 : 0
        }
    }
    
    public var cornerRadius: CGFloat? {
        didSet {
            guard let cornerRadius = cornerRadius else { return }
            layer?.cornerRadius = cornerRadius
        }
    }
    
    private var iconOnly: Bool {
        segmentedButtonModels.reduce(true) { $0 && $1.label.isEmpty && $1.iconType != nil}
    }
    
    private var buttons: [UTSplitButton] = []
    private var splitLines: [UTSeparatorLine] = []
    
    // MARK: - Override Methods
    override func initialise() {
        super.initialise()
        super.popoverBehavior = .semitransient
        wantsLayer = true
        translatesAutoresizingMaskIntoConstraints = false
        setAsOnlySubviewAndFill(subview: containerStackView)
    }
    
    public override func layout() {
        super.layout()
        if cornerRadius == nil {
            if orientation == .horizontal {
                layer?.cornerRadius = bounds.height/2
            } else if orientation == .vertical {
                layer?.cornerRadius = bounds.width/2
            }
        }
    }
    
    public override func setThemeColors() {
        super.setThemeColors()
        for button in buttons {
            button.setThemeColors()
        }
        for splitLine in splitLines {
            splitLine.setThemeColors()
        }
        layer?.borderColor = UIToolkit.shared.getThemeManager().getColors(tokenName: UTColorTokens.buttonSecondaryBorder.rawValue).normal.cgColor
        layer?.backgroundColor = UIToolkit.shared.getThemeManager().getColors(tokenName:style.getBackgroundTokenName(on: false)).normal.cgColor
        needsDisplay = true
    }
    
    // MARK: Action Methods
    @objc
    private func buttonDidClick(_ sender: UTSplitButton) {
        removeToolTip()
        if let index = buttons.firstIndex(of: sender) {
            delegate?.segmentedButtonDidClick(sender: self, index: index)
        }
    }
    
    // MARK: - Private Methods
    private func updateData() {
        layer?.borderWidth = showBorder ? 1 : 0
        buttons.removeAll()
        containerStackView.removeAllViews()
        containerStackView.orientation = orientation
        if let alignment = orientation.stackViewAlignment {
            containerStackView.alignment = alignment
        }
        for (index, model) in segmentedButtonModels.enumerated() {
            setupSplitLine(at: index)
            let button = UTSplitButton()
            setupButtonStyle(button, index: index)
            setupButtonModel(button, model: model)
            button.target = self
            button.action = #selector(buttonDidClick(_:))
            button.style = style
            if style.hasBorder {
                button.layer?.borderWidth = 0
            }
            button.isEnabled = isEnabled
            buttons.append(button)
            containerStackView.addArrangedSubview(button)
        }
        setThemeColors()
    }
    
    private func setupSplitLine(at index: Int) {
        let shouldShowSplitLine: Bool
        if let dataSource = dataSource {
            shouldShowSplitLine = dataSource.segmentedButton(self, shouldShowSplitLineAt: index)
        } else {
            shouldShowSplitLine = index > 0
        }
        if shouldShowSplitLine, let direction = orientation.separatorLineDirection {
            let splitLine = UTSeparatorLine(length: 16,direction: direction, token: UTColorTokens.buttonSecondaryBorder, lineWidth: 1.0)
            splitLines.append(splitLine)
            containerStackView.addArrangedSubview(splitLine)
        }
    }
    
    private func setupButtonStyle(_ button:UTSplitButton, index: Int) {
        button.oriantation = orientation
        switch orientation {
        case .horizontal:
            if segmentedButtonModels.count == 1 {
                button.roundSetting = .pill
            } else if index == 0 {
                button.roundSetting = .leading
            } else if index == segmentedButtonModels.endIndex - 1 {
                button.roundSetting = .trailing
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

    // MARK: - Public Methods
    public func toggleEnabled(_ isEnabled: Bool, at index:Int) {
        guard let button = buttons.getItemAtIndex(index) else {
            return
        }
        button.isEnabled = isEnabled
    }
    
    public func isEnabled(at index: Int) -> Bool {
        guard buttons.hasIndex(index) else {
            return false
        }
        return buttons[index].isEnabled
    }
    
    // MARK: - Lazy Init
    private lazy var containerStackView: NSStackView = {
        let containerStackView = NSStackView()
        containerStackView.wantsLayer = true
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.orientation = orientation
        containerStackView.spacing = 0
        containerStackView.distribution = .fill
        return containerStackView
    }()
}

extension UTButton.Style {
    var hasBorder: Bool {
        return self == .layout
    }
}

private extension NSUserInterfaceLayoutOrientation {
    var stackViewAlignment: NSLayoutConstraint.Attribute? {
        switch self {
        case .vertical:
            return .centerX
        case .horizontal:
            return .centerY
        @unknown default:
            return nil
        }
    }
    var separatorLineDirection:UTSeparatorLine.Direction? {
        switch self {
        case .horizontal:
            return .vertical
        case .vertical:
            return .horizontal
        @unknown default:
            return nil
        }
    }
}
