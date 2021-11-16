//
//  NumberKeypad.swift
//  PRKit
//
//  Created by Francis Li on 11/16/21.
//

import UIKit

open class NumberKeypad: UIView, FormFieldInputView {
    open weak var rows: UIStackView!
    open var buttons: [Button] = []

    open var decimalButton: Button {
        get { return buttons[9] }
    }
    open var isDecimalHidden: Bool {
        get { return decimalButton.alpha == 0 }
        set { decimalButton.alpha = newValue ? 0 : 1 }
    }

    open var value: String = ""

    open weak var delegate: FormFieldInputViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .base300

        let spacing: CGFloat = 6
        let rows = UIStackView()
        rows.translatesAutoresizingMaskIntoConstraints = false
        rows.axis = .vertical
        rows.distribution = .fillEqually
        rows.spacing = spacing
        addSubview(rows)
        let rowWidth = rows.widthAnchor.constraint(equalToConstant: 690)
        rowWidth.priority = .defaultHigh
        NSLayoutConstraint.activate([
            rows.topAnchor.constraint(equalTo: topAnchor),
            rows.centerXAnchor.constraint(equalTo: centerXAnchor),
            rowWidth,
            rows.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: spacing),
            rows.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -spacing),
            safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: rows.bottomAnchor, constant: spacing)
        ])

        var row: UIStackView!
        for i in 1..<13 {
            if i % 3 == 1 {
                row = UIStackView()
                row.axis = .horizontal
                row.distribution = .fillEqually
                row.spacing = spacing
                rows.addArrangedSubview(row)
            }
            let button = Button()
            var title: String?
            if i < 10 {
                title = "\(i)"
            } else if i == 10 {
                title = "."
            } else if i == 11 {
                title = "0"
            } else if i == 12 {
                title = nil
                button.setImage(UIImage(named: "Delete40px", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
            }
            button.setTitle(title, for: .normal)
            button.size = .medium
            button.style = .secondary
            button.tag = i
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            row.addArrangedSubview(button)
            buttons.append(button)
        }
    }

    public func setValue(_ value: AnyObject?) {
        if let value = value {
            self.value = "\(value)"
            decimalButton.isEnabled = !self.value.contains(".")
        } else {
            self.value = ""
        }
    }

    @objc func buttonPressed(_ button: Button) {
        if button.tag < 10 {
            if value == "0" {
                value = ""
            }
            value = "\(value)\(button.tag)"
        } else if button.tag == 10 {
            if value == "" {
                value = "0"
            }
            value = "\(value)."
        } else if button.tag == 11 {
            if value == "0" {
                value = ""
            }
            value = "\(value)0"
        } else if button.tag == 12 {
            if value.count > 0 {
                value = String(value[value.startIndex..<value.index(before: value.endIndex)])
            }
        }
        decimalButton.isEnabled = !self.value.contains(".")
        delegate?.formFieldInputView(self, didChange: value as AnyObject)
    }
}
