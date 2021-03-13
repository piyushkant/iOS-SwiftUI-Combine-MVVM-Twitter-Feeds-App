//
//  TweetMedia.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/13.
//

import Foundation

struct TweetMedia: Decodable {
    let mediaUrl: String
    
    enum CodingKeys: String, CodingKey {
        case mediaUrl = "media_url_https"
    }
}
