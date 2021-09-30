//
//  ImageView.swift
//  Triage
//
//  Created by Francis Li on 9/28/20.
//  Copyright © 2020 Francis Li. All rights reserved.
//

import UIKit

@IBDesignable
open class ImageView: UIView {
    weak var imageView: UIImageView!
    weak var activityIndicatorView: UIActivityIndicatorView!

    @IBInspectable var round: Bool = false {
        didSet { configureConstraints() }
    }

    @IBInspectable var image: UIImage? {
        get { return imageView.image }
        set { imageView.image = newValue }
    }

    var imageURL: String? {
        didSet { loadImage() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if round {
            imageView.layer.cornerRadius = imageView.frame.size.width / 2
        }
    }

    private func configureConstraints() {
        removeConstraints(constraints.filter { $0.firstItem?.isEqual(imageView) ?? false })
        if round {
            let optionalWidth = imageView.widthAnchor.constraint(equalTo: widthAnchor)
            optionalWidth.priority = .defaultLow
            let optionalHeight = imageView.heightAnchor.constraint(equalTo: heightAnchor)
            optionalHeight.priority = .defaultLow
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                imageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
                imageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
                optionalWidth,
                optionalHeight
            ])
        } else {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.leftAnchor.constraint(equalTo: leftAnchor),
                imageView.rightAnchor.constraint(equalTo: rightAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }

    private func commonInit() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        addSubview(imageView)
        self.imageView = imageView
        configureConstraints()

        let activityIndicatorView = UIActivityIndicatorView.withMediumStyle()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        self.activityIndicatorView = activityIndicatorView
    }

    private func loadImage() {
        if let imageURL = imageURL {
            activityIndicatorView.startAnimating()
            DispatchQueue.global(qos: .default).async { [weak self] in
                if let url = URL(string: imageURL),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        if self.imageURL == imageURL {
                            self.activityIndicatorView.stopAnimating()
                            self.imageView.image = image
                        }
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicatorView.stopAnimating()
                    }
                }
            }
        } else {
            imageView.image = nil
            activityIndicatorView.stopAnimating()
        }
    }
}
