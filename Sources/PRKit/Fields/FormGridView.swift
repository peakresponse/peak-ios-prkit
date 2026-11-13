//
//  FormGridView.swift
//  PRKit
//
//  Created by Francis Li on 11/12/26.
//

import UIKit

open class FormGridView: UIScrollView {
    open weak var contentView: UIView!
    open var arrangedSubviews: [UIView] = []
    open var contentConstraints: [NSLayoutConstraint] = []
    open var rows: [UIStackView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            contentLayoutGuide.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            contentLayoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        self.contentView = contentView
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func addArrangedSubview(_ view: UIView) {
        arrangedSubviews.append(view)
    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass {
            updateLayout()
        }
    }

    open func updateLayout() {
        for row in rows {
            row.removeFromSuperview()
        }
        rows.removeAll()
        NSLayoutConstraint.deactivate(contentConstraints)
        contentConstraints.removeAll()
        var prev: UIView?
        var row: UIStackView!
        var rowCount = 2
        for view in arrangedSubviews {
            view.removeFromSuperview()
            if traitCollection.horizontalSizeClass == .regular {
                let component = view as? FormComponent
                var span = component?.formGridSpan ?? 1
                var offset = component?.formGridOffset ?? 0
                while rowCount + span + offset > 2 {
                    while rowCount < 2 {
                        row?.addArrangedSubview(UIView())
                        if offset > 0 {
                            offset -= 1
                        }
                        rowCount += 1
                    }
                    rowCount = 0
                    row = UIStackView()
                    row.translatesAutoresizingMaskIntoConstraints = false
                    row.axis = .horizontal
                    row.distribution = .fillEqually
                    row.spacing = 16
                    contentView.addSubview(row)
                    rows.append(row)
                    contentConstraints.append(contentsOf: [
                        row.topAnchor.constraint(equalTo: prev == nil ? contentView.topAnchor : prev!.bottomAnchor, constant: 16),
                        row.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                        row.rightAnchor.constraint(equalTo: contentView.rightAnchor)
                    ])
                    prev = row
                }
                while offset > 0 {
                    row.addArrangedSubview(UIView())
                    offset -= 1
                    rowCount += 1
                }
                row?.addArrangedSubview(view)
                rowCount += span
            } else {
                contentView.addSubview(view)
                contentConstraints.append(contentsOf: [
                    view.topAnchor.constraint(equalTo: prev == nil ? contentView.topAnchor : prev!.bottomAnchor, constant: 16),
                    view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                    view.rightAnchor.constraint(equalTo: contentView.rightAnchor)
                ])
                prev = view
            }
        }
        while rowCount < 2 {
            row?.addArrangedSubview(UIView())
            rowCount += 1
        }
        if let prev {
            contentConstraints.append(contentView.bottomAnchor.constraint(equalTo: prev.bottomAnchor, constant: 16))
        }
        NSLayoutConstraint.activate(contentConstraints)
    }
}
