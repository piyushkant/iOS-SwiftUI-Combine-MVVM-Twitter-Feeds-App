//
//  HomeTimeline.swift
//  TwitterClient (iOS)
//
//  Created by Piyush Kant on 2021/03/05.
//

import Foundation

struct Tweet: Decodable {
    let id: Int
    let text: String
    let entities: TweetEntities
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case text = "text"
        case entities = "entities"
    }
}


//struct Tweet: Codable, Identifiable {
//    let id: Int
//    let text: String
////    let entities: TweetEntities
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case text = "text"
////        case entities = "entities"
//    }
//}


