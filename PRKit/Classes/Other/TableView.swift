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
}
