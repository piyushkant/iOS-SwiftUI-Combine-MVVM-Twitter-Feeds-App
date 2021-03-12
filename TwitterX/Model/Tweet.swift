//
//  HomeTimeline.swift
//  TwitterClient (iOS)
//
//  Created by Piyush Kant on 2021/03/05.
//

import Foundation

struct Tweet: Decodable {
    let id: Int
    let idStr: String
    let createdAt: String
    let text: String
    let entities: TweetEntities
    let user: User
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case createdAt = "created_at"
        case text = "text"
        case entities = "entities"
        case user = "user"
    }
}


