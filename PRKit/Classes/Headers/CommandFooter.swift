//
//  CommandFooter.swift
//  PRKit
//
//  Created by Francis Li on 10/22/21.
//

import UIKit

@objc public protocol CommandFooterDelegate {
    @objc optional func commandFooterDidUpdateLayout(_ commandFooter: CommandFooter, isOverlapping: Bool)
}

@IBDesignable
open class CommandFooter: UIView {
    open var stackView = UIStackView()
    open var layoutConstraints: [NSLayoutConstraint] = []

    @IBOutlet open weak var delegate: CommandFooterDelegate?

    open var isOverlapping: Bool {
        return traitCollection.horizontalSizeClass == .compact ||
               UIDevice.current.orientation == .portrait ||
               UIDevice.current.orientation == .portraitUpsideDown
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
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
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
            layoutConstraints.append(stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20))
            for view in stackView.arrangedSubviews {
                if let button = view as? Button {
                    button.size = .small
                }
            }
            delegate?.commandFooterDidUpdateLayout?(self, isOverlapping: true)
        } else {
            var orientation: UIInterfaceOrientation
            if #available(iOS 13.0, *) {
                orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .unknown
            } else {
                orientation = UIApplication.shared.statusBarOrientation
            }
            if orientation == .landscapeLeft || orientation == .landscapeRight {
                backgroundColor = .clear
                removeShadow()
                stackView.axis = .vertical
                layoutConstraints.append(stackView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 710) / 2 - 20))
                delegate?.commandFooterDidUpdateLayout?(self, isOverlapping: false)
            } else {
                backgroundColor = .white
                addShadow(withOffset: CGSize(width: 4, height: -4), radius: 20, color: .base800, opacity: 0.2)
                stackView.axis = .horizontal
                layoutConstraints.append(stackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 20))
                delegate?.commandFooterDidUpdateLayout?(self, isOverlapping: true)
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

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isOverlapping {
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