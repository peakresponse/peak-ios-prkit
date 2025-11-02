//
//  TableView.swift
//  PRKit
//
//  Created by Francis Li on 8/12/24.
//

import Foundation

open class TableView: UITableView {
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    open func commonInit() {
        backgroundColor = .background
        separatorStyle = .none
    }

    open override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        let cell = super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        if style == .insetGrouped, let cell = cell as? ListItemTableViewCell {
            cell.isGrouped = true
            cell.isFirst = indexPath.row == 0
            cell.isLast = indexPath.row == numberOfRows(inSection: indexPath.section) - 1
            print("isGrouped")
        }
        return cell
    }
}
