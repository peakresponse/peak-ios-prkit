//
//  TablesViewController.swift
//  PRKit_Example
//
//  Created by Francis Li on 8/12/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import PRKit
import UIKit

class TablesViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.register(ListItemTableViewCell.self, forCellReuseIdentifier: "Item")
        tableView.register(GroupedTableViewSectionHeader.self, forHeaderFooterViewReuseIdentifier: "groupedSectionHeader")
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        if let cell = cell as? ListItemTableViewCell {
            cell.label.text = "Item \(indexPath.row)"
        }
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "groupedSectionHeader")
        if let header = header as? GroupedTableViewSectionHeader {
            header.titleLabel.text = "Section \(section)"
        }
        return header
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
