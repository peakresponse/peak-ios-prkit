//
//  MultiSelectKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/18/21.
//

import UIKit

public protocol MultiSelectKeyboardSource: UICollectionViewDataSource, UICollectionViewDelegate {
    func title(for value: String?) -> String?
}

open class MultiSelectCheckboxCell: UICollectionViewCell {
    weak var checkbox: Checkbox!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        let checkbox = Checkbox()
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkbox)
        NSLayoutConstraint.activate([
            checkbox.topAnchor.constraint(equalTo: contentView.topAnchor),
            checkbox.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            checkbox.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: checkbox.bottomAnchor)
        ])
        self.checkbox = checkbox
    }

}

open class MultiSelectKeyboardSourceWrapper<T: StringIterable>: NSObject, MultiSelectKeyboardSource {
    public func title(for value: String?) -> String? {
        if let value = value {
            return T.allCases.first(where: {$0.rawValue == value})?.description
        }
        return nil
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return T.allCases.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Checkbox", for: indexPath)
        if let cell = cell as? MultiSelectCheckboxCell {
            let value = T.allCases[T.allCases.index(T.allCases.startIndex, offsetBy: indexPath.row)]
            cell.checkbox.labelText = value.description
            cell.checkbox.value = value.rawValue
        }
        return cell
    }
}

open class MultiSelectKeyboard: UIInputView, FormFieldInputView, CheckboxDelegate,
                                UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var collectionView: UICollectionView!
    weak var delegate: FormFieldInputViewDelegate?
    var source: MultiSelectKeyboardSource?
    var values: [String]?

    public init() {
        super.init(frame: .zero, inputViewStyle: .keyboard)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MultiSelectCheckboxCell.self, forCellWithReuseIdentifier: "Checkbox")
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
        self.collectionView = collectionView
    }

    public func setValue(_ value: AnyObject?) {
        if let value = value as? [String] {
            self.values = value
        } else {
            self.values = nil
        }
        collectionView.reloadData()
    }

//    public func accessoryOtherButtonTitle() -> String? {
//        return "Button.search".localized
//    }
//
//    public func accessoryOtherButtonPressed(_ inputAccessoryView: FormInputAccessoryView) -> String? {
//        return nil
//    }

    public func checkbox(_ checkbox: Checkbox, didChange isChecked: Bool) {
        guard let value = checkbox.value as? String else { return }
        if isChecked {
            if values == nil {
                values = []
            }
            values?.append(value)
        } else if let index = values?.firstIndex(of: value) {
            values?.remove(at: index)
            if values?.isEmpty ?? false {
                values = nil
            }
        }
        delegate?.formFieldInputView(self, didChange: values as AnyObject?)
    }

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return source?.numberOfSections?(in: collectionView) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return source?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = source?.collectionView(collectionView, cellForItemAt: indexPath) ?? UICollectionViewCell()
        if let cell = cell as? MultiSelectCheckboxCell {
            cell.checkbox.delegate = self
            if let value = cell.checkbox.value as? String, values?.contains(value) ?? false {
                cell.checkbox.isChecked = true
            } else {
                cell.checkbox.isChecked = false
            }
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        if traitCollection.horizontalSizeClass == .regular {
            return CGSize(width: 335, height: 40)
        } else {
            return CGSize(width: frame.width - 40, height: 40)
        }
    }
}
