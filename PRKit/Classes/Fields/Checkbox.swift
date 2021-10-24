//
//  Checkbox.swift
//  PRKit
//
//  Created by Francis Li on 10/21/21.
//

import UIKit

@objc public protocol CheckboxDelegate {
    @objc optional func checkbox(_ checkbox: Checkbox, didChange isChecked: Bool)
}

@IBDesignable
open class Checkbox: UIView {
    open weak var button: UIButton!
    open weak var label: UILabel!

    open weak var delegate: CheckboxDelegate?

    @IBInspectable open var isChecked: Bool {
        get { return button.isSelected }
        set { button.isSelected = newValue }
    }

    @IBInspectable open var labelText: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override open var isUserInteractionEnabled: Bool {
        get { return super.isUserInteractionEnabled }
        set {
            super.isUserInteractionEnabled = newValue
            updateUserInteractionState()
        }
    }

    open func commonInit() {
        backgroundColor = .clear

        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage.resizableImage(withColor: .white, cornerRadius: 8, borderColor: .base500, borderWidth: 2), for: .normal)
        let disabledBg = UIImage.resizableImage(withColor: .white, cornerRadius: 8, borderColor: .base300, borderWidth: 2)
        button.setBackgroundImage(disabledBg, for: .disabled)
        button.setBackgroundImage(disabledBg, for: [.disabled, .selected])
        let activeBg = UIImage.resizableImage(withColor: .white, cornerRadius: 8, borderColor: .brandPrimary500, borderWidth: 2)
        button.setBackgroundImage(activeBg, for: .focused)
        button.setBackgroundImage(activeBg, for: .highlighted)
        button.setBackgroundImage(activeBg, for: [.highlighted, .selected])
        button.setBackgroundImage(UIImage.resizableImage(withColor: .white, cornerRadius: 8, borderColor: .brandPrimary300, borderWidth: 2), for: [.normal, .selected])
        let selected = UIImage.resizableImage(withColor: .brandPrimary500, cornerRadius: 4).resizedTo(CGSize(width: 26, height: 26))
        button.setImage(selected, for: .selected)
        button.setImage(selected, for: [.highlighted, .selected])
        button.setImage(UIImage.resizableImage(withColor: .base500, cornerRadius: 4).resizedTo(CGSize(width: 26, height: 26)), for: [.disabled, .selected])
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leftAnchor.constraint(equalTo: leftAnchor),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.heightAnchor.constraint(equalToConstant: 40),
            bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
        self.button = button

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h4SemiBold
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: button.rightAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        self.label = label

        updateUserInteractionState()
    }

    func updateUserInteractionState() {
        button.isEnabled = isUserInteractionEnabled
        label.textColor = isUserInteractionEnabled ? .base800 : .base300
    }

    @objc func buttonPressed() {
        button.isSelected = !button.isSelected
        delegate?.checkbox?(self, didChange: button.isSelected)
    }
}
