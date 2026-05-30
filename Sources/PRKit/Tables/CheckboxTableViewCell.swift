//
//  CheckboxTableViewCell.swift
//  PRKit
//
//  Created by Francis Li on 5/30/26.
//

import UIKit

open class CheckboxTableViewCell: UITableViewCell {
    open weak var checkbox: Checkbox!
    open weak var hr: UIView!
    open var calculatedSize: CGSize?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        let checkbox = Checkbox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkbox)
        NSLayoutConstraint.activate([
            checkbox.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            checkbox.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            checkbox.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: checkbox.bottomAnchor, constant: 12)
        ])
        self.checkbox = checkbox

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
}
