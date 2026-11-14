//
//  FormGridView.swift
//  PRKit
//
//  Created by Francis Li on 11/12/26.
//

import UIKit

open class FormGridView: UIView {
    open var arrangedSubviews: [UIView] = []
    open var gridConstraints: [NSLayoutConstraint] = []
    open var rows: [UIStackView] = []

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
        NSLayoutConstraint.deactivate(gridConstraints)
        gridConstraints.removeAll()
        var prev: UIView?
        var row: UIStackView!
        var rowCount = 2
        for view in arrangedSubviews {
            view.removeFromSuperview()
            if traitCollection.horizontalSizeClass == .regular {
                let component = view as? FormComponent
                let span = component?.formGridSpan ?? 1
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
                    addSubview(row)
                    rows.append(row)
                    gridConstraints.append(contentsOf: [
                        row.topAnchor.constraint(equalTo: prev == nil ? topAnchor : prev!.bottomAnchor, constant: 16),
                        row.leftAnchor.constraint(equalTo: leftAnchor),
                        row.rightAnchor.constraint(equalTo: rightAnchor)
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
                addSubview(view)
                gridConstraints.append(contentsOf: [
                    view.topAnchor.constraint(equalTo: prev == nil ? topAnchor : prev!.bottomAnchor, constant: 16),
                    view.leftAnchor.constraint(equalTo: leftAnchor),
                    view.rightAnchor.constraint(equalTo: rightAnchor)
                ])
                prev = view
            }
        }
        while rowCount < 2 {
            row?.addArrangedSubview(UIView())
            rowCount += 1
        }
        if let prev {
            gridConstraints.append(bottomAnchor.constraint(equalTo: prev.bottomAnchor, constant: 16))
        }
        NSLayoutConstraint.activate(gridConstraints)
    }
}
