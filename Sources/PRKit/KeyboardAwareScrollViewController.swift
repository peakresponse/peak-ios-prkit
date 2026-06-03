//
//  KeyboardAwareScrollViewController.swift
//  PRKit
//
//  Created by Francis Li on 11/12/21.
//

import UIKit
import Keyboardy

public protocol KeyboardAwareScrollViewController: KeyboardStateDelegate {
    var view: UIView! { get }
    var scrollView: UIScrollView! { get }
    var scrollViewBottomConstraint: NSLayoutConstraint! { get }
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
            let rect = superview.convert(firstResponder.frame, to: scrollView)
            UIView.animate(withDuration: 0.25, animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: rect.origin.y - self.scrollView.safeAreaInsets.top - 20)
            }) { _ in
                if let formComponent = firstResponder as? FormComponent {
                    formComponent.didScrollIntoView(self.scrollView)
                }
            }
        }
    }
}
