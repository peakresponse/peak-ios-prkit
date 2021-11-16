//
//  DateExtensionTests.swift
//  PRKit_Tests
//
//  Created by Francis Li on 11/16/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest

class DateExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAsISO8601DateString() {
        let date = Date(timeIntervalSince1970: 0)
        let dateString = date.asISO8601DateString()
        XCTAssertEqual(dateString, "1970-01-01")
    }
}
