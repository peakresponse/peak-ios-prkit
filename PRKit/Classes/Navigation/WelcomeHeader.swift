//
//  WelcomeHeader.swift
//  PRKit
//
//  Created by Francis Li on 10/21/21.
//

import UIKit

@IBDesignable
open class WelcomeHeader: UIView {
    open weak var imageView: ImageView!
    open weak var label: UILabel!

    @IBInspectable open var labelText: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    open var imageURL: String? {
        get { return imageView.imageURL }
        set {
            imageView.imageURL = newValue
            if newValue == nil {
                imageView.image = UIImage(named: "Portrait", in: PRKitBundle.instance, compatibleWith: nil)
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
        backgroundColor = .brandPrimary300

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        let maxWidthConstraint = view.widthAnchor.constraint(equalTo: widthAnchor)
        maxWidthConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            view.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor),
            view.widthAnchor.constraint(lessThanOrEqualToConstant: 934),
            maxWidthConstraint,
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let isRegularWidth = traitCollection.horizontalSizeClass == .regular

        let imageSize: CGFloat = isRegularWidth ? 90 : 32
        let imageView = ImageView()
        imageView.round = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            view.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16)
        ])
        self.imageView = imageView
        imageURL = nil

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h4SemiBold
        label.textColor = .base800
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: isRegularWidth ? 16 : 10),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        self.label = label
    }
}
