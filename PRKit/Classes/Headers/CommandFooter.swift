//
//  CommandFooter.swift
//  PRKit
//
//  Created by Francis Li on 10/22/21.
//

import UIKit

open class CommandFooter: UIView {
    open var stackView = UIStackView()
    open var layoutConstraints: [NSLayoutConstraint] = []

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        super.addSubview(stackView)
        updateLayout()

        if traitCollection.horizontalSizeClass == .regular {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged),
                                                   name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }

    deinit {
        if traitCollection.horizontalSizeClass == .regular {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
    }

    open func updateLayout() {
        NSLayoutConstraint.deactivate(layoutConstraints)
        layoutConstraints.removeAll()

        layoutConstraints.append(topAnchor.constraint(equalTo: stackView.topAnchor, constant: -20))
        layoutConstraints.append(stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20))
        layoutConstraints.append(stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20))
        if traitCollection.horizontalSizeClass == .compact {
            backgroundColor = .white
            addShadow(withOffset: CGSize(width: 4, height: -4), radius: 20, color: .base800, opacity: 0.2)

            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            layoutConstraints.append(stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20))
            for view in stackView.arrangedSubviews {
                if let button = view as? Button {
                    button.size = .small
                }
            }
        } else {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
                backgroundColor = .clear
                removeShadow()
                stackView.axis = .vertical
                stackView.distribution = .fillEqually
                layoutConstraints.append(stackView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 710) / 2 - 20))
            } else {
                backgroundColor = .white
                addShadow(withOffset: CGSize(width: 4, height: -4), radius: 20, color: .base800, opacity: 0.2)
                stackView.axis = .horizontal
                stackView.distribution = .fillProportionally
                layoutConstraints.append(stackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 20))
            }
            for view in stackView.arrangedSubviews {
                if let button = view as? Button {
                    button.size = .medium
                }
            }
        }

        NSLayoutConstraint.activate(layoutConstraints)
    }

    open override func addSubview(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }

    @objc func orientationChanged() {
        updateLayout()
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateLayout()
    }
}
