//
//  SidebarTableView.swift
//  PRKit
//
//  Created by Francis Li on 10/27/21.
//

import UIKit

open class SidebarTableViewCell: UITableViewCell {
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        backgroundColor = .background
        accessoryType = .none
        selectionStyle = .none
        textLabel?.font = .h4SemiBold
        textLabel?.textColor = .interactiveText

        let bottomBorder = UIView()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.backgroundColor = .interactiveText
        addSubview(bottomBorder)
        NSLayoutConstraint.activate([
            bottomBorder.leftAnchor.constraint(equalTo: leftAnchor),
            bottomBorder.rightAnchor.constraint(equalTo: rightAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 2)
        ])
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = highlighted ? .highlight : .background
    }
}

open class SidebarTableView: UITableView {
    open var sidebarTableViewLeftConstraint: NSLayoutConstraint?

    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        backgroundColor = .background
        separatorStyle = .none
        rowHeight = 66
        register(SidebarTableViewCell.self, forCellReuseIdentifier: "SidebarItem")
    }

    open func layoutConstraints(in view: UIView) -> [NSLayoutConstraint] {
        let sidebarTableViewLeftConstraint = leftAnchor.constraint(equalTo: view.leftAnchor, constant: -300)
        self.sidebarTableViewLeftConstraint = sidebarTableViewLeftConstraint
        return [
            sidebarTableViewLeftConstraint,
            widthAnchor.constraint(equalToConstant: 300)
        ]
    }

    open func toggle(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            guard let sidebarTableViewLeftConstraint = self?.sidebarTableViewLeftConstraint else { return }
            if sidebarTableViewLeftConstraint.constant == 0 {
                sidebarTableViewLeftConstraint.constant = -300
                self?.removeShadow()
            } else {
                sidebarTableViewLeftConstraint.constant = 0
                self?.addShadow(withOffset: CGSize(width: 6, height: 0), radius: 10, color: .dropShadow, opacity: 0.15)
            }
            (sidebarTableViewLeftConstraint.secondItem as? UIView)?.layoutIfNeeded()
        }, completion: completion)
    }
}
