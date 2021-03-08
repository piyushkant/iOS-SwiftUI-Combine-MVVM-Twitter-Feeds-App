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
    let text: String
    let entities: TweetEntities
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idStr = "id_str"
        case text = "text"
        case entities = "entities"
    }
}


