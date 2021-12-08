//
//  CommandHeader.swift
//  PRKit
//
//  Created by Francis Li on 10/27/21.
//

import UIKit

class UserButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let isCompact = traitCollection.horizontalSizeClass == .compact
        let size = isCompact ? 36 : 48
        imageView?.frame = CGRect(x: 0, y: 0, width: size, height: size)
        titleLabel?.sizeToFit()
        if var frame = titleLabel?.frame {
            frame.origin.x = CGFloat(size + (isCompact ? 6 : 9))
            frame.size.width = max(0, min(frame.size.width, self.frame.size.width - frame.origin.x))
            titleLabel?.frame = frame
        }
    }
}

@objc public protocol CommandHeaderDelegate {
    @objc optional func commandHeaderDidPressUser(_ header: CommandHeader)
}

@IBDesignable
open class CommandHeader: UIView {
    @IBInspectable open var isUserHidden: Bool {
        get { return _userButton?.isHidden ?? true }
        set { userButton.isHidden = newValue }
    }
    @IBInspectable open var isSearchHidden: Bool {
        get { return _searchField?.isHidden ?? true }
        set { searchField.isHidden = newValue }
    }

    open weak var stackView: UIStackView!
    open weak var stackViewLeftConstraint: NSLayoutConstraint!

    open weak var _userButton: UIButton!
    open var userButton: UIButton {
        if _userButton == nil {
            initUserButton()
        }
        return _userButton
    }
    open var userImage: UIImage? {
        get { return userButton.image(for: .normal) }
        set { userButton.setImage(newValue, for: .normal) }
    }
    open var userImageURL: String? {
        didSet {
            if let userImageURL = userImageURL {
                DispatchQueue.global(qos: .default).async { [weak self] in
                    if let url = URL(string: userImageURL),
                       let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data) {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.userButton.setImage(image, for: .normal)
                        }
                    }
                }
            } else {
                userButton.setImage(UIImage(named: "Portrait", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
            }
        }
    }
    open var userLabelText: String? {
        get { return userButton.title(for: .normal) }
        set { userButton.setTitle(newValue, for: .normal) }
    }

    open weak var _searchField: TextField!
    open var searchField: TextField {
        if _searchField == nil {
            initSearchField()
        }
        return _searchField
    }

    open var leftBarButtonItem: UIBarButtonItem? {
        didSet { updateLeftBarButtonItem() }
    }
    var leftBarButtonView: UIView?
    open var rightBarButtonItem: UIBarButtonItem? {
        didSet { updateRightBarButtonItem() }
    }
    var rightBarButtonView: UIView?

    @IBOutlet weak var delegate: CommandHeaderDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        backgroundColor = .white

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        addSubview(stackView)
        let stackViewLeftConstraint = stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            stackViewLeftConstraint,
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12)
        ])
        self.stackView = stackView
        self.stackViewLeftConstraint = stackViewLeftConstraint
    }

    open func initUserButton() {
        guard _userButton == nil else { return }

        let isCompact = traitCollection.horizontalSizeClass == .compact

        let userButton = UserButton(type: .custom)
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.setTitleColor(.base500, for: .normal)
        userButton.titleLabel?.font = isCompact ? .body14Bold : .h4SemiBold
        userButton.titleLabel?.lineBreakMode = .byTruncatingTail
        userButton.addTarget(self, action: #selector(userPressed), for: .touchUpInside)
        stackView.insertArrangedSubview(userButton, at: 0)
        NSLayoutConstraint.activate([
            userButton.heightAnchor.constraint(equalToConstant: isCompact ? 36 : 48)
        ])
        _userButton = userButton
        userImageURL = nil
    }

    open func initSearchField() {
        guard _searchField == nil else { return }

        let searchField = TextField()
        searchField.isLabelHidden = true
        searchField.isSearchIconHidden = false
        stackView.addArrangedSubview(searchField)
        _searchField = searchField
    }

    @objc func userPressed() {
        delegate?.commandHeaderDidPressUser?(self)
    }

    func createButton(from barButtonItem: UIBarButtonItem) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(barButtonItem.title, for: .normal)
        button.setImage(barButtonItem.image, for: .normal)
        if let action = barButtonItem.action {
            button.addTarget(barButtonItem.target, action: action, for: .touchUpInside)
        }
        button.tintColor = barButtonItem.style == .done ? .brandPrimary500 : .base500
        button.titleLabel?.font = .h3SemiBold
        button.setTitleColor(barButtonItem.style == .done ? .brandPrimary500 : .base500, for: .normal)
        return button
    }

    func updateLeftBarButtonItem() {
        leftBarButtonView?.removeFromSuperview()
        if let leftBarButtonItem = leftBarButtonItem {
            let button = createButton(from: leftBarButtonItem)
            let view = UIView()
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.topAnchor),
                button.leftAnchor.constraint(equalTo: view.leftAnchor),
                button.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor),
                view.bottomAnchor.constraint(equalTo: button.bottomAnchor)
            ])
            stackView.insertArrangedSubview(view, at: 0)
            leftBarButtonView = view
            if leftBarButtonItem.image != nil {
                stackViewLeftConstraint.constant = 0
            }
        }
    }

    func updateRightBarButtonItem() {
        rightBarButtonView?.removeFromSuperview()
        if let rightBarButtonItem = rightBarButtonItem {
            let button = createButton(from: rightBarButtonItem)
            let view = UIView()
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.topAnchor),
                button.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor),
                button.rightAnchor.constraint(equalTo: view.rightAnchor),
                view.bottomAnchor.constraint(equalTo: button.bottomAnchor)
            ])
            stackView.addArrangedSubview(view)
            self.rightBarButtonView = view
        }
    }
}
