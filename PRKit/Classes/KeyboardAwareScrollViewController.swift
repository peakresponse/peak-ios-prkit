//
//  KeyboardAwareScrollViewController.swift
//  PRKit
//
//  Created by Francis Li on 11/12/21.
//

import UIKit
import Keyboardy

public protocol KeyboardAwareScrollViewController: KeyboardStateDelegate {
    var view: UIView! { get set }
    var scrollView: UIScrollView! { get set }
    var scrollViewBottomConstraint: NSLayoutConstraint! { get set }
}

extension KeyboardAwareScrollViewController {

    // MARK: - KeyboardStateDelegate

    public func keyboardWillTransition(_ state: KeyboardState) {
    }

    public func keyboardTransitionAnimation(_ state: KeyboardState) {
        switch state {
        case .activeWithHeight(let height):
            scrollViewBottomConstraint.constant = -height
        case .hidden:
            scrollViewBottomConstraint.constant = 0
        }
        view.layoutIfNeeded()
    }

    public func keyboardDidTransition(_ state: KeyboardState) {
        if let firstResponder = scrollView.firstResponder, let superview = firstResponder.superview {
            var rect = superview.convert(firstResponder.frame, to: scrollView)
            rect.origin.y += 20
            scrollView.scrollRectToVisible(rect, animated: true)
        }
    }
}
