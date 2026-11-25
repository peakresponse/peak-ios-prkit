//
//  FormGridView.swift
//  PRKit
//
//  Created by Francis Li on 11/12/26.
//

import ObjectiveC
import UIKit

public extension UIView {
    private static var formGridSpanKey: UInt8 = 0
    private static var formGridOffsetKey: UInt8 = 0

    var formGridSpan: Int {
        get {
            return (objc_getAssociatedObject(self, &Self.formGridSpanKey) as? Int) ?? 1
        }
        set {
            objc_setAssociatedObject(
                self,
                &Self.formGridSpanKey,
                newValue,
                .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
        }
    }

    var formGridOffset: Int {
        get {
            return (objc_getAssociatedObject(self, &Self.formGridOffsetKey) as? Int) ?? 0
        }
        set {
            objc_setAssociatedObject(
                self,
                &Self.formGridOffsetKey,
                newValue,
                .OBJC_ASSOCIATION_COPY_NONATOMIC
            )
        }
    }
}

open class FormGridView: UIView {
    open var arrangedSubviews: [UIView] = []
    open var gridConstraints: [NSLayoutConstraint] = []
    open var rows: [UIStackView] = []

    open func addArrangedSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
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
            if view.isHidden {
                continue
            }
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
                    row.alignment = .top
                    row.distribution = .fillEqually
                    row.spacing = 16
                    addSubview(row)
                    rows.append(row)
                    gridConstraints.append(contentsOf: [
                        row.topAnchor.constraint(equalTo: prev == nil ? topAnchor : prev!.bottomAnchor, constant: prev == nil ? 0 : 16),
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
                    view.topAnchor.constraint(equalTo: prev == nil ? topAnchor : prev!.bottomAnchor, constant: prev == nil ? 0 : 16),
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
            gridConstraints.append(bottomAnchor.constraint(equalTo: prev.bottomAnchor))
        }
        NSLayoutConstraint.activate(gridConstraints)
    }
}
