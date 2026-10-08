//
//  CommandFooter.swift
//  PRKit
//
//  Created by Francis Li on 10/22/21.
//

import UIKit

@IBDesignable
open class CommandFooter: UIView {
    open weak var bottomContentView: UIView!
    open weak var sideContentView: UIView!
    open weak var activityIndicatorView: UIActivityIndicatorView!
    open var stackView = UIStackView()
    open var layoutConstraints: [NSLayoutConstraint] = []

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
        layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)

        let bottomContentView = UIView()
        bottomContentView.translatesAutoresizingMaskIntoConstraints = false
        bottomContentView.backgroundColor = .black.withAlphaComponent(0.5)
        super.addSubview(bottomContentView)
        let bottomContentViewLeftConstraint = bottomContentView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor)
        bottomContentViewLeftConstraint.priority = .defaultHigh
        let bottomContentViewRightConstraint = bottomContentView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor)
        bottomContentViewRightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            bottomContentView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            bottomContentViewLeftConstraint,
            bottomContentViewRightConstraint,
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor)
        ])
        self.bottomContentView = bottomContentView

        let sideContentView = UIView()
        sideContentView.translatesAutoresizingMaskIntoConstraints = false
        sideContentView.backgroundColor = .blue.withAlphaComponent(0.5)
        super.addSubview(sideContentView)
        let sideContentViewWidthConstraint = sideContentView.widthAnchor.constraint(equalToConstant: 140)
        sideContentViewWidthConstraint.priority = .defaultHigh
        let sideContentViewRightConstraint = sideContentView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor)
        sideContentViewRightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            sideContentViewWidthConstraint,
            sideContentViewRightConstraint,
            sideContentView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        self.sideContentView = sideContentView

        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        super.addSubview(stackView)

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

    open func isOverlapping(_ size: CGSize? = nil) -> Bool {
        if traitCollection.horizontalSizeClass == .compact {
            return true
        }
        let size = size ?? screen.bounds.size
        return size.width < size.height
    }

    open func updateLayout() {
        NSLayoutConstraint.deactivate(layoutConstraints)
        layoutConstraints.removeAll()

        layoutConstraints.append(topAnchor.constraint(equalTo: stackView.topAnchor, constant: -20))
        layoutConstraints.append(stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20))
        layoutConstraints.append(stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20))
        if traitCollection.horizontalSizeClass == .compact {
            backgroundColor = .background
            addShadow(withOffset: CGSize(width: 4, height: -4), radius: 20, color: .dropShadow, opacity: 0.2)

            stackView.axis = .horizontal
            layoutConstraints.append(stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20))
            for view in stackView.arrangedSubviews {
                if let button = view as? Button {
                    button.isLayoutVertical = false
                    if stackView.arrangedSubviews.count > 1 {
                        button.size = .small
                    }
                }
                view.invalidateIntrinsicContentSize()
            }
        } else {
            let screen = self.screen
            if screen.bounds.size.width > screen.bounds.size.height {
                backgroundColor = .clear
                removeShadow()
                stackView.axis = .vertical
                let width = floor((max(screen.bounds.width, screen.bounds.height) - 710) / 2 - 20)
                layoutConstraints.append(stackView.widthAnchor.constraint(equalToConstant: width))
            } else {
                backgroundColor = .background
                addShadow(withOffset: CGSize(width: 4, height: -4), radius: 20, color: .dropShadow, opacity: 0.2)
                stackView.axis = .horizontal
                layoutConstraints.append(stackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 20))
            }
            for view in stackView.arrangedSubviews {
                if let button = view as? Button {
                    button.isLayoutVertical = false
                    button.size = traitCollection.userInterfaceIdiom == .phone ? .small : .medium
                }
                view.invalidateIntrinsicContentSize()
            }
        }
        NSLayoutConstraint.activate(layoutConstraints)
    }

    open override func addSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isOverlapping() {
            return super.point(inside: point, with: event)
        }
        for subview in subviews {
            let pt = subview.convert(point, from: self)
            if subview.point(inside: pt, with: event) {
                return true
            }
        }
        return false
    }
}
