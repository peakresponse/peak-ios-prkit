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
open class CommandHeader: UIView, FormFieldDelegate {
    @IBInspectable open var isUserHidden: Bool {
        get { return _userButton?.isHidden ?? true }
        set { userButton.isHidden = newValue }
    }
    @IBInspectable open var isSearchHidden: Bool {
        get { return _searchField?.isHidden ?? true }
        set { searchField.isHidden = newValue }
    }

    open weak var stackView: UIStackView!

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
    open weak var searchFieldLeftConstraint: NSLayoutConstraint!
    open weak var searchFieldDelegate: FormFieldDelegate?

    @IBOutlet open var leftBarButtonItem: UIBarButtonItem? {
        didSet { updateLeftBarButtonItem() }
    }
    open var leftBarButtonView: UIView?
    @IBOutlet open var centerBarButtonItem: UIBarButtonItem? {
        didSet { updateCenterBarButtonItem() }
    }
    open var centerBarButtonView: UIView?
    @IBOutlet open var rightBarButtonItem: UIBarButtonItem? {
        didSet { updateRightBarButtonItem() }
    }
    open var rightBarButtonView: UIView?

    @IBOutlet open weak var delegate: CommandHeaderDelegate?

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        backgroundColor = .background

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12)
        ])
        self.stackView = stackView
    }

    open func initUserButton() {
        guard _userButton == nil else { return }

        let isCompact = traitCollection.horizontalSizeClass == .compact

        let userButton = UserButton(type: .custom)
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.setTitleColor(.labelText, for: .normal)
        userButton.titleLabel?.font = isCompact ? .body14Bold : .h4SemiBold
        userButton.titleLabel?.lineBreakMode = .byTruncatingTail
        userButton.addTarget(self, action: #selector(userPressed), for: .touchUpInside)

        let view = UIView()
        view.addSubview(userButton)
        NSLayoutConstraint.activate([
            userButton.topAnchor.constraint(equalTo: view.topAnchor),
            userButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            userButton.rightAnchor.constraint(equalTo: view.rightAnchor),
            userButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            userButton.heightAnchor.constraint(equalToConstant: isCompact ? 36 : 48)
        ])
        stackView.insertArrangedSubview(view, at: 0)

        _userButton = userButton
        userImageURL = nil
    }

    open func initSearchField() {
        guard _searchField == nil else { return }

        let searchField = TextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.isLabelHidden = true
        searchField.isSearchIconHidden = false
        searchField.delegate = self

        let view = UIView()
        view.addSubview(searchField)
        let searchFieldLeftConstraint = searchField.leftAnchor.constraint(equalTo: view.leftAnchor)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.topAnchor),
            searchFieldLeftConstraint,
            searchField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            searchField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.searchFieldLeftConstraint = searchFieldLeftConstraint

        stackView.addArrangedSubview(view)

        _searchField = searchField
    }

    @objc func userPressed() {
        delegate?.commandHeaderDidPressUser?(self)
    }

    func createView(from barButtonItem: UIBarButtonItem) -> UIView {
        if let customView = barButtonItem.customView {
            customView.translatesAutoresizingMaskIntoConstraints = false
            return customView
        }
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(barButtonItem.title, for: .normal)
        button.setImage(barButtonItem.image, for: .normal)
        if let action = barButtonItem.action {
            button.addTarget(barButtonItem.target, action: action, for: .touchUpInside)
        }
        let color = barButtonItem.tintColor ?? (barButtonItem.style == .done ? .interactiveText : .labelText)
        button.tintColor = color
        button.titleLabel?.font = .h3SemiBold
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(color.colorWithBrightnessMultiplier(multiplier: 0.8), for: .highlighted)
        return button
    }

    func updateLeftBarButtonItem() {
        leftBarButtonView?.removeFromSuperview()
        if let leftBarButtonItem = leftBarButtonItem {
            let subview = createView(from: leftBarButtonItem)
            let view = UIView()
            view.addSubview(subview)
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: view.topAnchor),
                subview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftBarButtonItem.image != nil ? 0 : 20),
                subview.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor),
                view.bottomAnchor.constraint(equalTo: subview.bottomAnchor)
            ])
            stackView.insertArrangedSubview(view, at: 0)
            leftBarButtonView = view
        }
    }

    func updateCenterBarButtonItem() {
        centerBarButtonView?.removeFromSuperview()
        if let centerBarButtonItem = centerBarButtonItem {
            let subview = createView(from: centerBarButtonItem)
            let view = UIView()
            view.addSubview(subview)
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: view.topAnchor),
                subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                subview.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor),
                subview.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor),
                view.bottomAnchor.constraint(equalTo: subview.bottomAnchor)
            ])
            stackView.insertArrangedSubview(view, at: 1)
            centerBarButtonView = view
        }
    }

    func updateRightBarButtonItem() {
        rightBarButtonView?.removeFromSuperview()
        if let rightBarButtonItem = rightBarButtonItem {
            let view = UIView()
            let subview = createView(from: rightBarButtonItem)
            view.addSubview(subview)
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: view.topAnchor),
                subview.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor),
                subview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                view.bottomAnchor.constraint(equalTo: subview.bottomAnchor)
            ])
            stackView.addArrangedSubview(view)
            self.rightBarButtonView = view
        }
    }

    // MARK: - FormFieldDelegate

    public func formComponentDidChange(_ component: FormComponent) {
        searchFieldDelegate?.formComponentDidChange?(component)
    }

    public func formFieldDidBeginEditing(_ field: FormField) {
        searchFieldDelegate?.formFieldDidBeginEditing?(field)
    }

    public func formFieldShouldEndEditing(_ field: FormField) -> Bool {
        return searchFieldDelegate?.formFieldShouldEndEditing?(field) ?? true
    }

    public func formFieldDidEndEditing(_ field: FormField) {
        searchFieldDelegate?.formFieldDidEndEditing?(field)
    }

    public func formFieldDidPress(_ field: FormField) {
        searchFieldDelegate?.formFieldDidPress?(field)
    }

    public func formFieldDidPressOther(_ field: FormField) {
        searchFieldDelegate?.formFieldDidPressOther?(field)
    }

    public func formFieldDidPressStatus(_ field: FormField) {
        searchFieldDelegate?.formFieldDidPressStatus?(field)
    }

    public func formField(_ field: FormField, wantsToPresent vc: UIViewController) {
        searchFieldDelegate?.formField?(field, wantsToPresent: vc)
    }

    public func formFieldShouldBeginEditing(_ field: FormField) -> Bool {
        if let formFieldShouldBeginEditing = searchFieldDelegate?.formFieldShouldBeginEditing {
            return formFieldShouldBeginEditing(field)
        } else {
            searchFieldLeftConstraint.constant = 20
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                for subview in stackView.arrangedSubviews {
                    if subview != field.superview {
                        subview.isHidden = true
                    }
                }
            }
            return true
        }
    }

    public func formFieldShouldReturn(_ field: FormField) -> Bool {
        if let formFieldShouldReturn = searchFieldDelegate?.formFieldShouldReturn {
            return formFieldShouldReturn(field)
        } else {
            field.resignFirstResponder()
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let self = self else { return }
                for subview in stackView.arrangedSubviews {
                    subview.isHidden = false
                }
            }) { [weak self] _ in
                guard let self = self else { return }
                self.searchFieldLeftConstraint.constant = 0
            }
            return false
        }
    }
}
