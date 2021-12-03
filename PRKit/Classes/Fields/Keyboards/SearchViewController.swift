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

open class SearchViewController: UIViewController, CheckboxDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    open weak var commandHeader: CommandHeader!
    open weak var collectionView: UICollectionView!
    open var source: KeyboardSource?
    open var values: [String]?
    open var isMultiSelect: Bool = false
    open weak var delegate: SearchViewControllerDelegate?

    open override func viewDidLoad() {
        super.viewDidLoad()

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

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SelectCheckboxCell.self, forCellWithReuseIdentifier: "Checkbox")
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: commandHeader.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
        self.collectionView = collectionView
    }

    @objc func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }

    @objc func donePressed() {
        delegate?.searchViewController(self, didSelect: values)
        dismiss(animated: true, completion: nil)
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
