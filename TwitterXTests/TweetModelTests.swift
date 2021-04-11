//
//  TweetModelTests.swift
//  TwitterXTests
//
//  Created by Piyush Kant on 2021/04/11.
//

import XCTest
@testable import TwitterX

class TweetModelTests: XCTestCase {
    var responseData: Data!
    
    override func setUpWithError() throws {
        guard
            let path = Bundle(for: type(of: self)).path(forResource: "tweet", ofType: "json")
        else { fatalError("Can't find tweet.json file") }
        
        self.responseData = try Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    func testTweet_response_data() throws {
        let response = try JSONDecoder().decode(Tweet.self, from: self.responseData)
        
        XCTAssertEqual(response.id, 1381121583658450946)
        XCTAssertEqual(response.idStr, "1381121583658450946")
        XCTAssertEqual(response.createdAt, "Sun Apr 11 05:47:00 +0000 2021")
        XCTAssertEqual(response.text, "These kinetic sculptures have brought these LEGO bricks to life https://t.co/kkltgHN8dr")
    
        XCTAssertEqual(response.entities.urls.count, 0)
      
        XCTAssertEqual(response.extendedEntities?.media.count, 1)
        
        let media = response.extendedEntities?.media.first
        XCTAssertEqual(media?.mediaUrl, "https://pbs.twimg.com/amplify_video_thumb/1268197315732529157/img/BbaQSUn_AhEW4H4f.jpg")
        
        
        XCTAssertEqual(media?.videoInfo?.variants.count, 4)
        XCTAssertEqual(media?.videoInfo?.variants.last?.bitrate, VideoBitrate.High.value)
        XCTAssertEqual(media?.videoInfo?.variants.last?.contentType, "video/mp4")
        XCTAssertEqual(media?.videoInfo?.variants.last?.url, "https://video.twimg.com/amplify_video/1268197315732529157/vid/1280x720/YkDEWJUMq8aHqYbk.mp4?tag=13")
        XCTAssertEqual(media?.additionalMediaInfo?.title, "This artist is breathing life into his LEGO sculptures")
        XCTAssertEqual(media?.additionalMediaInfo?.description, "Lego artist, Jason Allemann, creates mechanic and robotic kinetic sculptures made entirely out of the famous plastic bricks.")

        let user = response.user
        XCTAssertEqual(user.id, 972651)
        XCTAssertEqual(user.idStr, "972651")
        XCTAssertEqual(user.name, "Mashable")
        XCTAssertEqual(user.screenName, "mashable")
        XCTAssertEqual(user.profileImageUrl, "https://pbs.twimg.com/profile_images/1145679135873933312/OF0s1_Pe_normal.png")
        XCTAssertEqual(user.profileBannerUrl, "https://pbs.twimg.com/profile_banners/972651/1401484849")
        XCTAssertEqual(user.description, "Mashable is for superfans. We're not for the casually curious. Obsess with us.")
        XCTAssertEqual(user.followersCount, 9626860)
        XCTAssertEqual(user.friendsCount, 2733)
        XCTAssertEqual(user.following, true)
        XCTAssertEqual(user.url, "http://t.co/1Gm8aVACKn")
        XCTAssertEqual(user.entities.url?.urls.count, 1)

        let url = user.entities.url?.urls.first
        XCTAssertEqual(url?.url, "http://t.co/1Gm8aVACKn")
        XCTAssertEqual(url?.expandedUrl, "http://mashable.com")
        XCTAssertEqual(url?.displayUrl, "mashable.com")
    }
}
