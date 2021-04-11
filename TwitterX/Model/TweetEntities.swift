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

struct TweetUrl: Decodable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "expanded_url"
    }
}
