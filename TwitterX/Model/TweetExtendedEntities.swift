//
//  TweetExtendedEntities.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/13.
//

import Foundation

struct TweetExtendedEntities: Decodable {
    let media: [TweetMedia]
    
    enum CodingKeys: String, CodingKey {
        case media = "media"
    }
}
