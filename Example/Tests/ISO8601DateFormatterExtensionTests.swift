//
//  ISO8601DateFormatterExtensionTests.swift
//  PRKit_Tests
//
//  Created by Francis Li on 11/16/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest

class ISO8601DateFormatterExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDateFromString() throws {
        let date = ISO8601DateFormatter.date(from: "2021-10-31")
        print(date)
        XCTAssertNotNil(date)
        XCTAssertEqual(date?.asISO8601DateString(), "2021-10-31")
    }

}
