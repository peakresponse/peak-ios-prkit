//
//  FormInputAccessoryView.swift
//  PRKit
//
//  Created by Francis Li on 11/12/21.
//

import UIKit

open class FormInputAccessoryView: UIInputView {
    open weak var nextButton: UIButton!
    open weak var prevButton: UIButton!
    open weak var doneButton: Button!
    open weak var otherButton: Button!

    open weak var rootView: UIView!
    open weak var currentView: UIView? {
        didSet { updateButtons() }
    }
    open weak var nextView: UIView?
    open weak var prevView: UIView?

    public init(rootView: UIView) {
        super.init(frame: .zero, inputViewStyle: .default)
        self.rootView = rootView
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        var newFrame = frame
        newFrame.size.height = 64
        self.frame = newFrame
        autoresizingMask = [.flexibleWidth]

        let row = UIStackView()
        row.translatesAutoresizingMaskIntoConstraints = false
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = 6
        addSubview(row)
        NSLayoutConstraint.activate([
            row.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            row.topAnchor.constraint(equalTo: topAnchor),
            row.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            bottomAnchor.constraint(equalTo: row.bottomAnchor)
        ])

        let prevNextView = UIView()
        row.addArrangedSubview(prevNextView)

        let prevButton = UIButton(type: .custom)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.setImage(UIImage(named: "ChevronUp40px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        prevButton.tintColor = .text
        prevButton.addTarget(self, action: #selector(prevPressed), for: .touchUpInside)
        prevNextView.addSubview(prevButton)
        NSLayoutConstraint.activate([
            prevButton.widthAnchor.constraint(equalToConstant: 44),
            prevButton.heightAnchor.constraint(equalToConstant: 44),
            prevButton.topAnchor.constraint(equalTo: prevNextView.topAnchor, constant: 10),
            prevButton.leftAnchor.constraint(equalTo: prevNextView.leftAnchor)
        ])
        self.prevButton = prevButton

        let nextButton = UIButton(type: .custom)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(UIImage(named: "ChevronDown40px", in: PRKitBundle.instance, compatibleWith: nil), for: .normal)
        nextButton.tintColor = .text
        nextButton.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        prevNextView.addSubview(nextButton)
        let nextButtonLeftConstraint = nextButton.leftAnchor.constraint(equalTo: prevButton.rightAnchor, constant: 10)
        nextButtonLeftConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 44),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
            nextButton.topAnchor.constraint(equalTo: prevButton.topAnchor),
            nextButton.leftAnchor.constraint(greaterThanOrEqualTo: prevButton.rightAnchor),
            nextButtonLeftConstraint,
            prevNextView.rightAnchor.constraint(greaterThanOrEqualTo: nextButton.rightAnchor)
        ])
        self.nextButton = nextButton

        let otherButtonView = UIView()
        row.addArrangedSubview(otherButtonView)
        let otherButton = Button()
        otherButton.translatesAutoresizingMaskIntoConstraints = false
        otherButton.setTitle("Button.done".localized, for: .normal)
        otherButton.style = .secondary
        otherButton.size = .small
        otherButton.isLayoutVerticalAllowed = false
        otherButton.addTarget(self, action: #selector(otherPressed), for: .touchUpInside)
        otherButtonView.addSubview(otherButton)
        NSLayoutConstraint.activate([
            otherButton.leftAnchor.constraint(greaterThanOrEqualTo: otherButtonView.leftAnchor),
            otherButton.rightAnchor.constraint(lessThanOrEqualTo: otherButtonView.rightAnchor),
            otherButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            otherButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        self.otherButton = otherButton

        let doneButtonView = UIView()
        row.addArrangedSubview(doneButtonView)
        let doneButton = Button()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Button.done".localized, for: .normal)
        doneButton.style = .primary
        doneButton.size = .small
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        doneButtonView.addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.rightAnchor.constraint(equalTo: doneButtonView.rightAnchor),
            doneButton.leftAnchor.constraint(greaterThanOrEqualTo: doneButtonView.leftAnchor),
            doneButton.centerYAnchor.constraint(equalTo: doneButtonView.centerYAnchor)
        ])
        self.doneButton = doneButton
    }

    open func traverse(view: UIView) {
        guard let currentView = currentView, currentView.tag > 0 else { return }
        if view.tag > 0 {
            if !view.isHidden && view.canBecomeFirstResponder {
                if view.tag > (prevView?.tag ?? 0) && view.tag < currentView.tag {
                    prevView = view
                }
                if view.tag < (nextView?.tag ?? Int.max) && view.tag > currentView.tag {
                    nextView = view
                }
            }
            return
        }
        for subview in view.subviews {
            traverse(view: subview)
        }
    }

    open func updateButtons() {
        prevView = nil
        nextView = nil
        traverse(view: rootView)
        prevButton.isEnabled = prevView != nil
        nextButton.isEnabled = nextView != nil
        if !prevButton.isEnabled && !nextButton.isEnabled {
            prevButton.isHidden = true
            nextButton.isHidden = true
        } else {
            prevButton.isHidden = false
            nextButton.isHidden = false
        }
        otherButton.isHidden = true
        if let currentView = currentView {
            if let formField = currentView as? FormField, let otherTitle = formField.inputAccessoryViewOtherButtonTitle {
                otherButton.isHidden = false
                otherButton.setTitle(otherTitle, for: .normal)
            } else if let inputView = currentView.inputView as? FormInputView, let otherTitle = inputView.accessoryOtherButtonTitle {
                otherButton.isHidden = false
                otherButton.setTitle(otherTitle, for: .normal)
            }
        }
    }

    @objc func prevPressed() {
        _ = prevView?.becomeFirstResponder()
    }

    @objc func nextPressed() {
        _ = nextView?.becomeFirstResponder()
    }

    @objc func donePressed() {
        _ = currentView?.resignFirstResponder()
    }

    @objc func otherPressed() {
        if let currentView = currentView {
            if let formField = currentView as? FormField, formField.inputAccessoryViewOtherButtonTitle != nil {
                (formField.delegate as? FormFieldDelegate)?.formFieldDidPressOther?(formField)
            } else if let inputView = currentView.inputView as? FormInputView {
                if let otherTitle = inputView.accessoryOtherButtonPressed(self) {
                    otherButton.setTitle(otherTitle, for: .normal)
                }
            }
        }
    }
}
