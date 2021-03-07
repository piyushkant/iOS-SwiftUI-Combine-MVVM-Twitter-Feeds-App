//
//  TweetEntities.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

struct TweetEntities: Decodable {
    let urls: [TweetUrl]
    
    enum CodingKeys: String, CodingKey {
        case urls = "urls"
    }
}
