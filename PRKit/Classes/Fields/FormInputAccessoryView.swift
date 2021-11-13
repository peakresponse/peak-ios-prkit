//
//  FormInputAccessoryView.swift
//  PRKit
//
//  Created by Francis Li on 11/12/21.
//

import UIKit

open class FormInputAccessoryView: UIView {
    open weak var nextButton: UIButton!
    open weak var prevButton: UIButton!
    open weak var doneButton: Button!

    open weak var rootView: UIView!
    open weak var currentView: UIView? {
        didSet { updateButtons() }
    }
    open weak var nextView: UIView?
    open weak var prevView: UIView?

    public init(rootView: UIView) {
        super.init(frame: .zero)
        self.rootView = rootView
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    open func commonInit() {
        var frame = frame
        frame.size.height = 64
        self.frame = frame
        autoresizingMask = [.flexibleWidth]
        backgroundColor = .base300

        let prevButton = UIButton(type: .custom)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.setImage(UIImage(named: "ChevronUp40px", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
        prevButton.tintColor = .base800
        prevButton.addTarget(self, action: #selector(prevPressed), for: .touchUpInside)
        addSubview(prevButton)
        NSLayoutConstraint.activate([
            prevButton.widthAnchor.constraint(equalToConstant: 44),
            prevButton.heightAnchor.constraint(equalToConstant: 44),
            prevButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            prevButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
        ])
        self.prevButton = prevButton

        let nextButton = UIButton(type: .custom)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setImage(UIImage(named: "ChevronDown40px", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
        nextButton.tintColor = .base800
        nextButton.addTarget(self, action: #selector(nextPressed), for: .touchUpInside)
        addSubview(nextButton)
        NSLayoutConstraint.activate([
            nextButton.widthAnchor.constraint(equalToConstant: 44),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
            nextButton.topAnchor.constraint(equalTo: prevButton.topAnchor),
            nextButton.leftAnchor.constraint(equalTo: prevButton.rightAnchor, constant: 20)
        ])
        self.nextButton = nextButton

        let doneButton = Button()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Button.done".localized, for: .normal)
        doneButton.style = .primary
        doneButton.size = .small
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        addSubview(doneButton)
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: nextButton.topAnchor),
            doneButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            doneButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        self.doneButton = doneButton
    }

    open func traverse(view: UIView) {
        guard let currentView = currentView, currentView.tag > 0 else { return }
        if view.tag > 0 {
            if view.canBecomeFirstResponder {
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
}
