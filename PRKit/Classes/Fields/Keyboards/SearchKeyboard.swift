//
//  SearchKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 12/1/21.
//

import UIKit

open class SearchKeyboardFooterView: UICollectionReusableView {
    open weak var searchKeyboard: SearchKeyboard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Button.search".localized, for: .normal)
        button.style = .primary
        button.size = .medium
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        addSubview(button)
        NSLayoutConstraint.activate([
            button.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor),
            button.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc func buttonPressed() {
        searchKeyboard?.searchPressed()
    }
}

open class SearchKeyboard: SelectKeyboard, SearchViewControllerDelegate {
    open override func commonInit() {
        super.commonInit()

        collectionView.register(SearchKeyboardFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "Footer")
    }

    open func searchPressed() {
        let vc = SearchViewController()
        vc.source = source
        vc.values = values
        vc.isMultiSelect = isMultiSelect
        vc.delegate = self
        delegate?.formInputView(self, wantsToPresent: vc)
    }

    public func searchViewController(_ vc: SearchViewController, didSelect values: [String]?) {
        self.values = values
        collectionView.reloadData()
        if isMultiSelect {
            delegate?.formInputView(self, didChange: values as AnyObject?)
        } else {
            delegate?.formInputView(self, didChange: values?[0] as AnyObject?)
        }
    }

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values?.count ?? 0
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Checkbox", for: indexPath)
        if let cell = cell as? SelectCheckboxCell {
            let value = values?[indexPath.row]
            cell.checkbox.value = value
            cell.checkbox.labelText = source?.title(for: value)
            cell.checkbox.delegate = self
            cell.checkbox.isRadioButton = !isMultiSelect
            cell.checkbox.isChecked = true
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.frame.width, height: 84)
        }
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView,
                                        viewForSupplementaryElementOfKind kind: String,
                                        at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
        if let view = view as? SearchKeyboardFooterView {
            view.searchKeyboard = self
        }
        return view
    }
}
