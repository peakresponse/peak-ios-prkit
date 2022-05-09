//
//  CounterControl.swift
//  PRKit
//
//  Created by Francis Li on 5/5/22.
//

import UIKit

@IBDesignable
open class CounterControl: UIControl {
    open weak var decrButton: UIButton!
    open weak var incrButton: UIButton!
    open weak var topBorder: UIView!
    open weak var label: UILabel!
    open weak var countLabel: UILabel!
    open weak var bottomBorder: UIView!

    @IBInspectable open var color: UIColor = .base500 {
        didSet { updateColor() }
    }

    @IBInspectable open var labelText: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    @IBInspectable open var l10nKey: String? {
        didSet { labelText = l10nKey?.localized }
    }

    @IBInspectable open var min: Int = 0
    @IBInspectable open var max: Int = -1
    @IBInspectable open var count: Int {
        get { return Int(countLabel.text ?? "0") ?? 0 }
        set { countLabel.text = "\(newValue)" }
    }
    open var isChanged = false

    @IBInspectable open var isDebounced = true
    @IBInspectable open var debounceTime: Double = 0.3
    open var debounceTimer: Timer?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.masksToBounds = true

        let decrButton = UIButton(type: .custom)
        decrButton.translatesAutoresizingMaskIntoConstraints = false
        decrButton.setImage(UIImage(named: "Minus40px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        decrButton.tintColor = .white
        decrButton.addTarget(self, action: #selector(decrPressed), for: .touchUpInside)
        addSubview(decrButton)
        NSLayoutConstraint.activate([
            decrButton.leftAnchor.constraint(equalTo: leftAnchor),
            decrButton.topAnchor.constraint(equalTo: topAnchor),
            decrButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            decrButton.widthAnchor.constraint(equalToConstant: 85)
        ])
        self.decrButton = decrButton

        let incrButton = UIButton(type: .custom)
        incrButton.translatesAutoresizingMaskIntoConstraints = false
        incrButton.setImage(UIImage(named: "Plus40px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        incrButton.tintColor = .white
        incrButton.addTarget(self, action: #selector(incrPressed), for: .touchUpInside)
        addSubview(incrButton)
        NSLayoutConstraint.activate([
            incrButton.rightAnchor.constraint(equalTo: rightAnchor),
            incrButton.topAnchor.constraint(equalTo: topAnchor),
            incrButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            incrButton.widthAnchor.constraint(equalToConstant: 85)
        ])
        self.incrButton = incrButton

        let topBorder = UIView()
        topBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topBorder)
        NSLayoutConstraint.activate([
            topBorder.leftAnchor.constraint(equalTo: decrButton.rightAnchor),
            topBorder.topAnchor.constraint(equalTo: topAnchor),
            topBorder.rightAnchor.constraint(equalTo: incrButton.leftAnchor),
            topBorder.heightAnchor.constraint(equalToConstant: 4)
        ])
        self.topBorder = topBorder

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .h4SemiBold
        label.textAlignment = .center
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: decrButton.rightAnchor),
            label.topAnchor.constraint(equalTo: topBorder.bottomAnchor),
            label.rightAnchor.constraint(equalTo: incrButton.leftAnchor)
        ])
        self.label = label

        let countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.textColor = .base800
        countLabel.font = .h1Bold
        countLabel.textAlignment = .center
        addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.leftAnchor.constraint(equalTo: decrButton.rightAnchor),
            countLabel.topAnchor.constraint(equalTo: label.bottomAnchor),
            countLabel.rightAnchor.constraint(equalTo: incrButton.leftAnchor)
        ])
        self.countLabel = countLabel

        let bottomBorder = UIView()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        NSLayoutConstraint.activate([
            bottomBorder.leftAnchor.constraint(equalTo: decrButton.rightAnchor),
            bottomBorder.topAnchor.constraint(equalTo: countLabel.bottomAnchor),
            bottomBorder.rightAnchor.constraint(equalTo: incrButton.leftAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 4),
            bottomAnchor.constraint(equalTo: bottomBorder.bottomAnchor)
        ])
        self.bottomBorder = bottomBorder

        updateColor()
    }

    open func updateColor() {
        decrButton.setBackgroundImage(UIImage.resizableImage(withColor: color, cornerRadius: 16, corners: [.topLeft, .bottomLeft]), for: .normal)
        incrButton.setBackgroundImage(UIImage.resizableImage(withColor: color, cornerRadius: 16, corners: [.topRight, .bottomRight]), for: .normal)
        topBorder.backgroundColor = color
        label.textColor = color
        bottomBorder.backgroundColor = color
    }

    open func sendValueChanged() {
        if isDebounced {
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceTime, repeats: false, block: { [weak self] (_) in
                self?.sendActions(for: .valueChanged)
                self?.isChanged = false
            })
        } else {
            sendActions(for: .valueChanged)
            isChanged = false
        }
    }

    @objc func decrPressed() {
        if min < 0 || count > min {
            count -= 1
            isChanged = true
            sendValueChanged()
        }
    }

    @objc func incrPressed() {
        if max < 0 || count < max {
            count += 1
            isChanged = true
            sendValueChanged()
        }
    }
}
