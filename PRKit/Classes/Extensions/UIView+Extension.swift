//
//  UIView+Extension.swift
//  PRKit
//
//  Created by Francis Li on 11/1/19.
//

import UIKit

extension UIView {
    func addOutline(size: CGFloat, color: UIColor, opacity: Float) {
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: -size, y: -size, width: frame.width + 2 * size, height: frame.height + 2 * size), cornerRadius: layer.cornerRadius + size).cgPath
        layer.masksToBounds = false
    }
    
    func removeOutline() {
        removeShadow()
    }

    func addShadow(withOffset offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float) {
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowPath = nil
        layer.masksToBounds = false
    }

    func removeShadow() {
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shadowColor = nil
        layer.shadowOpacity = 0
        layer.shadowPath = nil
        layer.masksToBounds = true
    }
}
