//
//  Button.swift
//  PRKit
//
//  Created by Francis Li on 9/27/21.
//

import UIKit

enum ButtonSize: String {
    case small, medium, large
}

enum ButtonStyle: String {
    case primary, secondary, tertiary
}

@IBDesignable
class Button: UIButton {
    var size: ButtonSize = .medium {
        didSet { updateStyle() }
    }
    @IBInspectable var Size: String {
        get { return size.rawValue }
        set { size = ButtonSize(rawValue: newValue) ?? .medium }
    }

    var style: ButtonStyle = .tertiary {
        didSet { updateStyle() }
    }
    @IBInspectable var Style: String {
        get { return style.rawValue }
        set { style = ButtonStyle(rawValue: newValue) ?? .tertiary }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        updateStyle()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
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
            setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary500, cornerRadius: 8), for: .normal)
            setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary600, cornerRadius: 8), for: .highlighted)
            setBackgroundImage(UIImage.resizableImage(withColor: .base300, cornerRadius: 8), for: .disabled)
            setTitleAttributes(font: font, color: .white, for: .normal)
            setTitleAttributes(font: font, color: .white, for: .highlighted)
            setTitleAttributes(font: font, color: .white, for: .disabled)
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
        }
    }

    private func setTitleAttributes(font: UIFont, color: UIColor, for state: UIControl.State) {
        setAttributedTitle(NSAttributedString(string: title(for: state) ?? "", attributes: [
            .font: font,
            .foregroundColor: color
        ]), for: state)
    }
}
