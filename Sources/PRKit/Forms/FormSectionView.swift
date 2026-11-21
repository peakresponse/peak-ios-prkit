//
//  FormSectionVIew.swift
//  PRKit
//
//  Created by Francis Li on 11/13/26.
//

import UIKit

open class FormSectionView: UIStackView {
    open weak var formGridView: FormGridView!

    public override init(frame: CGRect) {
        super.init(frame: frame)

        axis = .vertical
        alignment = .fill

        let formGridView = FormGridView()
        addArrangedSubview(formGridView)
        self.formGridView = formGridView
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func addHeader(text: String, secondaryText: String? = nil) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        let header = UILabel()
        header.translatesAutoresizingMaskIntoConstraints = false
        header.font = .h4SemiBold
        header.text = text
        header.textColor = .headingText
        header.numberOfLines = 0
        view.addSubview(header)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            header.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])

        if let secondaryText = secondaryText {
            let secondaryHeader = UILabel()
            secondaryHeader.translatesAutoresizingMaskIntoConstraints = false
            secondaryHeader.font = .h4SemiBold
            secondaryHeader.text = secondaryText
            secondaryHeader.textColor = .labelText
            view.addSubview(secondaryHeader)
            NSLayoutConstraint.activate([
                secondaryHeader.firstBaselineAnchor.constraint(equalTo: header.firstBaselineAnchor),
                secondaryHeader.leftAnchor.constraint(equalTo: header.rightAnchor),
                secondaryHeader.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor)
            ])
        } else {
            header.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor).isActive = true
        }

        let rule = UIView()
        rule.translatesAutoresizingMaskIntoConstraints = false
        rule.backgroundColor = .disabledBorder
        view.addSubview(rule)
        NSLayoutConstraint.activate([
            rule.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 3),
            rule.leftAnchor.constraint(equalTo: view.leftAnchor),
            rule.rightAnchor.constraint(equalTo: view.rightAnchor),
            rule.heightAnchor.constraint(equalToConstant: 2),
            view.bottomAnchor.constraint(equalTo: rule.bottomAnchor)
        ])

        insertArrangedSubview(view, at: 0)
    }

    open func updateLayout() {
        formGridView.updateLayout()
    }
}
