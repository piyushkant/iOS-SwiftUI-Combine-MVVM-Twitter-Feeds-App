//
//  AppModelTests.swift
//  TwitterXTests
//
//  Created by Piyush Kant on 2021/04/11.
//

import XCTest
@testable import TwitterX

class UserModelTests: XCTestCase {
    var responseData: Data!
    
    override func setUpWithError() throws {
        guard
            let path = Bundle(for: type(of: self)).path(forResource: "user", ofType: "json")
        else { fatalError("Can't find user.json file") }
        
        self.responseData = try Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    func testUser_response_data() throws {
        let response = try JSONDecoder().decode(User.self, from: self.responseData)
        
        XCTAssertEqual(response.id, 972651)
        XCTAssertEqual(response.idStr, "972651")
        XCTAssertEqual(response.name, "Mashable")
        XCTAssertEqual(response.screenName, "mashable")
        XCTAssertEqual(response.profileImageUrl, "https://pbs.twimg.com/profile_images/1145679135873933312/OF0s1_Pe_normal.png")
        XCTAssertEqual(response.profileBannerUrl, "https://pbs.twimg.com/profile_banners/972651/1401484849")
        XCTAssertEqual(response.description, "Mashable is for superfans. We're not for the casually curious. Obsess with us.")
        XCTAssertEqual(response.followersCount, 9626860)
        XCTAssertEqual(response.friendsCount, 2733)
        XCTAssertEqual(response.following, true)
        XCTAssertEqual(response.url, "http://t.co/1Gm8aVACKn")
        XCTAssertEqual(response.entities.url?.urls.count, 1)
        
        let url = response.entities.url?.urls.first
        XCTAssertEqual(url?.url, "http://t.co/1Gm8aVACKn")
        XCTAssertEqual(url?.expandedUrl, "http://mashable.com")
        XCTAssertEqual(url?.displayUrl, "mashable.com")
    }
    
    override func tearDownWithError() throws {
        self.responseData = nil
    }
}
