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
    let extendedEntities: TweetExtendedEntities?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case createdAt = "created_at"
        case text = "text"
        case entities = "entities"
        case user = "user"
        case extendedEntities = "extended_entities"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try values.decode(Int.self, forKey: .id)
        self.idStr = try values.decode(String.self, forKey: .idStr)
        self.createdAt = try values.decode(String.self, forKey: .createdAt)
        self.text = try values.decode(String.self, forKey: .text)
        self.entities = try values.decode(TweetEntities.self, forKey: .entities)
        self.user = try values.decode(User.self, forKey: .user)

        if values.contains(.extendedEntities) {
            self.extendedEntities = try values.decode(TweetExtendedEntities.self, forKey: .extendedEntities)
        } else {
            self.extendedEntities = nil
        }
    }
}


