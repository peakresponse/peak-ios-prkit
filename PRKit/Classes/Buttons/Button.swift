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
    case primary, secondary, tertiary, destructive, destructiveSecondary, destructiveTertiary, warning
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
                setImage(UIImage(named: bundleImage, in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
            } else {
                setImage(nil, for: .normal)
            }
        }
    }

    open var isLayoutVerticalAllowed = true
    open var isLayoutVertical = false {
        didSet {
            if isLayoutVertical {
                titleLabel?.lineBreakMode = .byWordWrapping
                titleLabel?.numberOfLines = 0
                titleLabel?.textAlignment = .center
            } else {
                titleLabel?.lineBreakMode = .byTruncatingMiddle
                titleLabel?.numberOfLines = 1
                titleLabel?.textAlignment = .left
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
        isLayoutVertical = false
        updateStyle()
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        updateStyle()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let horizontalIntrinsicContentSize = intrinsicContentSizeForLayout(false)
        if !isLayoutVertical && frame.width < horizontalIntrinsicContentSize.width {
            // only re-layout to vertical if there's an icon or the text has multiple words that can wrap
            if isLayoutVerticalAllowed && (image(for: .normal) != nil || title(for: .normal)?.contains(" ") ?? false) {
                isLayoutVertical = true
                setNeedsLayout()
            }
        } else if isLayoutVertical && frame.width > horizontalIntrinsicContentSize.width {
            isLayoutVertical = false
            setNeedsLayout()
        }
    }

    open override var intrinsicContentSize: CGSize {
        return intrinsicContentSizeForLayout(isLayoutVertical)
    }

    open func intrinsicContentSizeForLayout(_ isLayoutVertical: Bool) -> CGSize {
        var size = super.intrinsicContentSize
        var font: UIFont
        switch self.size {
        case .small:
            font = .body14Bold
            size.height = font.lineHeight + 26
        case .medium:
            font = .h3SemiBold
            size.height = font.lineHeight + 40
        case .large:
            font = .h2Bold
            size.height = font.lineHeight + 40
        }
        let image = self.image(for: .normal)
        let title = self.title(for: .normal)
        if image != nil && title != nil {
            size.width += 4
        }
        if isLayoutVertical {
            // recalculate using frame.width and dynamic height
            size.width = frame.width
            size.height = contentEdgeInsets.top + contentEdgeInsets.bottom
            if let image = image {
                size.height += imageEdgeInsets.top + image.size.height + imageEdgeInsets.bottom
            }
            if let title = title {
                if image != nil {
                    size.height += 4
                }
                let bounds = CGSize(width: frame.width - contentEdgeInsets.left - contentEdgeInsets.right -
                                    titleEdgeInsets.left - titleEdgeInsets.right,
                                    height: .greatestFiniteMagnitude)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byWordWrapping
                size.height += titleEdgeInsets.top + (title as NSString).boundingRect(with: bounds,
                                                                                      options: [.usesLineFragmentOrigin],
                                                                                      attributes: [
                                                                                         .font: font,
                                                                                         .paragraphStyle: paragraphStyle
                                                                                      ],
                                                                                      context: nil).height + titleEdgeInsets.bottom
                size.height = round(size.height)
            }
        }
        return size
    }

    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.imageRect(forContentRect: contentRect)
        rect.size = image(for: .normal)?.size ?? .zero
        if isLayoutVertical {
            rect.origin.x = contentRect.origin.x +
                            floor((contentRect.width - imageEdgeInsets.left - imageEdgeInsets.right - rect.width) / 2)
            rect.origin.y = contentRect.origin.y + imageEdgeInsets.top
        } else {
            rect.origin.y = floor((frame.height - rect.height) / 2)
            if title(for: .normal) != nil {
                rect.origin.x -= 2
            }
        }
        return rect
    }

    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        var rect = super.titleRect(forContentRect: contentRect)
        let image = self.image(for: .normal)
        if isLayoutVertical {
            if let image = image {
                rect.origin.x = contentRect.origin.x + titleEdgeInsets.left
                rect.origin.y = contentRect.origin.y + imageEdgeInsets.top + image.size.height + imageEdgeInsets.bottom +
                                titleEdgeInsets.top + 4
                rect.size.width = contentRect.width
                rect.size.height = contentRect.height - rect.origin.y + contentRect.origin.y
            }
        } else {
            if image != nil {
                rect.origin.x += 2
            }
        }
        return rect
    }

    open override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        updateStyle()
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
            setBackgroundImage(.resizableImage(withColor: .brandPrimary500, cornerRadius: 8), for: .normal)
            setBackgroundImage(.resizableImage(withColor: .brandPrimary600, cornerRadius: 8), for: .highlighted)
            setBackgroundImage(.resizableImage(withColor: .base300, cornerRadius: 8), for: .disabled)
            setTitleAttributes(font: font, color: .white, for: .normal)
            setTitleAttributes(font: font, color: .white, for: .highlighted)
            setTitleAttributes(font: font, color: .white, for: .disabled)
            tintColor = .white
        case .secondary:
            setBackgroundImage(.resizableImage(withColor: .white, cornerRadius: 8,
                                               borderColor: .brandPrimary500, borderWidth: borderWidth), for: .normal)
            setBackgroundImage(.resizableImage(withColor: .brandPrimary100, cornerRadius: 8,
                                               borderColor: .brandPrimary600, borderWidth: borderWidth), for: .highlighted)
            setBackgroundImage(.resizableImage(withColor: .white, cornerRadius: 8,
                                               borderColor: .base300, borderWidth: borderWidth), for: .disabled)
            fallthrough
        case .tertiary:
            setTitleAttributes(font: font, color: .brandPrimary500, for: .normal)
            setTitleAttributes(font: font, color: .brandPrimary600, for: .highlighted)
            setTitleAttributes(font: font, color: .base300, for: .disabled)
            tintColor = isEnabled ? .brandPrimary500 : .base300
        case .destructive:
            setBackgroundImage(.resizableImage(withColor: .triageImmediateMedium, cornerRadius: 8), for: .normal)
            setBackgroundImage(.resizableImage(withColor: .triageImmediateDark, cornerRadius: 8), for: .highlighted)
            setBackgroundImage(.resizableImage(withColor: .triageImmediateLight, cornerRadius: 8), for: .disabled)
            setTitleAttributes(font: font, color: .white, for: .normal)
            setTitleAttributes(font: font, color: .white, for: .highlighted)
            setTitleAttributes(font: font, color: .white, for: .disabled)
            tintColor = .white
        case .destructiveSecondary:
            setBackgroundImage(.resizableImage(withColor: .white, cornerRadius: 8,
                                               borderColor: .triageImmediateMedium, borderWidth: borderWidth), for: .normal)
            setBackgroundImage(.resizableImage(withColor: .triageImmediateLight, cornerRadius: 8,
                                               borderColor: .triageImmediateMedium, borderWidth: borderWidth), for: .highlighted)
            setBackgroundImage(.resizableImage(withColor: .white, cornerRadius: 8,
                                               borderColor: .triageImmediateLight, borderWidth: borderWidth), for: .disabled)
            fallthrough
        case .destructiveTertiary:
            setTitleAttributes(font: font, color: .triageImmediateMedium, for: .normal)
            setTitleAttributes(font: font, color: .triageImmediateMedium, for: .highlighted)
            setTitleAttributes(font: font, color: .triageImmediateLight, for: .disabled)
            tintColor = isEnabled ? .triageImmediateMedium : .triageImmediateLight
        case .warning:
            setBackgroundImage(.resizableImage(withColor: .brandSecondary500, cornerRadius: 8), for: .normal)
            setBackgroundImage(.resizableImage(withColor: .brandSecondary800, cornerRadius: 8), for: .highlighted)
            setBackgroundImage(.resizableImage(withColor: .brandSecondary400, cornerRadius: 8), for: .disabled)
            setTitleAttributes(font: font, color: .white, for: .normal)
            setTitleAttributes(font: font, color: .white, for: .highlighted)
            setTitleAttributes(font: font, color: .white, for: .disabled)
            tintColor = .white
        }
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    func setTitleAttributes(font: UIFont, color: UIColor, for state: UIControl.State) {
        setAttributedTitle(NSAttributedString(string: title(for: state) ?? "", attributes: [
            .font: font,
            .foregroundColor: color
        ]), for: state)
    }
}
