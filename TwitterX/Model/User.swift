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
