//
//  AppModelTests.swift
//  TwitterXTests
//
//  Created by Piyush Kant on 2021/04/11.
//

import XCTest
import TwitterX

class UserModelTests: XCTestCase {
    
    func testAppModel_whenInitialized_isInNotStartedState() {
        let initialState = "UserModelTests"
        XCTAssertEqual(initialState, "UserModelTests")
    }
}
