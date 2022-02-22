//
//  Chip.swift
//  PRKit
//
//  Created by Francis Li on 2/21/22.
//

import UIKit

public enum ChipSize: String {
    case small, medium, large
}

@IBDesignable
open class Chip: UIButton {
    @IBInspectable open var color: UIColor = .base300 {
        didSet { updateStyle() }
    }

    @IBInspectable open var bundleImage: String? {
        didSet {
            if let bundleImage = bundleImage {
                setImage(UIImage(named: bundleImage, in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
            } else {
                setImage(nil, for: .normal)
            }
        }
    }

    open var size: ChipSize = .medium {
        didSet { updateStyle() }
    }
    @IBInspectable open var Size: String {
        get { return size.rawValue }
        set { size = ChipSize(rawValue: newValue) ?? .medium }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
        updateStyle()
    }

    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        switch self.size {
        case .small:
            size.height = 26
            size.width += 18
            if image(for: .normal) != nil && title(for: .normal) != nil {
                size.width -= 8
            }
        case .medium:
            size.height = 36
            size.width += 28
        case .large:
            size.height = 40
        }
        return size
    }

    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.imageRect(forContentRect: contentRect)
        switch size {
        case .small:
            rect.size = CGSize(width: 16, height: 16)
            rect.origin.x += 2
        case .medium:
            rect.size = CGSize(width: 24, height: 24)
            rect.origin.x -= 2
        case .large:
            rect.size = CGSize(width: 32, height: 32)
        }
        rect.origin.y = floor((frame.height - rect.height) / 2)
        return rect
    }

    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.titleRect(forContentRect: contentRect)
        if image(for: .normal) != nil {
            switch size {
            case .small:
                rect.origin.x -= 2
            case .medium:
                break
            case .large:
                break
            }
        }
        return rect
    }
    open func updateStyle() {
        var cornerRadius: CGFloat
        var font: UIFont
        switch size {
        case .small:
            cornerRadius = 13
            font = .body14Bold
        case .medium:
            cornerRadius = 18
            font = .h4SemiBold
        case .large:
            cornerRadius = 20
            font = .h4
        }
        setBackgroundImage(UIImage.resizableImage(withColor: color, cornerRadius: cornerRadius), for: .normal)
        setBackgroundImage(UIImage.resizableImage(withColor: color, cornerRadius: cornerRadius), for: .disabled)
        setTitleAttributes(font: font, color: titleColor(for: .normal) ?? .base800, for: .normal)
    }

    private func setTitleAttributes(font: UIFont, color: UIColor, for state: UIControl.State) {
        setAttributedTitle(NSAttributedString(string: title(for: state) ?? "", attributes: [
            .font: font,
            .foregroundColor: color
        ]), for: state)
    }
}
