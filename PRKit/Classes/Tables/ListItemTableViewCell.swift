//
//  ListItemTableViewCell.swift
//  Triage
//
//  Created by Francis Li on 9/15/22.
//  Copyright © 2022 Francis Li. All rights reserved.
//

import Foundation
import UIKit

open class ListItemTableViewCell: UITableViewCell {
    open weak var label: UILabel!
    open weak var disclosureImageView: UIImageView!
    open weak var hr: UIView!

    open var isGrouped = false
    open var isFirst = false
    open var isLast = false

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        backgroundColor = .textBackground
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = backgroundColor?.colorWithBrightnessMultiplier(multiplier: 0.8)

        let disclosureImageView = UIImageView(image: UIImage(named: "ChevronRight24px", in: PRKitBundle.instance, compatibleWith: nil))
        disclosureImageView.translatesAutoresizingMaskIntoConstraints = false
        disclosureImageView.tintColor = .labelText
        disclosureImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        contentView.addSubview(disclosureImageView)
        NSLayoutConstraint.activate([
            disclosureImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -1),
            disclosureImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ])
        self.disclosureImageView = disclosureImageView

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h4SemiBold
        label.textColor = .text
        label.numberOfLines = 0
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: disclosureImageView.leftAnchor, constant: -10),
            contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 12)
        ])
        self.label = label

        let hr = UIView()
        hr.translatesAutoresizingMaskIntoConstraints = false
        hr.backgroundColor = .disabledBorder
        contentView.addSubview(hr)
        NSLayoutConstraint.activate([
            hr.heightAnchor.constraint(equalToConstant: 2),
            hr.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            hr.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            hr.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        self.hr = hr
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        if isGrouped {
            layer.cornerRadius = 8
            layer.sublayers?.filter({$0 is CAShapeLayer}).forEach({$0.removeFromSuperlayer()})
            let path = UIBezierPath()
            if isLast {
                path.move(to: CGPoint(x: 9, y: bounds.height - 1))
                path.addArc(withCenter: CGPoint(x: 9, y: bounds.height - 9), radius: 8, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
            } else {
                path.move(to: CGPoint(x: 1, y: bounds.height))
            }
            if isFirst {
                path.addLine(to: CGPoint(x: 1, y: 8))
                path.addArc(withCenter: CGPoint(x: 9, y: 9), radius: 8, startAngle: CGFloat.pi, endAngle: 3*CGFloat.pi/2, clockwise: true)
                path.addLine(to: CGPoint(x: bounds.width - 9, y: 1))
                path.addArc(withCenter: CGPoint(x: bounds.width - 9, y: 9), radius: 8, startAngle: 3*CGFloat.pi/2, endAngle: 2*CGFloat.pi, clockwise: true)
            } else {
                path.addLine(to: CGPoint(x: 1, y: 0))
                path.move(to: CGPoint(x: bounds.width - 1, y: 0))
            }
            if isLast {
                path.addLine(to: CGPoint(x: bounds.width - 1, y: bounds.height - 9))
                path.addArc(withCenter: CGPoint(x: bounds.width - 9, y: bounds.height - 9), radius: 8, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
                path.move(to: CGPoint(x: bounds.width - 9, y: bounds.height - 1))
            } else {
                path.addLine(to: CGPoint(x: bounds.width - 1, y: bounds.height))
            }
            path.close()

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.lineWidth = 2
            shapeLayer.strokeColor = UIColor.disabledBorder.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor

            layer.addSublayer(shapeLayer)
        }
    }
}
