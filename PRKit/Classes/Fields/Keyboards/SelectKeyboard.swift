//
//  SelectKeyboard.swift
//  PRKit
//
//  Created by Francis Li on 11/18/21.
//

import UIKit
import AlignedCollectionViewFlowLayout

open class SelectCheckboxCell: UICollectionViewCell {
    open weak var checkbox: Checkbox!
    open var isLayoutCalculated = false

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

    open override func prepareForReuse() {
        super.prepareForReuse()
        isLayoutCalculated = false
    }

    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if !isLayoutCalculated {
            let title = checkbox.labelText ?? ""
            if traitCollection.horizontalSizeClass == .regular {
                var minWidth: CGFloat = 335
                if let width = superview?.frame.width {
                    minWidth = floor((width - 60) / 2)
                }
                layoutAttributes.size = SelectCheckboxCell.sizeThatFits(min(335, minWidth), with: title)
            } else {
                layoutAttributes.size = SelectCheckboxCell.sizeThatFits((superview?.frame.width ?? 320) - 40, with: title)
            }
            isLayoutCalculated = true
        }
        return layoutAttributes
    }
}

open class SelectKeyboard: FormInputView, CheckboxDelegate,
                           UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    open weak var collectionView: UICollectionView!
    open var source: KeyboardSource?
    open var values: [String]?
    open var isMultiSelect = false

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
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SelectCheckboxCell.self, forCellWithReuseIdentifier: "Checkbox")
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
        } else if let value = value as? String {
            self.values = [value]
        } else {
            self.values = nil
        }
        collectionView.reloadData()
    }

    open override func text(for value: AnyObject?) -> String? {
        if let value = value as? [String] {
            return value.compactMap({ text(for: $0 as AnyObject) }).joined(separator: "\n")
        }
        return source?.title(for: value as? String)
    }

    // MARK: - CheckboxDelegate

    public func checkbox(_ checkbox: Checkbox, didChange isChecked: Bool) {
        guard let value = checkbox.value as? String else { return }
        if isChecked {
            if isMultiSelect {
                if values == nil {
                    values = []
                }
                values?.append(value)
            } else {
                values = [value]
            }
        } else if let index = values?.firstIndex(of: value) {
            values?.remove(at: index)
            if values?.isEmpty ?? false {
                values = nil
            }
        }
        if isMultiSelect {
            delegate?.formInputView(self, didChange: values as AnyObject?)
        } else {
            collectionView.reloadData()
            delegate?.formInputView(self, didChange: values?[0] as AnyObject?)
        }
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
            cell.checkbox.labelText = text(for: cell.checkbox.value as AnyObject?)
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
}
