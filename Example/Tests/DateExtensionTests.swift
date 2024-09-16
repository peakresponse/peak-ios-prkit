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
        Date.nowFunc = {
            return ISO8601DateFormatter.date(from: "2024-09-16T18:14:39.613Z")!
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        Date.nowFunc = nil
    }

    func testAge() {
        var date = ISO8601DateFormatter.date(from: "1977-12-26")
        var (years, months, days) = date!.age
        XCTAssertEqual(years, 46)
        XCTAssertEqual(months, 8)
        XCTAssertEqual(days, 21)

        date = ISO8601DateFormatter.date(from: "2023-11-25")
        (years, months, days) = date!.age
        XCTAssertEqual(years, 0)
        XCTAssertEqual(months, 9)
        XCTAssertEqual(days, 22)

        date = ISO8601DateFormatter.date(from: "2024-09-07")
        (years, months, days) = date!.age
        XCTAssertEqual(years, 0)
        XCTAssertEqual(months, 0)
        XCTAssertEqual(days, 9)
    }

    func testAsISO8601DateString() {
        let date = Date(timeIntervalSince1970: 0)
        let dateString = date.asISO8601DateString()
        XCTAssertEqual(dateString, "1970-01-01")
    }
}
