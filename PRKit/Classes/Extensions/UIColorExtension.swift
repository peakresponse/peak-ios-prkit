//
//  UIColor+Extension.swift
//  PRKit
//
//  Created by Francis Li on 3/10/20.
//

import UIKit

func colorForStyle(normalColor: UIColor, darkColor: UIColor? = nil) -> UIColor {
    if #available(iOS 13, *) {
        return UIColor { (traitCollection: UITraitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return darkColor ?? normalColor
            } else {
                return normalColor
            }
        }
    } else {
        return normalColor
    }
}

public extension UIColor {
    // MARK: - Backgrounds

    static var background: UIColor {
        return colorForStyle(normalColor: .base100, darkColor: .base800)
    }

    static var textBackground: UIColor {
        return colorForStyle(normalColor: .white, darkColor: .base700)
    }

    static var modalBackdrop: UIColor {
        return colorForStyle(normalColor: .base300, darkColor: .black)
    }

    static var header: UIColor {
        return colorForStyle(normalColor: .brandPrimary300, darkColor: .brandPrimary700)
    }

    static var dropShadow: UIColor {
        return colorForStyle(normalColor: .base500, darkColor: .base800)
    }

    static var highlight: UIColor {
        return colorForStyle(normalColor: .brandPrimary200, darkColor: .brandPrimary300)
    }

    static var errorHighlight: UIColor {
        return colorForStyle(normalColor: .brandSecondary400, darkColor: .brandSecondary450)
    }

    // MARK: - Borders

    static var border: UIColor {
        return colorForStyle(normalColor: .brandPrimary300, darkColor: .brandPrimary500)
    }

    static var focusedBorder: UIColor {
        return colorForStyle(normalColor: .brandPrimary500, darkColor: .brandPrimary400)
    }

    static var emptyBorder: UIColor {
        return colorForStyle(normalColor: .base500)
    }

    static var disabledBorder: UIColor {
        return colorForStyle(normalColor: .base300, darkColor: .base600)
    }

    // MARK: - Text

    static var text: UIColor {
        return colorForStyle(normalColor: .base800, darkColor: .base300)
    }

    static var headingText: UIColor {
        return colorForStyle(normalColor: .brandPrimary600, darkColor: .base300)
    }

    static var labelText: UIColor {
        return colorForStyle(normalColor: .base500, darkColor: .base400)
    }

    static var disabledLabelText: UIColor {
        return colorForStyle(normalColor: .base500)
    }

    static var focusedLabelText: UIColor {
        return colorForStyle(normalColor: .brandPrimary500, darkColor: .brandPrimary300)
    }

    static var placeholderText: UIColor {
        return colorForStyle(normalColor: .base300, darkColor: .base500)
    }

    static var interactiveText: UIColor {
        return colorForStyle(normalColor: .brandPrimary500, darkColor: .brandPrimary500)
    }

    static var highlightedInteractiveText: UIColor {
        return colorForStyle(normalColor: .brandPrimary600, darkColor: .brandPrimary600)
    }

    static var disabledInteractiveText: UIColor {
        return colorForStyle(normalColor: .brandPrimary700, darkColor: .brandPrimary700)
    }

    static var selectedInteractiveText: UIColor {
        return colorForStyle(normalColor: .white, darkColor: .white)
    }

    static var highlightedSelectedInteractiveText: UIColor {
        return colorForStyle(normalColor: .base100, darkColor: .base100)
    }

    static var error: UIColor {
        return .brandSecondary500
    }

    // MARK: - Primary Button

    static var primaryButtonNormal: UIColor {
        return colorForStyle(normalColor: .brandPrimary500, darkColor: .brandPrimary600)
    }

    static var primaryButtonLabelNormal: UIColor {
        return .white
    }

    static var primaryButtonHighlighted: UIColor {
        return colorForStyle(normalColor: .brandPrimary600, darkColor: .brandPrimary700)
    }

    static var primaryButtonDisabled: UIColor {
        return colorForStyle(normalColor: .base300, darkColor: .base500)
    }

    static var primaryButtonTint: UIColor {
        return colorForStyle(normalColor: .white, darkColor: nil)
    }

    // MARK: - Secondary Button

    static var secondaryButtonNormal: UIColor {
        return colorForStyle(normalColor: .white, darkColor: .base800)
    }

    static var secondaryButtonBorderNormal: UIColor {
        return colorForStyle(normalColor: .brandPrimary500, darkColor: nil)
    }

    static var secondaryButtonLabelNormal: UIColor {
        return colorForStyle(normalColor: .brandPrimary500, darkColor: .brandPrimary400)
    }

    static var secondaryButtonHighlighted: UIColor {
        return colorForStyle(normalColor: .brandPrimary100, darkColor: .base800)
    }

    static var secondaryButtonLabelHighlighted: UIColor {
        return colorForStyle(normalColor: .brandPrimary600, darkColor: .brandPrimary500)
    }

    static var secondaryButtonBorderHighlighted: UIColor {
        return colorForStyle(normalColor: .brandPrimary600, darkColor: nil)
    }

    static var secondaryButtonDisabled: UIColor {
        return colorForStyle(normalColor: .white, darkColor: .base800)
    }

    static var secondaryButtonBorderDisabled: UIColor {
        return colorForStyle(normalColor: .base300, darkColor: .base500)
    }

    static var secondaryButtonLabelDisabled: UIColor {
        return colorForStyle(normalColor: .base300, darkColor: .base500)
    }

    static var secondaryButtonTint: UIColor {
        return colorForStyle(normalColor: .brandPrimary500, darkColor: .brandPrimary400)
    }

    static var secondaryButtonTintDisabled: UIColor {
        return colorForStyle(normalColor: .base300, darkColor: .base500)
    }

    // MARK: - Destructive Button

    static var destructiveButtonNormal: UIColor {
        return colorForStyle(normalColor: .triageImmediateMedium, darkColor: nil)
    }

    static var destructiveButtonHighlighted: UIColor {
        return colorForStyle(normalColor: .triageImmediateDark, darkColor: nil)
    }

    static var destructiveButtonDisabled: UIColor {
        return colorForStyle(normalColor: .triageImmediateLight, darkColor: .base600)
    }

    static var destructiveButtonTint: UIColor {
        return colorForStyle(normalColor: .white, darkColor: nil)
    }

    // MARK: - Destructive Secondary Button

    static var destructiveSecondaryButtonNormal: UIColor {
        return colorForStyle(normalColor: .white, darkColor: .base800)
    }

    static var destructiveSecondaryButtonBorderNormal: UIColor {
        return colorForStyle(normalColor: .triageImmediateMedium, darkColor: nil)
    }

    static var destructiveSecondaryButtonLabelNormal: UIColor {
        return colorForStyle(normalColor: .triageImmediateMedium, darkColor: nil)
    }

    static var destructiveSecondaryButtonHighlighted: UIColor {
        return colorForStyle(normalColor: .triageImmediateLight, darkColor: .triageImmediateDark)
    }

    static var destructiveSecondaryButtonLabelHighlighted: UIColor {
        return colorForStyle(normalColor: .triageImmediateMedium, darkColor: nil)
    }

    static var destructiveSecondaryButtonBorderHighlighted: UIColor {
        return colorForStyle(normalColor: .triageImmediateMedium, darkColor: nil)
    }

    static var destructiveSecondaryButtonDisabled: UIColor {
        return colorForStyle(normalColor: .white, darkColor: .base800)
    }

    static var destructiveSecondaryButtonBorderDisabled: UIColor {
        return colorForStyle(normalColor: .triageImmediateLight, darkColor: .base500)
    }

    static var destructiveSecondaryButtonLabelDisabled: UIColor {
        return colorForStyle(normalColor: .triageImmediateLight, darkColor: .base500)
    }

    static var destructiveSecondaryButtonTint: UIColor {
        return colorForStyle(normalColor: .triageImmediateMedium, darkColor: nil)
    }

    static var destructiveSecondaryButtonTintDisabled: UIColor {
        return colorForStyle(normalColor: .triageImmediateLight, darkColor: nil)
    }

    // Helper for retrieving colors from the Assets xcassets bundle- providing an explicit Bundle
    // reference ensures this works in other contexts- including Interface Builder IBDesignable execution
    private static func named(_ name: String) -> UIColor {
        return UIColor(named: name, in: PRKitBundle.instance, compatibleWith: nil)!
    }

    static var base100: UIColor {
        return UIColor.named("Base100")
    }

    static var base300: UIColor {
        return UIColor.named("Base300")
    }

    static var base400: UIColor {
        return UIColor.named("Base400")
    }

    static var base500: UIColor {
        return UIColor.named("Base500")
    }

    static var base600: UIColor {
        return UIColor.named("Base600")
    }

    static var base700: UIColor {
        return UIColor.named("Base700")
    }

    static var base800: UIColor {
        return UIColor.named("Base800")
    }

    static var brandPrimary100: UIColor {
        return UIColor.named("BrandPrimary100")
    }

    static var brandPrimary200: UIColor {
        return UIColor.named("BrandPrimary200")
    }

    static var brandPrimary300: UIColor {
        return UIColor.named("BrandPrimary300")
    }

    static var brandPrimary400: UIColor {
        return UIColor.named("BrandPrimary400")
    }

    static var brandPrimary500: UIColor {
        return UIColor.named("BrandPrimary500")
    }

    static var brandPrimary600: UIColor {
        return UIColor.named("BrandPrimary600")
    }

    static var brandPrimary700: UIColor {
        return UIColor.named("BrandPrimary700")
    }

    static var brandPrimary900: UIColor {
        return UIColor.named("BrandPrimary900")
    }

    static var brandSecondary300: UIColor {
        return UIColor.named("BrandSecondary300")
    }

    static var brandSecondary400: UIColor {
        return UIColor.named("BrandSecondary400")
    }

    static var brandSecondary450: UIColor {
        return UIColor.named("BrandSecondary450")
    }

    static var brandSecondary500: UIColor {
        return UIColor.named("BrandSecondary500")
    }

    static var brandSecondary800: UIColor {
        return UIColor.named("BrandSecondary800")
    }

    static var triageMinimalLight: UIColor {
        return UIColor.named("TriageMinimalLight")
    }

    static var triageMinimalMedium: UIColor {
        return UIColor.named("TriageMinimalMedium")
    }

    static var triageImmediateLight: UIColor {
        return UIColor.named("TriageImmediateLight")
    }

    static var triageImmediateMedium: UIColor {
        return UIColor.named("TriageImmediateMedium")
    }

    static var triageImmediateDark: UIColor {
        return UIColor.named("TriageImmediateDark")
    }

    static var triageDelayedLight: UIColor {
        return UIColor.named("TriageDelayedLight")
    }

    static var triageDelayedMedium: UIColor {
        return UIColor.named("TriageDelayedMedium")
    }

    static var triageExpectantLight: UIColor {
        return UIColor.named("TriageExpectantLight")
    }

    static var triageExpectantMedium: UIColor {
        return UIColor.named("TriageExpectantMedium")
    }

    static var triageDeadLight: UIColor {
        return UIColor.named("TriageDeadLight")
    }

    static var triageDeadMedium: UIColor {
        return UIColor.named("TriageDeadMedium")
    }

    static var triageTransportedLight: UIColor {
        return UIColor.named("TriageTransportedLight")
    }

    static var triageTransportedMedium: UIColor {
        return UIColor.named("TriageTransportedMedium")
    }

    // deprecated legacy colors -------------------

    static var peakBlue: UIColor {
        return UIColor.named("PeakBlue")
    }

    static var darkPeakBlue: UIColor {
        return UIColor.named("DarkPeakBlue")
    }

    static var greyPeakBlue: UIColor {
        return UIColor.named("GreyPeakBlue")
    }

    static var bgBackground: UIColor {
        return UIColor.named("BgBackground")
    }

    static var mainGrey: UIColor {
        return UIColor.named("MainGrey")
    }

    static var lowPriorityGrey: UIColor {
        return UIColor.named("LowPriorityGrey")
    }

    static var gray2: UIColor {
        return UIColor(r: 79, g: 79, b: 79)
    }

    static var purple2: UIColor {
        return UIColor(r: 187, g: 107, b: 217)
    }

    static var green3: UIColor {
        return UIColor(r: 111, g: 207, b: 151)
    }

    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1.0)
    }

    func colorWithBrightnessMultiplier(multiplier: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: b * multiplier, alpha: a)
    }
}
