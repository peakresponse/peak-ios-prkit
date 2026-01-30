//
//  GroupedTableViewSectionHeader.swift
//  Pods
//
//  Created by Francis Li on 11/5/25.
//

open class GroupedTableViewSectionHeader: UITableViewHeaderFooterView {
    open weak var titleLabel: UILabel!

    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .h4SemiBold
        titleLabel.textColor = .labelText
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            contentView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        ])
        self.titleLabel = titleLabel
    }
}
