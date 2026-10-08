//
//  CommandFooter.swift
//  PRKit
//
//  Created by Francis Li on 10/22/21.
//

import UIKit

@IBDesignable
open class CommandFooter: UIView {
    open weak var activityIndicatorView: UIActivityIndicatorView!
    open weak var stackView: UIStackView!

    open var isLoading: Bool {
        get { activityIndicatorView.isAnimating }
        set {
            if newValue {
                activityIndicatorView.startAnimating()
                stackView.isHidden = true
            } else {
                activityIndicatorView.stopAnimating()
                stackView.isHidden = false
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

    open func commonInit() {
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        super.addSubview(stackView)
        let stackViewLeftConstraint = stackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor)
        stackViewLeftConstraint.priority = .defaultHigh
        let stackViewRightConstraint = stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        stackViewRightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            layoutMarginsGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
            stackViewLeftConstraint,
            stackViewRightConstraint,
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -layoutMargins.bottom)
        ])
        self.stackView = stackView

        let activityIndicatorView = UIActivityIndicatorView.withLargeStyle()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        super.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor)
        ])
        self.activityIndicatorView = activityIndicatorView
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }

    open func updateLayout() {
        if traitCollection.horizontalSizeClass == .regular, let screen, screen.bounds.size.width > screen.bounds.size.height {
            backgroundColor = .clear
            stackView.axis = .vertical
            removeShadow()
        } else {
            backgroundColor = .background
            stackView.axis = .horizontal
            addShadow(withOffset: CGSize(width: 4, height: -4), radius: 20, color: .dropShadow, opacity: 0.2)
        }
        let size: ButtonSize = traitCollection.userInterfaceIdiom == .phone ? .small : .medium
        for view in stackView.arrangedSubviews {
            if let button = view as? Button {
                button.isLayoutVertical = false
                button.size = size
            }
            view.invalidateIntrinsicContentSize()
        }
    }

    open func layoutConstraints(for contentView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = []
        if traitCollection.horizontalSizeClass == .compact || view.bounds.size.width < view.bounds.size.height {
            constraints.append(stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor))
            constraints.append(stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor))
        }
        return constraints
    }

    open override func addSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
}
