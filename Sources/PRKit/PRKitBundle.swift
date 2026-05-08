//
//  PRKitBundle.swift
//  PRKit
//
//  Created by Francis Li on 12/8/21.
//

import Foundation
import UIKit

public class PRKitBundle {
    public static var instance: Bundle {
        return Bundle.module
    }

    public static func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: PRKitBundle.instance, compatibleWith: nil)
    }
}
