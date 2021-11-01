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
        if var frame = titleLabel?.frame {
            frame.origin.x = CGFloat(size + (isCompact ? 6 : 9))
            titleLabel?.frame = frame
        }
    }
}

@objc public protocol CommandHeaderDelegate {
    @objc optional func commandHeaderDidPressUser(_ header: CommandHeader)
}

@IBDesignable
open class CommandHeader: UIView {
    @IBInspectable open var isUserHidden: Bool = true {
        didSet {
            userButton.isHidden = isUserHidden
        }
    }
    @IBInspectable open var isSearchHidden: Bool = true

    open weak var stackView: UIStackView!
    open weak var userButton: UIButton!
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
                userButton.setImage(UIImage(named: "Portrait", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
            }
        }
    }
    open var userLabelText: String? {
        get { return userButton.title(for: .normal) }
        set { userButton.setTitle(newValue, for: .normal) }
    }

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

        let isCompact = traitCollection.horizontalSizeClass == .compact

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 12)
        ])
        self.stackView = stackView

        let userButton = UserButton(type: .custom)
        userButton.translatesAutoresizingMaskIntoConstraints = false
        userButton.isHidden = isUserHidden
        userButton.setTitleColor(.base500, for: .normal)
        userButton.titleLabel?.font = isCompact ? .body14Bold : .h4SemiBold
        userButton.addTarget(self, action: #selector(userPressed), for: .touchUpInside)
        stackView.addArrangedSubview(userButton)
        NSLayoutConstraint.activate([
            userButton.heightAnchor.constraint(equalToConstant: isCompact ? 36 : 48)
        ])
        self.userButton = userButton
        userImageURL = nil
    }

    @objc func userPressed() {
        delegate?.commandHeaderDidPressUser?(self)
    }
}
