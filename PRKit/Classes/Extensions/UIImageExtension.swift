//
//  UIImageExtension.swift
//  PRKit
//
//  Created by Francis Li on 3/16/20.
//

import UIKit

extension UIImage {
    open func resizedTo(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }

    open func scaledBy(_ scale: CGFloat) -> UIImage {
        var size = self.size
        size.width = floor(size.width * scale)
        size.height = floor(size.height * scale)
        return resizedTo(size)
    }

    open func rounded() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        let cornerRadius = min(size.width / 2, size.height / 2)
        let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size),
                                byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        context.addPath(path.cgPath)
        context.clip()
        draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    public static func resizableImage(withColor color: UIColor, cornerRadius: CGFloat,
                                      borderColor: UIColor? = nil, borderWidth: CGFloat? = nil,
                                      corners: UIRectCorner = .allCorners) -> UIImage {
        let size = 2 * cornerRadius + 1
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size),
                                byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        context.addPath(path.cgPath)
        context.setFillColor(color.cgColor)
        context.fillPath()
        if let borderColor = borderColor, let borderWidth = borderWidth {
            // strokePath strokes centered, so clip and double width to stroke inner
            context.addPath(path.cgPath)
            context.clip()
            context.addPath(path.cgPath)
            context.setStrokeColor(borderColor.cgColor)
            context.setLineWidth(borderWidth * 2)
            context.strokePath()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius,
                                                                bottom: cornerRadius, right: cornerRadius))
    }
}
