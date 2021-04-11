//
//  User.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/12.
//

import Foundation

struct User: Decodable {
    let id: Int
    let idStr: String
    let name: String
    let screenName: String
    let profileImageUrl: String
    let profileBannerUrl: String
    let description: String
    let followersCount: Int
    let friendsCount: Int
    let following: Bool
    let url: String?
    let entities: UserEntities
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case name = "name"
        case screenName = "screen_name"
        case profileImageUrl = "profile_image_url_https"
        case profileBannerUrl = "profile_banner_url"
        case description = "description"
        case followersCount = "followers_count"
        case friendsCount = "friends_count"
        case following = "following"
        case url = "url"
        case entities = "entities"
    }
}

struct UserEntities: Decodable {
    let url: UserUrl?
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        if values.contains(.url) {
            self.url = try values.decode(UserUrl.self, forKey: .url)
        } else {
            self.url = nil
        }
    }
}

struct UserUrl: Decodable {
    let urls: [UserProfileUrl]
    
    enum CodingKeys: String, CodingKey {
        case urls = "urls"
    }
}

struct UserProfileUrl: Decodable {
    let url: String
    let expandedUrl: String
    let displayUrl: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case expandedUrl = "expanded_url"
        case displayUrl = "display_url"
    }
}
