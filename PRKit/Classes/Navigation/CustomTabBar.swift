//
//  CustomTabBar.swift
//  PRKit
//
//  Created by Francis Li on 2/1/22.
//

import UIKit

@objc public protocol CustomTabBarDelegate: AnyObject {
    func customTabBar(_ tabBar: CustomTabBar, didPress button: UIButton)
    func customTabBar(_ tabBar: CustomTabBar, didSelect index: Int)
}

open class CustomTabBarButton: UIButton {
    open weak var item: UITabBarItem? {
        didSet {
            setImage(item?.image, for: .normal)
            setImage(item?.selectedImage, for: .highlighted)
            setImage(item?.selectedImage, for: .selected)
            setImage(item?.selectedImage, for: [.highlighted, .selected])
            setTitle("\(item?.title ?? "")\n", for: .normal)
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public convenience init() {
        self.init(type: .custom)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        tintColor = .base500
        titleLabel?.font = .body14Bold
        titleLabel?.numberOfLines = 2
        titleLabel?.textAlignment = .center
        titleLabel?.lineBreakMode = .byClipping
        setTitleColor(.base500, for: .normal)
        setTitleColor(.base800, for: .highlighted)
        setTitleColor(.base800, for: .selected)
        setTitleColor(.base800, for: [.highlighted, .selected])
    }

    open override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageRect = super.imageRect(forContentRect: contentRect)
        return CGRect(x: floor((contentRect.width - imageRect.width) / 2), y: 10, width: imageRect.width, height: imageRect.height)
    }

    open override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageRect = self.imageRect(forContentRect: contentRect)
        return CGRect(x: 0, y: imageRect.maxY + 8, width: contentRect.width, height: titleRect.height)
    }
}

@IBDesignable
open class CustomTabBar: UIView {
    open weak var bottomImageView: UIImageView!
    open weak var bottomView: UIView!
    open weak var contentView: UIView!
    open weak var button: UIButton!
    open weak var buttonLabel: UILabel!
    open weak var leftStackView: UIStackView!
    open var leftStackViewRightButtonConstraint: NSLayoutConstraint!
    open var leftStackViewRightContentConstraint: NSLayoutConstraint!
    open weak var rightStackView: UIStackView!
    open var isActionButtonEnabled = true

    open var items: [UITabBarItem]? {
        didSet {
            updateItems()
        }
    }
    open var selectedItem: UITabBarItem? {
        didSet {
            selectItem()
        }
    }

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
        insertSubview(bottomView, belowSubview: contentView)
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
        insertSubview(bottomImageView, belowSubview: contentView)
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

        let leftStackView = UIStackView()
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        leftStackView.distribution = .fillEqually
        contentView.addSubview(leftStackView)
        leftStackViewRightButtonConstraint = leftStackView.rightAnchor.constraint(equalTo: button.leftAnchor)
        leftStackViewRightContentConstraint = leftStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        NSLayoutConstraint.activate([
            leftStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            leftStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftStackViewRightButtonConstraint,
            leftStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        self.leftStackView = leftStackView

        let rightStackView = UIStackView()
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.distribution = .fillEqually
        contentView.addSubview(rightStackView)
        NSLayoutConstraint.activate([
            rightStackView.leftAnchor.constraint(equalTo: button.rightAnchor),
            rightStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            rightStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        self.rightStackView = rightStackView
    }

    open func updateItems() {
        guard let items = items else { return }
        if isActionButtonEnabled {
            button.isHidden = false
            bottomImageView.alpha = 1
            leftStackViewRightButtonConstraint.isActive = true
            leftStackViewRightContentConstraint.isActive = false
            rightStackView.isHidden = false
        } else {
            button.isHidden = true
            bottomImageView.alpha = 0
            leftStackViewRightButtonConstraint.isActive = false
            leftStackViewRightContentConstraint.isActive = true
            rightStackView.isHidden = true
        }
        for (i, item) in items.enumerated() {
            let stackView = isActionButtonEnabled ? (i < 2 ? leftStackView : rightStackView) : leftStackView
            let button = CustomTabBarButton()
            button.tag = i
            button.item = item
            button.addTarget(self, action: #selector(itemPressed(_:)), for: .touchUpInside)
            stackView?.addArrangedSubview(button)
        }
    }

    open func selectItem() {
        guard let items = items else { return }
        var index = -1
        if let selectedItem = selectedItem {
            index = items.firstIndex(of: selectedItem) ?? -1
        }
        for stackView in [leftStackView, rightStackView] {
            if let stackView = stackView {
                for view in stackView.arrangedSubviews {
                    if let view = view as? UIButton {
                        view.isSelected = view.tag == index
                        view.tintColor = view.isSelected ? .base800 : .base500
                    }
                }
            }
        }
    }

    @objc open func itemPressed(_ sender: UIButton) {
        guard let items = items else { return }
        selectedItem = items[sender.tag]
        delegate?.customTabBar(self, didSelect: sender.tag)
    }

    @objc open func buttonPressed() {
        delegate?.customTabBar(self, didPress: button)
    }
}
