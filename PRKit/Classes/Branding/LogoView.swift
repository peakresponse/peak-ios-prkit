//
//  LogoView.swift
//  PRKit
//
//  Created by Francis Li on 9/28/21.
//

import UIKit
import SVGKit

public enum LogoStyle: String {
    case full, square
}

public enum LogoVariant: String {
    case dark, light, white
}

@IBDesignable
open class LogoView: UIView {
    private weak var imageView: SVGKImageView!
    private var imageViewAspectConstraint: NSLayoutConstraint!

    open var style: LogoStyle = .full {
        didSet { updateLogo() }
    }
    @IBInspectable open var Style: String {
        get { return style.rawValue }
        set { style = LogoStyle(rawValue: newValue) ?? .full }
    }

    open var variant: LogoVariant = .dark {
        didSet { updateLogo() }
    }
    @IBInspectable open var Variant: String {
        get { return variant.rawValue }
        set { variant = LogoVariant(rawValue: newValue) ?? .dark }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        updateLogo()
    }

    private func commonInit() {
        backgroundColor = .clear

        let imageView = SVGKFastImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        let optionalWidthConstraint = imageView.widthAnchor.constraint(equalTo: widthAnchor)
        optionalWidthConstraint.priority = .defaultLow
        let optionalHeightConstraint = imageView.heightAnchor.constraint(equalTo: heightAnchor)
        optionalHeightConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
            optionalWidthConstraint,
            optionalHeightConstraint
        ])
        self.imageView = imageView
    }

    private func updateLogo() {
        switch style {
        case .full:
            switch variant {
            case .dark:
                imageView.image = SVGKImage(named: "logo.full.dark.svg", in: PRKitBundle.instance)
            case .light:
                imageView.image = SVGKImage(named: "logo.full.light.svg", in: PRKitBundle.instance)
            case .white:
                imageView.image = SVGKImage(named: "logo.full.white.svg", in: PRKitBundle.instance)
            }
        case .square:
            switch variant {
            case .dark:
                imageView.image = SVGKImage(named: "logo.square.dark.svg", in: PRKitBundle.instance)
            case .light:
                imageView.image = SVGKImage(named: "logo.square.light.svg", in: PRKitBundle.instance)
            case .white:
                imageView.image = nil
            }
        }
        if let image = imageView.image, image.hasSize() {
            if let imageViewAspectConstraint = imageViewAspectConstraint {
                imageViewAspectConstraint.isActive = false
            }
            imageViewAspectConstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: image.size.width / image.size.height)
            imageViewAspectConstraint.isActive = true
        }
    }
}
