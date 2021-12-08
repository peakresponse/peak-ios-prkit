//
//  PRKitBundle.swift
//  PRKit
//
//  Created by Francis Li on 12/8/21.
//

import Foundation

public class PRKitBundle {
    public static var instance: Bundle {
        return Bundle(for: PRKitBundle.self)
    }
}
