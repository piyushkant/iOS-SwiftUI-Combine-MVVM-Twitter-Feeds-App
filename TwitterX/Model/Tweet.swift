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
    let extendedEntities: TweetExtendedEntities
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case createdAt = "created_at"
        case text = "text"
        case entities = "entities"
        case user = "user"
        case extendedEntities = "extended_entities"
    }
    
//    init(from decoder: Decoder) throws {
//            let values = try decoder.container(keyedBy: CodingKeys.self)
//
//            if values.contains(.extendedEntities) {
//                let age = try values.nestedContainer(keyedBy: AgeKeys.self, forKey: .age)
//                self.age = try age.decodeIfPresent(Int.self, forKey: .realAge)
//            } else {
//                self.age = nil
//            }
//        }
}


