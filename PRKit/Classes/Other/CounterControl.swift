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
    open weak var decrButtonWidthConstraint: NSLayoutConstraint!
    open weak var incrButton: UIButton!
    open weak var incrButtonWidthConstraint: NSLayoutConstraint!
    open weak var topBorder: UIView!
    open weak var label: UILabel!
    open weak var countLabel: UILabel!
    open weak var countLabelTopConstraint: NSLayoutConstraint!
    open weak var bottomBorder: UIView!
    open weak var bottomBorderTopConstraint: NSLayoutConstraint!

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

    open override var isEnabled: Bool {
        get { return super.isEnabled }
        set {
            super.isEnabled = newValue
            updateState()
        }
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
        decrButton.titleLabel?.font = .h4SemiBold
        decrButton.setTitleColor(.white, for: .normal)
        addSubview(decrButton)
        let decrButtonWidthConstraint = decrButton.widthAnchor.constraint(equalToConstant: 85)
        NSLayoutConstraint.activate([
            decrButton.leftAnchor.constraint(equalTo: leftAnchor),
            decrButton.topAnchor.constraint(equalTo: topAnchor),
            decrButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            decrButtonWidthConstraint
        ])
        self.decrButton = decrButton
        self.decrButtonWidthConstraint = decrButtonWidthConstraint

        let incrButton = UIButton(type: .custom)
        incrButton.translatesAutoresizingMaskIntoConstraints = false
        incrButton.setImage(UIImage(named: "Plus40px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        incrButton.tintColor = .white
        incrButton.addTarget(self, action: #selector(incrPressed), for: .touchUpInside)
        addSubview(incrButton)
        let incrButtonWidthConstraint = incrButton.widthAnchor.constraint(equalToConstant: 85)
        NSLayoutConstraint.activate([
            incrButton.rightAnchor.constraint(equalTo: rightAnchor),
            incrButton.topAnchor.constraint(equalTo: topAnchor),
            incrButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            incrButtonWidthConstraint
        ])
        self.incrButton = incrButton
        self.incrButtonWidthConstraint = incrButtonWidthConstraint

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
        let countLabelTopConstraint = countLabel.topAnchor.constraint(equalTo: label.bottomAnchor)
        NSLayoutConstraint.activate([
            countLabel.leftAnchor.constraint(equalTo: decrButton.rightAnchor),
            countLabelTopConstraint,
            countLabel.rightAnchor.constraint(equalTo: incrButton.leftAnchor)
        ])
        self.countLabel = countLabel
        self.countLabelTopConstraint = countLabelTopConstraint

        let bottomBorder = UIView()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomBorder)
        let bottomBorderTopConstraint = bottomBorder.topAnchor.constraint(equalTo: countLabel.bottomAnchor)
        NSLayoutConstraint.activate([
            bottomBorder.leftAnchor.constraint(equalTo: decrButton.rightAnchor),
            bottomBorderTopConstraint,
            bottomBorder.rightAnchor.constraint(equalTo: incrButton.leftAnchor),
            bottomBorder.heightAnchor.constraint(equalToConstant: 4),
            bottomAnchor.constraint(equalTo: bottomBorder.bottomAnchor)
        ])
        self.bottomBorder = bottomBorder
        self.bottomBorderTopConstraint = bottomBorderTopConstraint

        updateColor()
    }

    open func updateColor() {
        decrButton.setBackgroundImage(UIImage.resizableImage(withColor: color, cornerRadius: 16, corners: [.topLeft, .bottomLeft]), for: .normal)
        incrButton.setBackgroundImage(UIImage.resizableImage(withColor: color, cornerRadius: 16, corners: [.topRight, .bottomRight]), for: .normal)
        topBorder.backgroundColor = color
        label.textColor = color
        bottomBorder.backgroundColor = color
        layer.borderColor = color.cgColor
    }

    open func updateState() {
        if isEnabled {
            decrButton.setImage(UIImage(named: "Minus40px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
            decrButton.setTitle(nil, for: .normal)
            decrButtonWidthConstraint.constant = 85
            incrButtonWidthConstraint.constant = 85
            topBorder.alpha = 1
            label.alpha = 1
            bottomBorder.alpha = 1
            countLabelTopConstraint.constant = 0
            bottomBorderTopConstraint.constant = 0
            layer.borderWidth = 0
        } else {
            decrButton.setImage(nil, for: .normal)
            decrButton.setTitle(label.text, for: .normal)
            decrButtonWidthConstraint.constant = floor(frame.width / 2)
            incrButtonWidthConstraint.constant = 0
            topBorder.alpha = 0
            label.alpha = 0
            bottomBorder.alpha = 0
            countLabelTopConstraint.constant = -12
            bottomBorderTopConstraint.constant = 12
            layer.borderWidth = 4
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateState()
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
