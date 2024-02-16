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
        backgroundColor = .base100
        accessoryType = .none
        selectionStyle = .none
        textLabel?.font = .h4SemiBold
        textLabel?.textColor = .brandPrimary500

        let bottomBorder = UIView()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.backgroundColor = .brandPrimary500
        addSubview(bottomBorder)
        NSLayoutConstraint.activate([
            bottomBorder.leftAnchor.constraint(equalTo: leftAnchor),
            bottomBorder.rightAnchor.constraint(equalTo: rightAnchor),
            bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 2)
        ])
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        backgroundColor = highlighted ? .brandPrimary200 : .base100
    }
}

open class SidebarTableView: UITableView {
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        backgroundColor = .base100
        separatorStyle = .none
        rowHeight = 66
        register(SidebarTableViewCell.self, forCellReuseIdentifier: "SidebarItem")
    }
}
