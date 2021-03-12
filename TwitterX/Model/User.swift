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
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case name = "name"
        case screenName = "screen_name"
        case profileImageUrl = "profile_image_url_https"
    }
}
