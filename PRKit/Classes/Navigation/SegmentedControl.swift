//
//  SegmentedControl.swift
//  PRKit
//
//  Created by Francis Li on 11/1/21.
//

import UIKit

@IBDesignable
open class SegmentedControl: UIControl {
    open weak var stackView: UIStackView!

    open var selectedIndex: Int {
        stackView.arrangedSubviews.firstIndex(where: { ($0 as? UIButton)?.isSelected ?? false }) ?? -1
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
        backgroundColor = .brandPrimary500
        layer.cornerRadius = 8
        layer.masksToBounds = true
        heightAnchor.constraint(equalToConstant: 56).isActive = true

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -2),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 2)
        ])
        self.stackView = stackView
    }

    open func addSegment(title: String) {
        var corners: UIRectCorner = .allCorners
        if stackView.arrangedSubviews.count > 0 {
            corners = [.topLeft, .bottomLeft]
            if let button = stackView.arrangedSubviews[0] as? UIButton {
                setBackgroundImages(for: button, corners: corners)
            }
            corners = []
            for button in stackView.arrangedSubviews[1..<stackView.arrangedSubviews.count] {
                if let button = button as? UIButton {
                    setBackgroundImages(for: button, corners: corners)
                }
            }
            corners = [.topRight, .bottomRight]
        }
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .h4SemiBold
        button.setTitle(title, for: .normal)
        button.setTitleColor(.brandPrimary500, for: .normal)
        button.setTitleColor(.brandPrimary600, for: .highlighted)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.base100, for: [.selected, .highlighted])
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.tag = stackView.arrangedSubviews.count
        setBackgroundImages(for: button, corners: corners)
        stackView.addArrangedSubview(button)
        if stackView.arrangedSubviews.count == 1 {
            button.isSelected = true
        }
    }

    open func setBackgroundImages(for button: UIButton, corners: UIRectCorner) {
        button.setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary100, cornerRadius: 6, corners: corners),
                                  for: .normal)
        button.setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary200, cornerRadius: 6, corners: corners),
                                  for: .highlighted)
        button.setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary500, cornerRadius: 6, corners: corners),
                                  for: .selected)
        button.setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary600, cornerRadius: 6, corners: corners),
                                  for: [.selected, .highlighted])
    }

    @objc func buttonPressed(_ sender: UIButton) {
        guard !sender.isSelected else { return }
        sender.isSelected = true
        for button in stackView.arrangedSubviews {
            if let button = button as? UIButton, button != sender {
                button.isSelected = false
            }
        }
        sendActions(for: .valueChanged)
    }
}
