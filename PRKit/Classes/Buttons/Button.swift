//
//  Button.swift
//  PRKit
//
//  Created by Francis Li on 9/27/21.
//

import UIKit

public enum ButtonSize: String {
    case small, medium, large
}

public enum ButtonStyle: String {
    case primary, secondary, tertiary
}

@IBDesignable
open class Button: UIButton {
    @IBInspectable open var l10nKey: String? {
        get { return nil }
        set { setTitle(newValue?.localized, for: .normal); updateStyle() }
    }

    open var size: ButtonSize = .medium {
        didSet { updateStyle() }
    }
    @IBInspectable open var Size: String {
        get { return size.rawValue }
        set { size = ButtonSize(rawValue: newValue) ?? .medium }
    }

    open var style: ButtonStyle = .tertiary {
        didSet { updateStyle() }
    }
    @IBInspectable open var Style: String {
        get { return style.rawValue }
        set { style = ButtonStyle(rawValue: newValue) ?? .tertiary }
    }

    @IBInspectable open var bundleImage: String? {
        didSet {
            if let bundleImage = bundleImage {
                setImage(UIImage(named: bundleImage, in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
            } else {
                setImage(nil, for: .normal)
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        adjustsImageWhenHighlighted = false
        adjustsImageWhenDisabled = false
        updateStyle()
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        updateStyle()
    }

    open override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        switch self.size {
        case .small:
            size.height = UIFont.body14Bold.lineHeight + 26
        case .medium:
            size.height = UIFont.h3SemiBold.lineHeight + 40
        case .large:
            size.height = UIFont.h2Bold.lineHeight + 40
        }
        if image(for: .normal) != nil && title(for: .normal) != nil {
            size.width += 4
        }
        return size
    }

    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.imageRect(forContentRect: contentRect)
        rect.size = image(for: .normal)?.size ?? .zero
        rect.origin.y = floor((frame.height - rect.height) / 2)
        if title(for: .normal) != nil {
            rect.origin.x -= 2
        }
        return rect
    }

    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.titleRect(forContentRect: contentRect)
        if image(for: .normal) != nil {
            rect.origin.x += 2
        }
        return rect
    }

    private func updateStyle() {
        var font: UIFont
        var borderWidth: CGFloat = 3
        switch size {
        case .small:
            borderWidth = 2
            font = .body14Bold
            contentEdgeInsets = UIEdgeInsets(top: 13, left: 20, bottom: 13, right: 20)
        case .medium:
            font = .h3SemiBold
            contentEdgeInsets = UIEdgeInsets(top: 20, left: 28, bottom: 20, right: 28)
        case .large:
            font = .h2Bold
            contentEdgeInsets = UIEdgeInsets(top: 20, left: 28, bottom: 20, right: 28)
        }
        switch style {
        case .primary:
            setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary500, cornerRadius: 8), for: .normal)
            setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary600, cornerRadius: 8), for: .highlighted)
            setBackgroundImage(UIImage.resizableImage(withColor: .base300, cornerRadius: 8), for: .disabled)
            setTitleAttributes(font: font, color: .white, for: .normal)
            setTitleAttributes(font: font, color: .white, for: .highlighted)
            setTitleAttributes(font: font, color: .white, for: .disabled)
            tintColor = .white
        case .secondary:
            setBackgroundImage(UIImage.resizableImage(withColor: .white, cornerRadius: 8,
                                                      borderColor: .brandPrimary500, borderWidth: borderWidth), for: .normal)
            setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary100, cornerRadius: 8,
                                                      borderColor: .brandPrimary600, borderWidth: borderWidth), for: .highlighted)
            setBackgroundImage(UIImage.resizableImage(withColor: .white, cornerRadius: 8,
                                                      borderColor: .base300, borderWidth: borderWidth), for: .disabled)
            fallthrough
        case .tertiary:
            setTitleAttributes(font: font, color: .brandPrimary500, for: .normal)
            setTitleAttributes(font: font, color: .brandPrimary600, for: .highlighted)
            setTitleAttributes(font: font, color: .base300, for: .disabled)
            tintColor = isEnabled ? .brandPrimary500 : .base300
        }
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    private func setTitleAttributes(font: UIFont, color: UIColor, for state: UIControl.State) {
        setAttributedTitle(NSAttributedString(string: title(for: state) ?? "", attributes: [
            .font: font,
            .foregroundColor: color
        ]), for: state)
    }
}
