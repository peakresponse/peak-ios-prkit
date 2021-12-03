//
//  SearchViewController.swift
//  PRKit
//
//  Created by Francis Li on 12/1/21.
//

import UIKit

public protocol SearchViewControllerDelegate: AnyObject {
    func searchViewController(_ vc: SearchViewController, didSelect values: [String]?)
}

open class SearchViewController: UIViewController, CheckboxDelegate, FormFieldDelegate,
                                 UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    open weak var commandHeader: CommandHeader!
    open weak var searchField: TextField!
    open weak var collectionView: UICollectionView!
    open var source: KeyboardSource?
    open var values: [String]?
    open var isMultiSelect: Bool = false
    open weak var delegate: SearchViewControllerDelegate?

    open override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .base100

        let commandHeader = CommandHeader()
        commandHeader.translatesAutoresizingMaskIntoConstraints = false
        commandHeader.leftBarButtonItem = UIBarButtonItem(title: "Button.cancel".localized, style: .plain,
                                                          target: self, action: #selector(cancelPressed))
        commandHeader.rightBarButtonItem = UIBarButtonItem(title: "Button.done".localized, style: .done,
                                                           target: self, action: #selector(donePressed))
        view.addSubview(commandHeader)
        NSLayoutConstraint.activate([
            commandHeader.topAnchor.constraint(equalTo: view.topAnchor),
            commandHeader.leftAnchor.constraint(equalTo: view.leftAnchor),
            commandHeader.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        self.commandHeader = commandHeader

        let searchField = TextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.placeholderText = "SearchBar.placeholder".localized
        searchField.isDebounced = true
        searchField.isLabelHidden = true
        searchField.isSearchIconHidden = false
        searchField.delegate = self
        view.addSubview(searchField)
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: commandHeader.bottomAnchor, constant: 10),
            searchField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            searchField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
        self.searchField = searchField

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SelectCheckboxCell.self, forCellWithReuseIdentifier: "Checkbox")
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
        self.collectionView = collectionView
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = searchField.becomeFirstResponder()
    }

    @objc func cancelPressed() {
        source?.search(nil)
        dismiss(animated: true, completion: nil)
    }

    @objc func donePressed() {
        delegate?.searchViewController(self, didSelect: values)
        cancelPressed()
    }

    // MARK: - CheckboxDelegate

    public func checkbox(_ checkbox: Checkbox, didChange isChecked: Bool) {
        guard let value = checkbox.value as? String else { return }
        if isMultiSelect {
            if isChecked {
                if !(values?.contains(value) ?? false) {
                    if values == nil {
                        values = []
                    }
                    values?.append(value)
                }
            } else {
                if let index = values?.firstIndex(of: value) {
                    values?.remove(at: index)
                }
            }
        } else {
            if isChecked {
                values = [value]
            } else {
                values = nil
            }
        }
        collectionView.reloadData()
    }

    // MARK: - FormFieldDelegate

    public func formFieldDidChange(_ field: FormField) {
        source?.search(field.text)
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source?.count() ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Checkbox", for: indexPath)
        if let cell = cell as? SelectCheckboxCell {
            cell.checkbox.value = source?.value(at: indexPath.row)
            cell.checkbox.labelText = source?.title(at: indexPath.row)
            cell.checkbox.delegate = self
            cell.checkbox.isRadioButton = !isMultiSelect
            if let value = cell.checkbox.value as? String, values?.contains(value) ?? false {
                cell.checkbox.isChecked = true
            } else {
                cell.checkbox.isChecked = false
            }
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = source?.title(at: indexPath.row) ?? ""
        if collectionView.traitCollection.horizontalSizeClass == .regular {
            return SelectCheckboxCell.sizeThatFits(min(335, floor(collectionView.frame.width - 60) / 2), with: title)
        } else {
            return SelectCheckboxCell.sizeThatFits(collectionView.frame.width - 40, with: title)
        }
    }
}
