//
//  FormScrollView.swift
//  PRKit
//
//  Created by Francis Li on 11/13/26.
//

import UIKit

open class FormScrollView: UIScrollView {
    open weak var contentStackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 16
        addSubview(contentStackView)
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            contentLayoutGuide.rightAnchor.constraint(equalTo: contentStackView.rightAnchor),
            contentLayoutGuide.bottomAnchor.constraint(equalTo: contentStackView.bottomAnchor)
        ])
        self.contentStackView = contentStackView
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func addSection() -> FormSectionView {
        let formSectionView = FormSectionView()
        contentStackView.addArrangedSubview(formSectionView)
        return formSectionView
    }

    open func updateLayout() {
        for view in contentStackView.arrangedSubviews {
            if let view = view as? FormSectionView {
                view.updateLayout()
            }
        }
    }
}
