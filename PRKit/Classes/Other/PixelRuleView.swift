//
//  PixelRuleView.swift
//  PRKit
//
//  Created by Francis Li on 3/3/22.
//

import UIKit

@IBDesignable
open class PixelRuleView: UIView {
    @IBInspectable open var lineColor: UIColor = .base300
    @IBInspectable open var top: Bool = false
    @IBInspectable open var right: Bool = false
    @IBInspectable open var bottom: Bool = true
    @IBInspectable open var left: Bool = false

    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
    }

    open override func draw(_ rect: CGRect) {
        // https://stackoverflow.com/questions/27385929/swift-uiview-draw-1-pixel-width-line
        let size = frame.size
        let scale = UIScreen.main.scale
        let strokeWidth = 1 / scale
        let offset = 0.5 - (Int(scale) % 2 == 0 ? 1 / (scale * 2) : 0)
        let context = UIGraphicsGetCurrentContext()!
        context.clear(rect)
        context.setLineWidth(strokeWidth)
        context.setStrokeColor(lineColor.cgColor)
        if top {
            context.beginPath()
            context.move(to: CGPoint(x: offset, y: offset))
            context.addLine(to: CGPoint(x: size.width - offset, y: offset))
            context.strokePath()
        }
        if right {
            context.beginPath()
            context.move(to: CGPoint(x: size.width - offset, y: offset))
            context.addLine(to: CGPoint(x: size.width - offset, y: size.height - offset))
            context.strokePath()
        }
        if bottom {
            context.beginPath()
            context.move(to: CGPoint(x: offset, y: size.height - offset))
            context.addLine(to: CGPoint(x: size.width - offset, y: size.height - offset))
            context.strokePath()
        }
        if left {
            context.beginPath()
            context.move(to: CGPoint(x: offset, y: offset))
            context.addLine(to: CGPoint(x: offset, y: size.height - offset))
            context.strokePath()
        }
    }
}
