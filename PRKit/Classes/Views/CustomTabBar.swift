//
//  CustomTabBar.swift
//  PRKit
//
//  Created by Francis Li on 2/1/22.
//

import UIKit

@objc public protocol CustomTabBarDelegate: AnyObject {
    func customTabBar(_ tabBar: CustomTabBar, didPress button: UIButton)
}

@IBDesignable
open class CustomTabBar: UIView {
    open weak var bottomImageView: UIImageView!
    open weak var bottomView: UIView!
    open weak var contentView: UIView!
    open weak var button: UIButton!
    open weak var buttonLabel: UILabel!
    open weak var leftStackView: UIStackView!
    open weak var rightStackView: UIStackView!

    open weak var delegate: CustomTabBarDelegate?

    @IBInspectable open var buttonTitle: String? {
        get { return buttonLabel.text }
        set { buttonLabel.text = newValue }
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
        backgroundColor = .clear
        addShadow(withOffset: CGSize(width: 0, height: -10), radius: 15, color: .base500, opacity: 0.4)

        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 105),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        self.contentView = contentView

        let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomView)
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bottomView.leftAnchor.constraint(equalTo: leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        self.bottomView = bottomView

        let bottomImageView = UIImageView()
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.image = UIImage(named: "CustomTabBarBackground", in: PRKitBundle.instance, compatibleWith: nil)
        addSubview(bottomImageView)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: bottomImageView.topAnchor),
            bottomImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomImageView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        self.bottomImageView = bottomImageView

        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary500, cornerRadius: 47), for: .normal)
        button.setBackgroundImage(UIImage.resizableImage(withColor: .brandPrimary600, cornerRadius: 47), for: .highlighted)
        button.setBackgroundImage(UIImage.resizableImage(withColor: .base300, cornerRadius: 47), for: .disabled)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 94),
            button.heightAnchor.constraint(equalToConstant: 94)
        ])
        self.button = button

        let buttonLabel = UILabel()
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.font = .h4SemiBold
        buttonLabel.textAlignment = .center
        buttonLabel.textColor = .white
        buttonLabel.isUserInteractionEnabled = false
        buttonLabel.numberOfLines = 0
        addSubview(buttonLabel)
        NSLayoutConstraint.activate([
            buttonLabel.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            buttonLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            buttonLabel.widthAnchor.constraint(lessThanOrEqualTo: button.widthAnchor),
            buttonLabel.heightAnchor.constraint(lessThanOrEqualTo: button.heightAnchor)
        ])
        self.buttonLabel = buttonLabel
    }

    @objc open func buttonPressed() {
        delegate?.customTabBar(self, didPress: button)
    }
}
