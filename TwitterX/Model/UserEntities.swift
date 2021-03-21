//
//  UserEntities.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/21.
//

import Foundation

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
