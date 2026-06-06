//
//  KeyboardSourceTableViewController.swift
//  PRKit
//
//  Created by Francis Li on 6/6/26.
//

import Foundation
import UIKit

@objc protocol KeyboardSourceTableViewControllerDelegate {
    @objc optional func keyboardSourceTableViewController(_ vc: KeyboardSourceTableViewController, isSelected value: NSObject) -> Bool
    @objc optional func keyboardSourceTableViewController(_ vc: KeyboardSourceTableViewController, didSelect value: NSObject)
    @objc optional func keyboardSourceTableViewController(_ vc: KeyboardSourceTableViewController, didDeselect value: NSObject)
    @objc optional func keyboardSourceTableViewController(_ vc: KeyboardSourceTableViewController, didNavigateTo id: String)
}

class KeyboardSourceTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var stackView: UIStackView!
    var commandHeader: CommandHeader!
    var tableView: UITableView!
    var source: KeyboardSource?
    var isMultiSelect = false

    weak var delegate: KeyboardSourceTableViewControllerDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        commandHeader = CommandHeader()
        commandHeader.isHidden = true
        stackView.addArrangedSubview(commandHeader)

        tableView = TableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListItemTableViewCell.self, forCellReuseIdentifier: "item")
        tableView.register(CheckboxTableViewCell.self, forCellReuseIdentifier: "checkbox")
        stackView.addArrangedSubview(tableView)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source?.count() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let value = source?.value(at: indexPath.row), let isCategories = source?.isSectioned else { return UITableViewCell() }
        if isCategories {
            let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
            if let cell = cell as? ListItemTableViewCell {
                cell.label.text = source?.title(at: indexPath.row)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkbox", for: indexPath)
        if let cell = cell as? CheckboxTableViewCell,
           let value = source?.value(at: indexPath.row) {
            cell.checkbox.labelText = source?.title(at: indexPath.row)
            cell.checkbox.isChecked = delegate?.keyboardSourceTableViewController?(self, isSelected: value) ?? false
            cell.checkbox.isRadioButton = !isMultiSelect
            cell.checkbox.isUserInteractionEnabled = false
        }
        return cell
    }

    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        let value = source?.value(at: indexPath.row)
        if let cell = cell as? CheckboxTableViewCell, let value {
            if cell.checkbox.isChecked {
                cell.checkbox.isChecked = false
                delegate?.keyboardSourceTableViewController?(self, didDeselect: value)
            } else {
                cell.checkbox.isChecked = true
                if !isMultiSelect {
                    for otherIndexPath in tableView.indexPathsForVisibleRows ?? [] {
                        if otherIndexPath != indexPath, let otherCell = tableView.cellForRow(at: otherIndexPath) as? CheckboxTableViewCell {
                            otherCell.checkbox.isChecked = false
                        }
                    }
                }
                delegate?.keyboardSourceTableViewController?(self, didSelect: value)
            }
        } else if let cell = cell as? ListItemTableViewCell, let value = value as? String {
            delegate?.keyboardSourceTableViewController?(self, didNavigateTo: value)
        }
    }
}
