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
        set { setTitle(newValue?.localized, for: .normal) }
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

    @IBInspectable open var isLayoutVerticalAllowed: Bool = true
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
        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)
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
        let titleFont = titleLabel?.font ?? .h3SemiBold
        var size = super.intrinsicContentSize
        switch self.size {
        case .small:
            size.height = titleFont.lineHeight + 26
        case .medium, .large:
            size.height = titleFont.lineHeight + 40
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
                                                                                         .font: titleFont,
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

    private func setBackgroundImages() {
        var borderWidth: CGFloat = 3
        switch size {
        case .small:
            borderWidth = 2
            contentEdgeInsets = UIEdgeInsets(top: 13, left: 20, bottom: 13, right: 20)
        case .medium:
            contentEdgeInsets = UIEdgeInsets(top: 20, left: 28, bottom: 20, right: 28)
        case .large:
            contentEdgeInsets = UIEdgeInsets(top: 20, left: 28, bottom: 20, right: 28)
        }
        switch style {
        case .primary:
            setBackgroundImage(.resizableImage(withColor: .primaryButtonNormal, cornerRadius: 8), for: .normal)
            setBackgroundImage(.resizableImage(withColor: .primaryButtonHighlighted, cornerRadius: 8), for: .highlighted)
            setBackgroundImage(.resizableImage(withColor: .primaryButtonDisabled, cornerRadius: 8), for: .disabled)
            tintColor = .primaryButtonTint
        case .secondary:
            setBackgroundImage(.resizableImage(withColor: .secondaryButtonNormal, cornerRadius: 8,
                                               borderColor: .secondaryButtonBorderNormal, borderWidth: borderWidth), for: .normal)
            setBackgroundImage(.resizableImage(withColor: .secondaryButtonHighlighted, cornerRadius: 8,
                                               borderColor: .secondaryButtonBorderHighlighted, borderWidth: borderWidth), for: .highlighted)
            setBackgroundImage(.resizableImage(withColor: .secondaryButtonDisabled, cornerRadius: 8,
                                               borderColor: .secondaryButtonBorderDisabled, borderWidth: borderWidth), for: .disabled)
            fallthrough
        case .tertiary:
            tintColor = isEnabled ? .secondaryButtonTint : .secondaryButtonTintDisabled
        case .destructive:
            setBackgroundImage(.resizableImage(withColor: .triageImmediateMedium, cornerRadius: 8), for: .normal)
            setBackgroundImage(.resizableImage(withColor: .triageImmediateDark, cornerRadius: 8), for: .highlighted)
            setBackgroundImage(.resizableImage(withColor: .triageImmediateLight, cornerRadius: 8), for: .disabled)
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
            tintColor = isEnabled ? .triageImmediateMedium : .triageImmediateLight
        case .warning:
            setBackgroundImage(.resizableImage(withColor: .brandSecondary500, cornerRadius: 8), for: .normal)
            setBackgroundImage(.resizableImage(withColor: .brandSecondary800, cornerRadius: 8), for: .highlighted)
            setBackgroundImage(.resizableImage(withColor: .brandSecondary400, cornerRadius: 8), for: .disabled)
            tintColor = .white
        }
    }

    private func setTitleAttributes() {
        var titleFont: UIFont
        switch size {
        case .small:
            titleFont = .body14Bold
        case .medium:
            titleFont = .h3SemiBold
        case .large:
            titleFont = .h2Bold
        }
        titleLabel?.font = titleFont
        switch style {
        case .primary, .destructive, .warning:
            setTitleColor(.primaryButtonLabelNormal, for: .normal)
            setTitleColor(.primaryButtonLabelNormal, for: .highlighted)
            setTitleColor(.primaryButtonLabelNormal, for: .disabled)
        case .secondary, .tertiary:
            setTitleColor(.secondaryButtonLabelNormal, for: .normal)
            setTitleColor(.secondaryButtonLabelHighlighted, for: .highlighted)
            setTitleColor(.secondaryButtonLabelDisabled, for: .disabled)
        case .destructiveSecondary, .destructiveTertiary:
            setTitleColor(.triageImmediateMedium, for: .normal)
            setTitleColor(.triageImmediateMedium, for: .highlighted)
            setTitleColor(.triageImmediateLight, for: .disabled)
        }
    }

    private func updateStyle() {
        setBackgroundImages()
        setTitleAttributes()
    }
}
