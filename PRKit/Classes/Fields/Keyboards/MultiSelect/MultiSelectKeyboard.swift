//
//  MultiSelectKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/18/21.
//

import UIKit
import AlignedCollectionViewFlowLayout

public protocol MultiSelectKeyboardSource: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

    public static func sizeThatFits(_ width: CGFloat, with labelText: String) -> CGSize {
        return Checkbox.sizeThatFits(width, with: labelText)
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

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let value = T.allCases[T.allCases.index(T.allCases.startIndex, offsetBy: indexPath.row)]
        if collectionView.traitCollection.horizontalSizeClass == .regular {
            return MultiSelectCheckboxCell.sizeThatFits(335, with: value.description)
        } else {
            return MultiSelectCheckboxCell.sizeThatFits(collectionView.frame.width - 40, with: value.description)
        }
    }
}

open class MultiSelectKeyboard: FormInputView, CheckboxDelegate,
                                UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    open weak var collectionView: UICollectionView!
    open var source: MultiSelectKeyboardSource?
    open var values: [String]?

    public override init() {
        super.init()
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]

        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .justified, verticalAlignment: .top)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
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

        if traitCollection.horizontalSizeClass == .regular {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged),
                                                   name: UIDevice.orientationDidChangeNotification, object: nil)
        }
    }

    deinit {
        if traitCollection.horizontalSizeClass == .regular {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
    }

    func updateLayout() {
        guard traitCollection.horizontalSizeClass == .regular else { return }
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let cols = floor((collectionView.frame.width - 20) / 355)
            let edgeInset = floor((collectionView.frame.width - cols * 355 + 20) / 2)
            layout.sectionInset = UIEdgeInsets(top: 20, left: edgeInset, bottom: 20, right: edgeInset)
        }
    }

    @objc func orientationChanged() {
        updateLayout()
    }

    open override func reloadInputViews() {
        super.reloadInputViews()
        updateLayout()
    }

    open override func setValue(_ value: AnyObject?) {
        if let value = value as? [String] {
            self.values = value
        } else {
            self.values = nil
        }
        collectionView.reloadData()
    }

    open override func text(for value: AnyObject?) -> String? {
        return (value as? [String])?.compactMap({ source?.title(for: $0) }).joined(separator: "\n")
    }

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
        delegate?.formInputView(self, didChange: values as AnyObject?)
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
        return source?.collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ??
            CGSize(width: frame.width - 40, height: 40)
    }
}
