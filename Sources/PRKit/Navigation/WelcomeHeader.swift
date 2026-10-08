//
//  WelcomeHeader.swift
//  PRKit
//
//  Created by Francis Li on 10/21/21.
//

import UIKit

@IBDesignable
open class WelcomeHeader: UIView {
    open weak var contentView: UIView!
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
        backgroundColor = .header
        layoutMargins = UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        let contentViewLeftConstraint = contentView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor)
        contentViewLeftConstraint.priority = .defaultHigh
        let contentViewRightConstraint = contentView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor)
        contentViewRightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            contentViewLeftConstraint,
            contentViewRightConstraint,
            layoutMarginsGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        self.contentView = contentView

        let isRegularWidth = traitCollection.userInterfaceIdiom == .pad

        let imageSize: CGFloat = isRegularWidth ? 90 : 32

        let imageView = ImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.round = true
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        self.imageView = imageView
        imageURL = nil

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h4SemiBold
        label.textColor = .text
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: isRegularWidth ? 16 : 10),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        self.label = label
    }
}
