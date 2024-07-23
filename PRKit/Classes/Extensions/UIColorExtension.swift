//
//  UIColor+Extension.swift
//  PRKit
//
//  Created by Francis Li on 3/10/20.
//

import UIKit

public extension UIColor {
    // Semantic color definitions with Dark mode support
    static var background: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .base800
                } else {
                    return .base100
                }
            }
        } else {
            return .base100
        }
    }

    static var highlight: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .brandPrimary300
                } else {
                    return .brandPrimary200
                }
            }
        } else {
            return .brandPrimary200
        }
    }

    static var text: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .brandPrimary100
                } else {
                    return .brandPrimary500
                }
            }
        } else {
            return .brandPrimary500
        }
    }

    static var textBackground: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .base700
                } else {
                    return .white
                }
            }
        } else {
            return .white
        }
    }

    static var labelText: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .base300
                } else {
                    return .base500
                }
            }
        } else {
            return .base500
        }
    }

    static var focusedLabelText: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .brandPrimary300
                } else {
                    return .brandPrimary500
                }
            }
        } else {
            return .brandPrimary500
        }
    }

    static var placeholderText: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .base500
                } else {
                    return .base300
                }
            }
        } else {
            return .base300
        }
    }

    static var error: UIColor {
        return .brandSecondary500
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
